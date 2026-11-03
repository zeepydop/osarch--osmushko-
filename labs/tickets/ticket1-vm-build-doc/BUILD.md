# Test machines for a new developer: Ubuntu Server + Windows 11 in VirtualBox

This document rebuilds a two-machine test environment from nothing. You do not need to have used a hypervisor before. Follow the steps in order; each step has a screenshot, a reason for the choice, and a check so you know it worked.

## Step 0. Before you start

Check these on the computer that will host the VMs ("the host"):

1. **Hardware virtualization is on.**
   Windows: Task Manager → Performance → CPU → *Virtualization: Enabled*. Linux: `grep -cE 'vmx|svm' /proc/cpuinfo` prints a number above 0.
   *Why:* if it is off, a 64-bit guest will not start at all. If it is disabled, restart, enter UEFI setup (usually F2, F10, Del or Esc), turn on *Intel VT-x* / *SVM Mode* / *AMD-V*, save and restart.
2. **At least 60 GB free disk.** File Explorer → This PC.
   *Why:* a virtual disk is just a big file on your real disk. Windows needs 64 GB of virtual disk, Ubuntu 25 GB; both grow only as they fill up.
3. **Write down your host's real numbers:**
   CPU cores: `<N>`, total RAM: `<N> GB`, free disk: `<N> GB`.
   *Why:* every resource choice below is calculated from these numbers.

---

## Step 1. Install VirtualBox

