# Lab 6 — Live processes and memory pressure

Pair: Inzhu + Diana · Date: 18.11 - 19.11 · Guests: Ubuntu/ Windows 

## Part 1 — One process, three tools
Process chosen: VBoxService — why: It is the VirtualBox Guest Additions background service present on both guest operating systems, making it ideal for comparing how Windows and Linux report process metadata and memory.


| | Task Manager | Process Explorer | htop / ps |
| :--- | :--- | :--- | :--- |
| **PID** | 1952 | 1952 | 1038 |
| **Parent (name and PID)** | — (not shown) | services.exe (920) | systemd (1) |
| **"Memory" as shown by default** | 1,120 K (Memory private working set) | 2,464 K (Private Bytes) | 0.3% (MEM%) / 3,832 K (RES) |
| **Private memory** | 1,120 K (Memory private) / 2,412 K (Commit size) | 2,464 K (Private Bytes) | — (no single column; ~412 K non-shared RSS) |
| **Working set / RES** | 9,940 K (Working set) | 9,644 K (Working Set) | 3,832 K (RES / RSS) |
| **Virtual size** | 2,412 K (Commit size) | 2,464 K (Private Bytes) | 285M (VIRT) / 292,100 K (VSZ) |
| **Handles / file descriptors** | 200 | 200 | 5 (open FDs in /proc/1038/fd) |
| **Threads** | 14 | 14 | 9 (nlwp) |

### Where the tools disagree

1. Memory column and Working Set / RES: Task Manager's default "memory" column shows the private working set (1,120 K), whereas Process Explorer's default column shows Private Bytes (2,464 K), and `htop` shows total physical `RES` (3,832 K). They display different numbers because they measure different types of memory allocation by default.
2. Commit size, Private Bytes and VIRT: Task Manager's Commit size (2,412 K) and Process Explorer's Private Bytes (2,464 K) measure committed virtual memory and nearly match, whereas `htop` has no equivalent commit column and instead shows `VIRT` (285M), which represents the entire virtual address space reserved by the process rather than actual RAM in use.
3. Parent process visibility: Task Manager's Details tab hides the parent process by default (`—`), while Process Explorer displays the process tree under `services.exe (920)` and `htop` tree view (F5) shows `systemd (1)`.
4. Handles and File Descriptors: Windows reports 200 handles in both Task Manager and Process Explorer because Windows counts kernel objects like events, registry keys, mutexes, and threads as handles, whereas Linux separates threads (9) from open file descriptors (5).
  
## Part 2 — Memory pressure
Guest RAM: 1.4 GiB (1.4 Gi total in `free -h`) · swap: 0 B (disabled / no swap configured)
Steps: 
```bash
free -h
swapon --show
{ echo "=== BEFORE $(date) ==="; free -h; } > memory-pressure.txt
while true; do echo "=== $(date +%T) ==="; free -h; sleep 3; done | tee -a memory-pressure.txt
stress-ng --vm 2 --vm-bytes 70% --vm-method write64 --timeout 60s
stress-ng --vm 2 --vm-bytes 90% --vm-method write64 --timeout 60s
stress-ng --vm 2 --vm-bytes 120% --vm-method write64 --timeout 90s
{ echo "=== AFTER $(date) ==="; free -h; } >> memory-pressure.txt
journalctl -k --since "30 min ago" | grep -i -E -B3 -A8 "out of memory|oom-kill" > kernel-log-extract.txt
```

| | Before 18:14:45 | During (worst) | After 18:15:21 |
| :--- | :--- | :--- | :--- |
| Available | 1.1 GiB | 18 MiB (1.4 GiB used just before OOM kill at 18:15:04 | 1.1 GiB |
| Swap used | 0 B | 0 B (no swap partition/file enabled) | 0 B |

What happened: Because swap was 0 B, pushing memory allocation to 120% starting at 18:14:48 rapidly exhausted all 1.1 GiB of available RAM, dropping it to 18 MiB by 18:15:03. Before the OOM killer intervened, the system suffered severe thrashing and CPU starvation: keyboard typing froze completely, systemd logged watchdog timeouts (exceeding the 3-minute limit), and the kernel reported a soft lockup with CPU#1 stuck for over 300 seconds. At 18:15:04, the Linux kernel OOM killer terminated the stress-ng-vm worker (PID 6246) and its sibling (PID 6250), immediately freeing roughly 1.26 GB of anonymous RSS memory and restoring responsiveness by 18:15:06 (1.1 GiB available again).

### What the kernel did

> `Nov 18 18:15:04 localhost kernel: Out of memory: Killed process 6246 (stress-ng-vm) total-vm:1478348kB, anon-rss:1264252kB, file-rss:504kB, shmem-rss:16kB, UID:1000 pgtables:2488kB oom_score_adj:1000`
> `Nov 18 18:15:04 localhost kernel: oom_reaper: reaped process 6246 (stress-ng-vm), now anon-rss:0kB, file-rss:0kB, shmem-rss:16kB`

* Which process was killed: `stress-ng-vm` (PID 6246, and subsequently its sibling worker PID 6250).
* Why that process: It had the highest memory footprint (`anon-rss: 1,264,252 kB`, roughly 1.26 GB out of the 1.4 GB total guest RAM) and the maximum `oom_score_adj` of 1000, making it the primary cause of memory exhaustion and the fastest way to reclaim RAM.
* When: At 18:15:04 on November 18, matching the exact peak memory exhaustion window during the 120% `stress-ng` run.

### Windows

Command:
```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 | Format-List TimeCreated, Id, Message
```

Result:
```text
Get-WinEvent : No events were found that match the specified selection criteria.
```

Explanation: The Windows guest never ran out of virtual memory (commit charge), so no `Resource-Exhaustion-Detector` events were logged. Unlike Linux, Windows does not have an aggressive OOM killer that terminates processes automatically; instead, when virtual memory runs low, Windows logs Event ID 2004 (listing the top three memory-consuming processes), warns the user, and causes new memory allocation requests to fail.

## What did not work the first time
1. Default `stress-ng` failed with SIGILL. Running `stress-ng --vm 2 --vm-bytes 70%` without specifying a VM method caused the workers to crash immediately (`caught SIGILL`, `exit status=2` in `0 secs`) because VirtualBox did not expose certain CPU instructions used by one of `stress-ng`'s default memory stressors. Adding `--vm-method write64` resolved the issue.
2. Process Explorer handle list was empty: Opening VBoxService.exe properties in Process Explorer without administrator privileges showed `<access denied>` for the User field and hid the individual handle names in the lower pane, even though the total handle count (200) was visible in Task Manager.

## Evidence
* [evidence/task-manager.png](evidence/task-manager.png) - Windows Task Manager details for VBoxService.exe.
* [evidence/process-explorer.png](evidence/process-explorer.png) - Windows Process Explorer view of VBoxService.exe and its parent.
* [evidence/htop.png](evidence/htop.png) - Ubuntu htop view of VBoxService with PPID and memory stats.
* [evidence/memory-pressure.txt](evidence/memory-pressure.txt) - Memory usage log recorded before, during, and after stress-ng.
* [evidence/kernel-log-extract.txt](evidence/kernel-log-extract.txt) - Kernel journal extract showing the OOM killer terminating stress-ng-vm.
