# Lab 4 — Partition, mirror, fail, recover

Pair: Diana + Inzhu · Date: 15.11 - 16.11.26 · Hypervisor: VirtualBox 

## Windows
```powershell
PS C:\Users\Inzhu Diana> Get-Disk | Select Number, FriendlyName, PartitionStyle, Size

Number FriendlyName  PartitionStyle        Size
------ ------------  --------------        ----
     0 VBOX HARDDISK GPT            69020124160
     1 VBOX HARDDISK GPT             1073741824


PS C:\Users\Inzhu Diana> Get-Volume | Where FileSystemLabel -eq 'LAB04'

DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining       Size
----------- ------------ -------------- --------- ------------ ----------------- -------------       ----
E           LAB04        NTFS           Fixed     Healthy      OK                    989.23 MB 1007.93 MB
```
MBR or GPT: GPT, because Windows 11 boots using UEFI which requires GPT, and GPT stores backup partition table headers along with CRC32 checksums to protect against disk corruption.

## Linux — layout before and after
### Before
```text
NAME   SIZE TYPE FSTYPE MOUNTPOINTS
loop0  1.5M loop squashfs /snap/huctl/131
loop1 66.8M loop squashfs /snap/core24/1643
loop2  1.5M loop squashfs /snap/huctl/123
loop3 50.1M loop squashfs /snap/snapd/27710
sda     25G disk
├─sda1   1M part
└─sda2  25G part ext4   /
sdb      1G disk
sdc      1G disk
sdd      1G disk
sr0   1024M rom
```

### After
```text
NAME    SIZE TYPE  FSTYPE            MOUNTPOINTS
loop0  66.8M loop  squashfs          /snap/core24/1643
loop1   1.5M loop  squashfs          /snap/huctl/123
loop2   1.5M loop  squashfs          /snap/huctl/131
loop3  50.1M loop  squashfs          /snap/snapd/27710
sda      25G disk
├─sda1    1M part
└─sda2   25G part  ext4              /
sdb       1G disk
└─sdb1 1022M part  linux_raid_member
  └─md0 1021M raid1 ext4             /mnt/mirror
sdc       1G disk
└─sdc1 1022M part  linux_raid_member
sdd       1G disk
└─sdd1 1022M part  linux_raid_member
  └─md0 1021M raid1 ext4             /mnt/mirror
sr0    1024M rom
```

## What I did

# 1. Partition the three 1 GB disks for RAID
```
for d in sdb sdc sdd; do
  sudo parted -s /dev/\$d mklabel gpt mkpart primary 1MiB 100% set 1 raid on
done
```
# 2. Create RAID 1 array, format, and mount
```
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
sudo mkfs.ext4 -L mirror /dev/md0
sudo mkdir -p /mnt/mirror
sudo mount /dev/md0 /mnt/mirror
```
# 3. Simulate failure of sdc1 and remove it
```
sudo mdadm /dev/md0 --fail /dev/sdc1
sudo mdadm /dev/md0 --remove /dev/sdc1
```

# 4. Add third disk (sdd1) to rebuild the mirror
```
sudo mdadm /dev/md0 --add /dev/sdd1
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

## Three states

| State | What /proc/mdstat showed | File |
| --- | --- | --- |
| Healthy | `[2/2] [UU]` | [evidence/array-healthy.txt](evidence/array-healthy.txt) |
| Degraded | `[2/1] [U_]` | [evidence/array-degraded.txt](evidence/array-degraded.txt) |
| Rebuilt | `[2/2] [UU]`, `sdd1` replaced `sdc1` | [evidence/array-rebuilt.txt](evidence/array-rebuilt.txt) |

Checksums before and after the failure: They match ('e82d523b...' for 'proof.txt' and '5931a45d...' for 'random.bin' are identical in [evidence/checksum-before.txt](evidence/checksum-before.txt) and [evidence/checksum-after-failure.txt](evidence/checksum-after-failure.txt).)

## RAID is not a backup
No, RAID 1 does not help since it mirrors every 'write' and 'delete' across both disks in real time. Meaning, deleting a file immediately removes it from both drives simultaneously. To recover an accidentally deleted file, you need an independent versioned backup stored separately from the active array.

## What did not work the first time
1. When creating the virtual hard disks in VirtualBox, typing only the filename (`lab04-d1`) threw `The given path 'lab04-d1.vdi' is not fully qualified` until we specified the full folder path and set the size to `1.00 GB`.
2. In Ubuntu, pasting the 'parted' command without a space (-s/dev/$d) caused `invalid option -- '/'`, and a typo (/dev/sbd instead of /dev/sdb) returned `No such file or directory`.
3. When saving the initial SHA-256 hash file, we misspelled the filename as 'cheksum-before.txt' (missing the 'c'), which caused `No such file or directory` until we checked the exact filename in 'evidence/'.