1. Download VirtualBox from [virtualbox.org](https://www.virtualbox.org/wiki/Downloads) and install with the defaults.
2. Start it once to confirm it opens.
> Why VirtualBox?: it is free and runs on Windows, Linux and Intel Macs. The Extension Pack is **not** needed here; it has its own licence, so skip it.
> Check: the VirtualBox Manager window opens with an empty machine list.

---

## Step 2. Download the two ISO images

Keep both in a normal folder such as `Downloads`

1. **Ubuntu Server** (not Desktop): [ubuntu.com](https://ubuntu.com/download/server), the current **LTS** release, **amd64**. Version used: `<24.04.x>`. If you have Mac with Apple Silicon (M1, M2, M3, M4 …) you have ARM64, means you need another version [ubuntu.com](https://ubuntu.com/download/server/arm)
2. **Windows 11 Enterprise evaluation**: [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise) → Windows 11 Enterprise → ISO, 64-bit, English (United States).

>Why Server and not Desktop: the server image has no graphical desktop, so it uses far less RAM and disk. 
Why the evaluation ISO: it is free and legal for 90 days with no product key. Never enter a personal Windows key into a test VM and never download a "pre-activated" Windows.


> Check: two `.iso` files exist, roughly 2–3 GB (Ubuntu) and 5–7 GB (Windows).

---

## Step 3. Decide the resources (and write down why)

| Resource | Ubuntu Server | Windows 11 | Why |
|---|---|---|---|
| vCPU | 2 | 4 | Enough for both; never more than half of the host's `N` cores |
| Memory | <2 GB | >4 GB (4096 MB) | Windows 11's minimum is 4 GB, for it to boot up smoother it's best to give it a bit more; Ubuntu Server needs little |
| Disk | 25 GB, dynamically allocated | 64 GB, dynamically allocated | Windows 11's minimum is 64 GB; the file starts small and grows as needed |
| Network | NAT Network | NAT Network | See Step 4 |

**Calculation for this host:** host has 16 GB RAM. Windows alone idles at about 6 GB, so I leave the host at least 6 GB. The two guests take 4 + 4 = 8 GB, which leaves the host 8 GB.  Disk: 25 + 64 = 89 GB maximum out of X GB free; both disks are dynamic, so the real usage starts at a few GB.

>On the next following guiding screenshots you can see that during the setting the v.machine Windows, I give it everything I have(red line) which is not okay and the VM will likely freeze my laptop if I try to boot it. I still attached those as an example on how the settings look and where to put which. If you have the same problem, it's best to change your computer rather than trying to push through it, since windows will not accept any RAM less than 4096MB(4GB).
---

## Step 4. Create a shared network (do this before creating the VMs)

1. VirtualBox: **File → Tools → Network Manager → NAT Networks → Create**.
2. Keep the default name and make sure it is enabled.

[screenshots network](evidence/03-network-adapter)

Why **NAT Network** and not the alternatives:

- *Plain NAT* gives each VM its own private router, so the two guests cannot see each other.
- *Bridged* puts each guest directly on the real network, but on the campus Wi-Fi unknown MAC addresses are often dropped, so the guest may get no address. 
- *Host-only* has no internet.
- *NAT Network* gives both guests one shared network **and** internet access through the host.

> Check: the new network appears in the NAT Networks list with the box ticked.
---

## Step 5. Create the Ubuntu VM

1. **Machine → New**. Name: `ubuntu-test`. ISO Image: the Ubuntu Server ISO. Type: *Linux*, Version: *Ubuntu (64-bit)*.
2. Tick **Skip Unattended Installation**.
3. Base Memory: `your number`. Processors: `2`.
4. Hard disk: **Create a virtual hard disk now**, `25 GB`, leave *Pre-allocate Full Size* **unticked**.
5. Finish. Open **Settings → Network**: Adapter 1 → *Attached to:* **NAT Network** → choose the network from Step 4.

[screenshots vm](evidence/01-new-vm-wizard)
[screenshots disk](evidence/02-disk-settings)

> Why skip unattended installation: VirtualBox would otherwise install Ubuntu for you with its own choices, and you would never see the real installer. 
> Why not pre-allocate: the disk file stays small and grows only as data is written.
> Check: the machine `ubuntu-test` is in the list; Settings show 1900(<2GB) MB RAM, 2 CPUs, 25 GB disk.

---

## Step 6. Install Ubuntu Server

Start the VM and click inside the window to type in it. To get the mouse back, press the **Host key** (Right Ctrl by default).

1. Boot menu: **Try or Install Ubuntu Server**.
2. Language: English. Keyboard: English (US).
3. Type of install: **Ubuntu Server** (not minimized).
4. Network: the card should get an address automatically (DHCP), something like `10.0.2.x`. Continue.
5. Proxy: empty. Mirror: accept the default and wait for the test to pass.
6. Storage: **Use an entire disk**. Accept the summary and confirm. *This is the 25 GB virtual disk; your real disk is not touched.*
7. Profile: your name; server name `ubuntu-<workers name>`; a short lowercase username; a password you will remember (write it on paper).
8. Ubuntu Pro: skip. SSH: tick **Install OpenSSH server**. Featured snaps: select nothing.
9. Wait for *Installation complete!*, choose **Reboot Now**. If asked to remove the installation medium, press Enter.
10. Log in. Nothing appears while typing the password; that is normal.

> Check: you see a text login prompt (no graphical screen). If you see a graphical login, you installed Desktop; start again with the Server ISO.

---

## Step 7. Check the Linux guest and save the text evidence

Inside the VM run:

```
lsb_release -a
hostname
nproc
free -h
df -h /
ip -br a
uname -a
```

Expected: the Ubuntu version, your server name, 2 CPUs, your memory, about 25 GB disk, and an IP address on the network card.

To save the output on the host, add a port-forwarding rule (VirtualBox cannot reach a NAT Network guest directly): **File → Tools → Network Manager → NAT Networks → your network → Port Forwarding**, add: Host Port `2222`, Guest IP = Ubuntu's address(10.0.2.3), Guest Port `22`. 
[next text](evidence/04-guest-uname)

---

## Step 8. Take the clean snapshot

1. VM selected → **Snapshots** tab → **Take**. Name: `clean-install`.
2. Screenshot the snapshot list.

[screenshot](evidence/06-snapshot-list)

> Why now: a snapshot is a rollback point. Take it **before** anything is broken; anything done afterwards can be undone by restoring it.

> Check: the Snapshots tab lists `clean-install`.

---

## Step 9. Create the Windows 11 VM

1. **Machine → New**. Name: `windows-test`. ISO Image: the Windows ISO. Type: *Microsoft Windows*, Version: *Windows 11 (64-bit)*.
2. Tick **Skip Unattended Installation**.
3. Base Memory `5120` MB, Processors `4`.
4. Hard disk: **Create a virtual hard disk now**, `64 GB`, *Pre-allocate Full Size* unticked.
5. Finish. **Settings → System**: *Enable EFI* ticked, *TPM Version* v2.0, *Enable Secure Boot* ticked.
6. **Settings → Network**: Adapter 1 → **NAT Network**, the same network as Ubuntu.
[screenshots vm](evidence/01-new-vm-wizard)
[screenshots disk](evidence/02-disk-settings)

> Why these settings differ from the Linux VM: Windows 11 refuses to install without UEFI, Secure Boot and a TPM 2.0. Choosing "Windows 11" as the version makes VirtualBox switch these on for you; the check above confirms it.

> Check: Settings → System shows EFI, TPM v2.0 and Secure Boot all enabled.

---

## Step 10. Install Windows 11

1. Start the VM. At *"Press any key to boot from CD or DVD…"* click in the window and press a key quickly. If you miss it, restart the VM.
2. Language and keyboard: your choice → **Install now**.
3. Product key: **I don't have a product key**. Edition: **Windows 11 Enterprise (Evaluation)**.
4. Accept the licence → **Custom: Install Windows only** → select *Drive 0 Unallocated Space* → Next. Windows restarts several times; do **not** press a key at the "boot from CD" prompt again.
5. Setup screens: country, keyboard, skip the second keyboard.
6. Account: **Sign-in options → Domain join instead**, then create a **local account** (write the password on paper, not in the repository). If your build has no such option, use any Microsoft account.
7. Privacy settings: switch everything **off** → Accept.


> Why a local account: no personal Microsoft account is tied to a test machine. Why privacy off: it is a throw-away test VM and needs no telemetry.

> Check: the Windows desktop appears.

---

## Step 11. Install Guest Additions

1. In the VM window: **Devices → Insert Guest Additions CD image**.
2. In Windows: File Explorer → the DVD drive → run `VBoxWindowsAdditions.exe` → defaults → restart.

> Why: without it the screen does not fit the window and copy-paste between host and guest does not work, and Step 12 needs the clipboard.

> Check: after restart the screen resizes with the window and clipboard copy-paste works.
> Repeat step 8 with Windows program to have both machines a way to return
---

## Step 12. Find both addresses

Make sure **both** VMs use the same NAT Network. If you changed the network of a running Ubuntu VM, give it a new address: `sudo reboot`.

**Windows**: PowerShell:

```
ipconfig
ipconfig | Set-Clipboard
```

Note the IPv4 address (`10.0.2.15`).

**Ubuntu**:

```
ip -br a
```

Note the address on the network card, not `lo` (`10.0.2.3`). Save from the host:[next text](evidence/04-guest-uname)

> Why both are in the same subnet: that is what a NAT Network guarantees; guests on one network can reach each other directly.

> Check: both addresses start with the same first three numbers (`<e.g. 10.0.2.x>`) and are different from each other.

---

## Step 13. Ping both ways, and fix the firewall properly
[how it should look](05-ping-between-guests.txt)

**Windows → Ubuntu.** PowerShell: `ping 10.0.2.3`. Replies come back, because Ubuntu's firewall is off by default.

**Ubuntu → Windows.** On Ubuntu: `ping -c 4 10.0.2.15`. At first it **times out**.

> Why: ping sends an ICMP echo request, and Windows Defender Firewall blocks incoming echo requests by default (the network profile of a fresh VM is usually *Public*, the strictest; check with `Get-NetConnectionProfile`).

**The fix: one rule that allows exactly ping.** PowerShell **as Administrator**:

```
New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
```

Ping from Ubuntu again; replies now come back. Check the rule: `Get-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)"`.


> Why a rule and not "turn the firewall off": switching the firewall off also makes ping work, but it leaves the whole machine open. The rule opens exactly one thing.

> Check: `ping` works in both directions
---

## Step 14. Prove the internet works

- Ubuntu: `ping -c 4 ubuntu.com`
- Windows: `ping ubuntu.com`

> Check: both machines get replies from ubuntu.com.
[how it should look](ping-to-internet1.png)
[how it should look](ping-to-internet2.png)
---

## Done: final checklist

- [ ] Both VMs start and log in
- [ ] Both are on the same NAT Network and ping each other
- [ ] Both reach the internet
- [ ] Windows has the "Allow ping in (ICMPv4)" rule; the firewall is still on
- [ ] Snapshot `clean-install` exists on the Ubuntu VM
- [ ] No ISO, password or key is inside the repository
