# Lab 2 — A Windows guest, and a network between them

Pair: <you> / <partner>   Driver first half: <name>
Machine: <your laptop, OS, RAM, cores>, guests Ubuntu Server + Windows 11 Enterprise eval
Date: <dd.mm.2026>

## What I did
1. Downloaded Windows 11 Enterprise evaluation. Licence: <Evaluation Center link>
2. Created lab02-windows: 2 vCPU, 4 GB, 64 GB thin, UEFI + Secure Boot, vTPM.
3. Network mode: <mode>, both guests. Why: <your reason>
4. Ping Ubuntu → Windows timed out because <why>. Fixed with: <the firewall rule command>
5. Overcommitment: set <x> GB + <y> GB on a <z> GB host.

## Network diagram
<diagram or image>
              Internet
                 |
      Host laptop 10.20.5.37 (home Wi-Fi)
                 |
     [VM NAT · VMnet8 · 192.168.80.0/24]
          /                        \
lab01-ubuntu                  lab02-windows
10.0.2.4                       10.0.2.3

## Result
| | Before | After |
|---|---|---|
| Host RAM in use | | |
| Available | | |
| Committed / Swap used | | |
| What I noticed | — | |

## What did not work the first time
<At least one thing: what I saw, what it turned out to be, what I did.>

## Evidence
- [evidence/ipconfig-windows.txt](evidence/ipconfig-windows.txt) — Windows address
- [evidence/ip-addr-linux.txt](evidence/ip-addr-linux.txt) — Ubuntu address
- [evidence/ping-both-ways.txt](evidence/ping-both-ways.txt) — both directions and the internet
- [evidence/host-memory-before(evidence/host-memory-before) — host memory, guests off
- [evidence/host-memory-after.png](evidence/host-memory-after.png) — host memory, both guests overcommitted
