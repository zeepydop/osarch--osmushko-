# Ticket 1 — “VM build document”

## 1. What was asked
```
From: Aigerim T. (Office Manager)
Subject: test machine for new dev
Hi, we have someone starting on Monday and he needs a test computer
set up. Nothing special, just so he can try things without breaking
anything. Can you write down how to do it so I can do the next one
myself? Thanks
```

## 2. What was actually needed

**What the request left out but the job requires**

- Which operating systems? "A test computer" does not say Linux or Windows. I assumed the developer needs one of each, so the environment has an Ubuntu Server VM and a Windows 11 VM. 
- Where it runs and with what resources? The request gives no hardware. The VMs share one host, so the numbers had to come from the host itself: N cores, N GB RAM, N GB free disk. Allocation: Ubuntu 2 vCPU, 2 GB RAM / 25 GB disk; Windows >4 GB RAM / 64 GB disk, 4-6 vCPU. 
- Network. The two machines must see each other and the internet. That has to be designed (a shared NAT Network), not left to defaults.
- Licensing. The Windows used is the Microsoft evaluation edition. It is legal and free, but it expires after 90 days. Whoever builds the next one needs to know this, and no personal Windows key should ever go into a test machine.
- A way back. "Without breaking anything" is not a property of a VM by itself. It exists only because a snapshot was taken before anything was changed.

**Where the request is wrong**

- "A test computer" suggests a separate physical machine. A virtual machine on an existing laptop does the same job at no extra cost and can be reset in seconds.
- "Nothing special" is not quite true: virtualization must be enabled in UEFI, there must be 40+ GB of free disk, and the Windows VM needs UEFI, Secure Boot and TPM 2.0.
- "So I can do the next one myself": the reader of the document is a non-technical office manager, so BUILD.md is written for someone who has never opened a hypervisor, with a screenshot and a reason at every step.

**What I would have asked, and what I assumed instead**

| Question I would have asked | What I assumed |
|---|---|
| Which OS does the developer actually work with? | Both Linux (Ubuntu Server) and Windows 11 |
| What computer will this run on, and how much RAM and disk does it have? | My own laptop's real numbers |
| Does it need to reach any internal company system? | No, internet access only |


## 3. What I did

Full step-by-step instructions with screenshots are in [BUILD.md](BUILD.md). Summary:

1. Recorded the host's numbers and confirmed hardware virtualization is on.
2. Installed VirtualBox and downloaded both ISOs Ubuntu Server LTS ; Windows 11 Enterprise evaluation.
3. Created one **NAT Network** so both VMs share a network and have internet.
4. Built the Ubuntu Server VM (2 vCPU, <2 GB RAM, 25 GB dynamic disk)
5. Built the Windows 11 VM (4 vCPU, 4 GB RAM, 65 GB dynamic disk, EFI + Secure Boot + TPM 2.0), installed it with a local account, then installed Guest Additions.
6. Recorded both IP addresses, tested ping in both directions, and tested internet from each guest.

**Settings that differ from the defaults, and why**

| Setting | Value | Why |
|---|---|---|
| Skip Unattended Installation | ticked | VirtualBox would hide the real installer and choose for me |
| Network (both VMs) | NAT Network | Plain NAT gives each VM its own router (they cannot see each other); bridged is often blocked on campus Wi-Fi; host-only has no internet |
| Memory (Ubuntu) | <2 GB | I do not have enough space on my laptop, therefore couldn't show it correctly, but i did note this dilemma in BUILD.md |
| Memory (Windows) | ~5120 MB | Windows 11's minimum is 4096MB, but I adviced to give a bit more since the program might not boot up|
| Disk | 25 GB / 64 GB, dynamic | Minimums for each OS; files start small and grow |
| Windows account | local account | No personal Microsoft account on a test machine |
| Windows privacy options | all off | Test machine, no telemetry needed |


**One thing that went wrong, and how I resolved it**

- My laptop didn't fit the criteria so I took evidence supporting the Windows setup from partnering up with Inzhu, Group 6
- During setting up, we assumed that the Windows additions hadn't been installed properly and were stuck without ctrl+c/v, but after a while we discovered that there was a setting to turn it on both ways(from host to vm and back) and as we did it finally worked 

## 4. Evidence

| File | What it proves |
|---|---|
| [evidence/01-new-vm-wizard](evidence/01-new-vm-wizard) | The VM was created with the intended name, OS type and resources |
| [evidence/02-disk-settings](evidence/02-disk-settings) | The virtual disk size and that it is dynamically allocated |
| [evidence/03-network-adapter](evidence/03-network-adapter) | NATNetwork network, where to connect |
| [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt) | guestuname |
| [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) | The guests reach each other and the internet |
| [evidence/06-snapshot-list](evidence/06-snapshot-list) |  A way back for the worker |

## 5. What I would do differently

- I would ask Aigerim the needed questions in section 2 before starting instead of assuming.
- I would write down the Windows evaluation expiry date in the document, since the next person will otherwise be surprised after 90 days.
- I would advice Aigerim not to trust someone like me, since I'm a newbie :P
