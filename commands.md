
## Part 1: Checkpoint 1 Exam Playbook (Ubuntu, Git Bash, PowerShell)

### 1.1 Host Specs & SSH Access (Task 1 & Task 2)
*Used to inspect your host machine for Task 1 and copy terminal output cleanly in Task 2.*

**Connect & Copy via SSH (PowerShell / Git Bash):**
```bash
ssh <username>@localhost -p 2222
# Or using your VirtualBox host-only/bridged IP:
ssh <username>@<guest-ip>

# Copy a file from Ubuntu guest to your current host folder:
scp -P 2222 <username>@localhost:/path/to/file .
```

**Check Host Specs (Task 1 Comparison):**
* **PowerShell (Windows):**
  ```powershell
  systeminfo | findstr /B /C:"OS Name" /C:"Total Physical Memory"
  Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
  Get-PhysicalDisk | Select-Object FriendlyName, MediaType, Size
  ```
* **Git Bash / Linux Host:**
  ```bash
  lscpu | grep -E "Model name|CPU\(s\):"
  free -h
  lsblk
  ```

### 1.2 Storage & Permanent Mounting (Task 2 & Task 3)
*Used to inspect disks, format a new virtual drive, and mount it permanently at `/data`.*

```bash
# Inspect block devices & mounts
lsblk -f                  # List disks, partitions, filesystems, and UUIDs
df -h                     # Check disk space usage on mounted filesystems
findmnt /data             # Verify if anything is currently mounted at /data
cat /etc/fstab            # View permanent mount configuration

# Partition, format & test mount a new disk (e.g., /dev/sdb)
sudo fdisk /dev/sdb       # Press: n -> p -> 1 -> Enter -> Enter -> w
sudo mkfs.ext4 /dev/sdb1
sudo mkdir -p /data
sudo mount /dev/sdb1 /data

# Make mount permanent in /etc/fstab
sudo blkid /dev/sdb1      # Copy the UUID value
sudo cp /etc/fstab /etc/fstab.bak
echo "UUID=<UUID> /data ext4 defaults 0 2" | sudo tee -a /etc/fstab

# Verify fstab without rebooting (CRITICAL: catches errors before reboot)
sudo umount /data
sudo mount -a
findmnt /data
```

### 1.3 Network & Memory Diagnostics (Task 3)
*Used to trace connectivity, firewall, OOM killer, and encoding cases.*

```bash
# Network layer checks
ip -br addr                 # Brief overview of interfaces (UP/DOWN) and IPs
ip link show enp0s3         # Detailed link state (NO-CARRIER = cable unplugged in VirtualBox)
sudo ip link set enp0s3 up  # Bring interface up manually
sudo dhclient enp0s3        # Request IP via DHCP
ip route                    # Check default gateway (missing = no internet route)
ping -c 3 8.8.8.8           # Test raw IP connectivity (bypasses DNS)
ping -c 3 google.com        # Test DNS resolution + connectivity
cat /etc/resolv.conf        # Check configured DNS servers
sudo ufw status verbose     # Check Ubuntu firewall rules

# Memory, CPU & OOM killer checks
free -h                     # View RAM and Swap usage
vmstat 1 5                  # Watch virtual memory, swap in/out (si/so), and CPU every 1s
swapon --show               # Verify active swap
sysctl vm.overcommit_memory # Check kernel overcommit mode (0=heuristic, 1=always, 2=strict)
sudo dmesg -T | grep -i -E "oom|killed process"  # Check if OOM killer terminated an app
lscpu && nproc              # Check guest vCPUs and architecture

# File encoding & line endings (Lab 5)
file -i <filename>          # Detect MIME type and encoding (UTF-8, ISO-8859-1, etc.)
iconv -f ISO-8859-1 -t UTF-8 input.txt -o output.txt
dos2unix <filename>         # Convert Windows CRLF line endings to Unix LF
```

---

## Part 2: Cross-Platform Command Reference (Appendix B)

### B.1 Files and Directories

| Task | CMD | bash | PowerShell |
| :--- | :--- | :--- | :--- |
| **List a directory** | `dir` | `ls -l` | `Get-ChildItem` |
| **Where am I** | `cd` | `pwd` | `Get-Location` |
| **Change directory** | `cd path` | `cd path` | `Set-Location path` |
| **Create a directory** | `mkdir name` | `mkdir name` | `New-Item -ItemType Directory name` |
| **Copy a file** | `copy a b` | `cp a b` | `Copy-Item a b` |
| **Copy a whole tree** | `robocopy a b /e` | `cp -r a b` | `Copy-Item a b -Recurse` |
| **Move or rename** | `move / ren` | `mv a b` | `Move-Item / Rename-Item` |
| **Delete a file** | `del file` | `rm file` | `Remove-Item file` |
| **Delete a tree** | `rmdir /s /q dir` | `rm -rf dir` | `Remove-Item dir -Recurse -Force` |
| **Show a file** | `type file` | `cat file` | `Get-Content file` |
| **Page through a file** | `more file` | `less file` | `Get-Content file \| more` |
| **Find text inside files** | `findstr "x" *.log` | `grep "x" *.log` | `Select-String "x" *.log` |
| **Find files by name** | `dir /s /b *.log` | `find . -name "*.log"` | `Get-ChildItem -Recurse -Filter *.log` |
| **Disk space** | `fsutil volume diskfree c:` | `df -h` | `Get-Volume` |

### B.2 Text, Pipes and Redirection

