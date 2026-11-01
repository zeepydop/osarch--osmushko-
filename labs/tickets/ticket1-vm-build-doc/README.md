# Ticket 1 — “New developer starts Monday, needs a test machine”

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
4. Built the Ubuntu Server VM (2 vCPU, 2 GB RAM, 25 GB dynamic disk)
5. Built the Windows 11 VM (4 vCPU, 5 GB RAM, 64 GB dynamic disk, EFI + Secure Boot + TPM 2.0), installed it with a local account, then installed Guest Additions.
6. Recorded both IP addresses, tested ping in both directions, and tested internet from each guest.

**Settings that differ from the defaults, and why**

| Setting | Value | Why |
|---|---|---|
| Skip Unattended Installation | ticked | VirtualBox would hide the real installer and choose for me |
| Network (both VMs) | NAT Network | Plain NAT gives each VM its own router (they cannot see each other); bridged is often blocked on campus Wi-Fi; host-only has no internet |
| Memory (Ubuntu) | <2 GB | I do not have enough space |
| Memory (Windows) | ~5120 MB | Windows 11's minimum is 4096MB, it's better to giveit a bit more |
| Disk | 25 GB / 64 GB, dynamic | Minimums for each OS; files start small and grow |
| Windows account | local account | No personal Microsoft account on a test machine |
| Windows privacy options | all off | Test machine, no telemetry needed |


**One thing that went wrong, and how I resolved it**

My laptop didn't fit the criteria so I took evidence supporting the Windows setup from partnering up with Inzhu, Group 6

## 4. Evidence

| File | What it proves |
|---|---|
| [evidence/01-new-vm-wizard.png](evidence/01-new-vm-wizard.png) | The VM was created with the intended name, OS type and resources |
| [evidence/02-disk-settings.png](evidence/02-disk-settings.png) | The virtual disk size and that it is dynamically allocated |
| [evidence/03-network-adapter.png](evidence/03-network-adapter.png) | network |
| [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt) | guestuname |
| [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) | The guests reach each other and the internet |
| [evidence/06-snapshot-list.png](evidence/06-snapshot-list.png) |  snapshots |

## 5. What I would do differently

- I would ask Aigerim the needed questions in section 2 before starting instead of assuming.
- I would write down the Windows evaluation expiry date in the document, since the next person will otherwise be surprised after 90 days. 
