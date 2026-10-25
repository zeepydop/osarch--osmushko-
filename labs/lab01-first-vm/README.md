# Lab 1 — Your first virtual machine

Pair: Diana Osmushko                    Driver first half: Diana
Machine: Oracle VirtualBox
Date: 20.10.26 - 25.10.26(26.10.26)

## What I did
 I followed the instructions in the step-by-step guide

1. Installed Oracle VirtualBox- 7.2.20-175154-Win.
2. Created VM lab01-ubuntu: 1 vCPU, 1513 MB RAM, 25 GB dynamic disk, NAT.
3. Installed Ubuntu Server, took snapshot clean-install.
4. Broke it:
```
sudo sed -i 's/dhcp4: true/dhcp4: false/' /etc/netplan/*.yaml
sudo netplan apply
ip -br a 
ping -c 3 ubuntu.com
``` 
6. Rolled back to clean-install:
```
ip -br a 
ping -c 3 ubuntu.com
```

## Result
The VM boots; the break-and-rollback cycle is shown in the evidence below.
## What did not work the first time
It was crashing every time & the last part of the installation took ages to complete; had to delete and reinstall whole Ubuntu Server to understand what was going wrong.
 I think i might've given too little space on the dynamic disk(the first time it was 15 GB, so when i redone everything i gave it 25GB and it finally worked)

## Evidence

- [evidence/](evidence/) — one line per file on what it proves
