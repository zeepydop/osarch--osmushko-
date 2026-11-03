# Lab 2 — A Windows guest, and a network between them

Pair: Diana O. / Inzhu   Driver first half: Inzhu
Machine: <your laptop, OS, RAM, cores>, guests Ubuntu Server + Windows 11 Enterprise eval
Date: 01.11.2026-03.11.2026

## What I did
1. Downloaded Windows 11 Enterprise evaluation. Licence: [Evaluation Center link](https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise)
2. Created lab02-windows: 4 vCPU, ~5120 MB, 64 GB thin, UEFI + Secure Boot, vTPM.
3. Network mode: NAT, NATNetwork, both guests. Why: I used NAT Network because both guests must see each other and the internet, and bridged mode is blocked on campus Wi-Fi.
4. Ping Ubuntu → Windows timed out because <why>. Fixed with: `New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow`
5. Overcommitment: set ~11 GB + ~11 GB on a 16 GB host.

## Network diagram

              Internet
                 |
      Host laptop 192.168.56.1 (campus Wi-Fi)
                 |
          [VM NAT  10.0.2.0/24]
          /                    \
      lab01-ubuntu               lab02-windows
      10.0.2.4                       10.0.2.3

## Result
| | Before | After |
|---|---|---|
| Host RAM in use |10.2 GB of 15.3 GB (67%) | 15.2 of 15.3 GB (?) `We couldn't open the task manager when testing` |
| Available |5 GB | 0 GB (?)|
| Committed / Swap used |24.8 GB of 32.3 GB committed | 30.0 GB of 32.3 GB (?) committed|
| What I noticed | — | It almost crashed when we tried to operate in the VMs, was freezing badly|

## What did not work the first time
1. We couldn't check if the Windows additions installed properly
2. Our VMs couldn't see each other even with the NewRule command, always `Destination Host Unreachable`
3. During the overcommitment experiment, it lagged a lot and almost froze the laptop

## Evidence
- [evidence/ipconfig-windows.txt](evidence/ipconfig-windows.txt) — Windows address
- [evidence/ip-addr-linux.txt](evidence/ip-addr-linux.txt) — Ubuntu address
- [evidence/ping-both-ways.txt](evidence/ping-both-ways.txt) — both directions and the internet
- [evidence/host-memory-before(evidence/host-memory-before) — host memory, guests off
- [evidence/host-memory-after.png](evidence/host-memory-after.png) — host memory, both guests overcommitted