| Task | CMD | bash | PowerShell |
| :--- | :--- | :--- | :--- |
| **Send output to a file** | `cmd > file` | `cmd > file` | `cmd > file` |
| **Append to a file** | `cmd >> file` | `cmd >> file` | `cmd \| Add-Content file` |
| **Send errors too** | `cmd > f 2>&1` | `cmd > f 2>&1` | `cmd *> f` |
| **Pipe to another command** | `cmd1 \| cmd2` | `cmd1 \| cmd2` | `cmd1 \| cmd2` |
| **What travels in the pipe** | text | text | objects |
| **Filter rows** | `findstr` | `grep / awk` | `Where-Object` |
| **Pick columns or fields** | — | `cut -d, -f2 / awk` | `Select-Object Name,Id` |
| **Sort** | `sort` | `sort` | `Sort-Object` |
| **Unique values** | — | `sort \| uniq` | `Sort-Object -Unique` |
| **Count lines** | `find /c /v ""` | `wc -l` | `Measure-Object -Line` |
| **Search and replace in text** | — | `sed s/a/b/g` | `-replace "a","b"` |

> **The one difference that matters:** CMD and bash pass **text** between commands; PowerShell passes **objects**. In bash you extract the third column with `cut` or `awk` because all you have is a line of characters. In PowerShell you ask for a property by name, because the thing in the pipe already knows what it is.

### B.3 Processes, Services and System

| Task | CMD | bash | PowerShell |
| :--- | :--- | :--- | :--- |
| **List processes** | `tasklist` | `ps aux` | `Get-Process` |
| **Live process view** | — | `top / htop` | `Get-Process \| Sort CPU -Desc` |
| **Kill a process** | `taskkill /PID n /F` | `kill -9 n` | `Stop-Process -Id n -Force` |
| **List services** | `sc query` | `systemctl list-units --type=service` | `Get-Service` |
| **Start a service** | `net start X` | `sudo systemctl start X` | `Start-Service X` |
| **Enable at boot** | `sc config X start=auto` | `sudo systemctl enable X` | `Set-Service X -StartupType Automatic` |
| **Read the logs** | `eventvwr` | `journalctl -xe` | `Get-WinEvent -LogName System` |
| **Run as administrator** | `runas /user:…` | `sudo cmd` | `Start-Process -Verb RunAs` |
| **Environment variable** | `%PATH% / set` | `$PATH / export` | `$env:PATH` |
| **Command history** | `doskey /history` | `history` | `Get-History` |
| **Clear the screen** | `cls` | `clear` | `Clear-Host` |
| **Get help** | `cmd /?` | `man cmd` | `Get-Help cmd -Examples` |
| **Schedule a job** | `schtasks` | `crontab -e` | `Register-ScheduledTask` |

### B.4 Networking

| Task | CMD | bash | PowerShell |
| :--- | :--- | :--- | :--- |
| **Interface configuration** | `ipconfig /all` | `ip addr` | `Get-NetIPConfiguration` |
| **Test reachability** | `ping host` | `ping host` | `Test-Connection host` |
| **Trace the route** | `tracert host` | `traceroute / mtr host` | `Test-NetConnection -TraceRoute` |
| **DNS lookup** | `nslookup name` | `dig name / host name` | `Resolve-DnsName name` |
| **Flush the DNS cache** | `ipconfig /flushdns` | `sudo resolvectl flush-caches` | `Clear-DnsClientCache` |
| **Open ports and sockets** | `netstat -ano` | `ss -tulpn` | `Get-NetTCPConnection` |
| **Is this port open** | — | `nc -zv host 443` | `Test-NetConnection host -Port 443` |
| **Download a file** | `curl -O url` | `curl -O url / wget url` | `Invoke-WebRequest url -OutFile f` |

### B.5 Users, Groups and Permissions

| Task | CMD | bash | PowerShell |
| :--- | :--- | :--- | :--- |
| **Who am I** | `whoami` | `whoami / id` | `whoami` |
| **List users** | `net user` | `cat /etc/passwd` | `Get-LocalUser` |
| **Create a user** | `net user n p /add` | `sudo useradd -m n` | `New-LocalUser n` |
| **Disable a user** | `net user n /active:no` | `sudo usermod -L n` | `Disable-LocalUser n` |
| **List groups** | `net localgroup` | `cat /etc/group / groups` | `Get-LocalGroup` |
| **Add user to a group** | `net localgroup g n /add` | `sudo usermod -aG g n` | `Add-LocalGroupMember g n` |
| **View permissions** | `icacls file` | `ls -l file` | `Get-Acl file` |
| **Change permissions** | `icacls file /grant…` | `chmod 640 file` | `Set-Acl` |
| **Change owner** | `takeown /f file` | `sudo chown u:g file` | `Set-Acl (owner)` |

---

## Part 3: Bash Scripting in One Page (Appendix C)

### C.1 The Skeleton Every Script Starts From
```bash
#!/usr/bin/env bash
set -euo pipefail

# -e           stop on the first command that fails
# -u           stop if an undefined variable is used
# -o pipefail  a pipeline fails if any stage fails

usage() { echo "usage: $0 <username>" >&2; exit 2; }
[[ $# -eq 1 ]] || usage

username="$1"
echo "Creating $username"
```
Make it executable and run it:
```bash
chmod +x onboard.sh
./onboard.sh aigerim
```

> **Three rules that separate a script from a liability:**
> 1. Put `set -euo pipefail` at the top so failed commands don't silently continue with bad data.
> 2. Quote every variable (`"$file"`, never `$file`) so spaces don't split into two arguments.
