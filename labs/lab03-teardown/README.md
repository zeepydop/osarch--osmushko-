# Lab 3 — Teardown, and the same machine from the command line

Pair:  Diana Osmushko                   Driver first half: Diana Osmushko
Machine: Windows Laptop
Date: 05.11.2026

## What I did

### Part 1: Component Teardown & Research

1. Researched the 10 components from the makers' websites, identified interfaces and limits:
   * **AMD Ryzen 5 7600**: Desktop CPU (6 cores / 12 threads), AM5 socket (LGA 1718). Limits: Only DDR5 memory supported, requires AM5 motherboard. Includes AMD Wraith Stealth cooler. [AMD Product Page](https://www.amd.com/en/products/processors/desktops/ryzen/7000-series/amd-ryzen-5-7600.html)
   * **Intel Core i5-13400**: Desktop CPU (10 cores / 16 threads), LGA 1700 socket. Limits: Compatible with Intel 600/700 series chipsets only. Includes Intel Laminar RM1 cooler. [Intel Product Page](https://www.intel.com/content/www/us/en/products/sku/230495/intel-core-i513400-processor-20m-cache-up-to-4-60-ghz/specifications.html)
   * **ASUS PRIME B650M-A**: Micro-ATX motherboard, AMD B650 chipset, Socket AM5. Limits: Only supports AM5 processors (Ryzen 7000/8000/9000) and DDR5 DIMM. [ASUS Product Page](https://www.asus.com/motherboards-components/motherboards/prime/prime-b650m-a/)
   * **MSI PRO B760M-A WIFI DDR4**: Micro-ATX motherboard, Intel B760 chipset, Socket LGA 1700. Limits: Supports Intel 12th/13th/14th Gen CPUs and DDR4 memory only (not DDR5). [MSI Product Page](https://www.msi.com/Motherboard/PRO-B760M-A-WIFI-DDR4)
   * **Kingston FURY Beast DDR5-5600 16 GB**: 288-pin DDR5 UDIMM module. Limits: Fits only DDR5 slots, keyed differently from DDR4. [Kingston Product Page](https://www.kingston.com/en/memory/gaming/kingston-fury-beast-ddr5-memory)
   * **Crucial DDR4-3200 16 GB DIMM**: 288-pin DDR4 UDIMM module. Limits: Fits only DDR4 slots, capped at DDR4-3200 speeds. [Crucial Product Page](https://www.crucial.com/memory/ddr4/ct16g4dfra32a)
   * **Samsung 990 PRO 1 TB**: M.2 2280 NVMe SSD (PCIe 4.0 x4). Limits: Requires M.2 Key-M PCIe slot for full bandwidth. [Samsung Product Page](https://semiconductor.samsung.com/consumer-storage/internal-ssd/990-pro/)
   * **Samsung 870 EVO 1 TB**: 2.5-inch SATA III SSD. Limits: Interface limit of 6 Gbps (~560 MB/s), requires SATA data and power cables. [Samsung Product Page](https://semiconductor.samsung.com/consumer-storage/internal-ssd/870-evo/)
   * **Corsair RM750e (750 W)**: Fully modular ATX power supply, 80 PLUS Gold. Limits: Max 750 W load, standard ATX case mount required. [Corsair Product Page](https://www.corsair.com/us/en/p/psu/cp-9020262-na/rme-series-rm750e-fully-modular-low-noise-atx-power-supply-cp-9020262-na)
   * **Stock Coolers (AMD Wraith Stealth / Intel Laminar RM1)**: CPU air coolers bundled in processor boxes. Limits: Wraith Stealth fits AM4/AM5 only; Laminar RM1 fits LGA 1700 only; both designed for 65W TDP.

2. Planned two compatible builds:
   * **Build 1 (AMD AM5 + DDR5)**:
     - CPU: AMD Ryzen 5 7600
     - Motherboard: ASUS PRIME B650M-A (Socket AM5, B650 chipset)
     - RAM: Kingston FURY Beast DDR5-5600 16 GB
     - Storage: Samsung 990 PRO 1 TB (M.2 NVMe)
     - Cooler: Stock AMD Wraith Stealth cooler (shipped with CPU)
     - PSU: Corsair RM750e (750 W)
     - *Justification:* Ryzen 5 7600 fits AM5 socket; ASUS B650 board requires DDR5 which matches Kingston DDR5 RAM; M.2 slot supports NVMe Gen4 speeds.
     - *Still needed:* Micro-ATX/ATX case, peripherals (monitor, keyboard, mouse).
   * **Build 2 (Intel LGA 1700 + DDR4)**:
     - CPU: Intel Core i5-13400
     - Motherboard: MSI PRO B760M-A WIFI DDR4 (Socket LGA 1700, B760 chipset)
     - RAM: Crucial DDR4-3200 16 GB DIMM
     - Storage: Samsung 870 EVO 1 TB (2.5" SATA)
     - Cooler: Stock Intel Laminar RM1 cooler (shipped with CPU)
     - PSU: Corsair RM750e (750 W)
     - *Justification:* Core i5-13400 fits LGA 1700 socket; motherboard explicitly supports DDR4 matching Crucial RAM; SATA SSD connects via SATA 6Gb/s port.
     - *Still needed:* Second PSU (if running concurrently), SATA data cable, case, peripherals.

---

### Part 2: Hardware Inspection via Command Line

Queried CPU, memory, and disk specifications from the OS command line and saved outputs.

1. Extracted CPU details on Windows:
```cmd
wmic cpu get Name, NumberOfCores, NumberOfLogicalProcessors
```
Output:
Name                                      NumberOfCores  NumberOfLogicalProcessors
11th Gen Intel(R) Core(TM) i5-1135G7      4              8

2. ​Extracted Memory details on Windows:
```wmic memorychip get Capacity, Speed, MemoryType```
Output:
Capacity     MemoryType  Speed
8589934592   0           3200
8589934592   0           3200

3. Extracted Disk details on Windows:
```wmic diskdrive get Model, Size, MediaType```
Output:
MediaType              Model                         Size
Fixed hard disk media  NVMe SAMSUNG MZVL2512HCJQ-00  512110190592

4. Extracted CPU and Disk info on Linux (VM):
```
lscpu | grep -E "Model name|CPU\(s\):"
lsblk -d -o NAME,MODEL,SIZE,TRAN
```
Output:
Model name:          11th Gen Intel(R) Core(TM) i5-1135G7 @ 2.40GHz
CPU(s):              2
NAME  MODEL  SIZE TRAN
sda   VBOX  40G  sata

## Result

### Command Comparison Across Operating Systems

| Specification / Hardware Fact | Windows Command | Linux Command | macOS Command |
| :--- | :--- | :--- | :--- |
| **CPU Model Name** | `wmic cpu get Name` | `lscpu \| grep "Model name"` | `sysctl -n machdep.cpu.brand_string` |
| **CPU Cores & Threads** | `wmic cpu get NumberOfCores, NumberOfLogicalProcessors` | `lscpu \| grep -E "^CPU\(s\):\|Core\(s\) per socket:"` | `sysctl -n hw.physicalcpu hw.logicalcpu` |
| **Total System RAM** | `systeminfo \| findstr /C:"Total Physical Memory"` | `free -h` | `sysctl -n hw.memsize` |
| **RAM Module Details** | `wmic memorychip get Capacity, Speed, PartNumber` | `sudo dmidecode --type memory \| grep -E "Size\|Type\|Speed"` | `system_profiler SPMemoryDataType` |
| **Storage Drive Model & Size** | `wmic diskdrive get Model, Size` | `lsblk -d -o NAME,MODEL,SIZE,TRAN` | `diskutil list` |
| **Filesystem / Disk Usage** | `wmic logicaldisk get Caption, FreeSpace, Size` | `df -h` | `df -h` |


## What did not work the first time
* **What I saw:** When executing `wmic memorychip get Capacity, Speed, MemoryType` on the Windows host, the `MemoryType` field returned a value of `0` instead of identifying the generation (like DDR4).
* **What it turned out to be:** The legacy `MemoryType` property in WMIC often returns `0` (Unknown) for modern DDR4 and DDR5 memory modules due to deprecation in newer Windows builds. 
* **What I did about it:** I verified the memory standard by checking the `Speed` output (3200 MT/s, which indicates DDR4 laptop memory) and noted that using `wmic memorychip get SMBIOSMemoryType` is the correct updated query to get accurate generation codes.


## Evidence
- [evidence/photos/](evidence/photos/) — Contains manufacturer product images and specification screenshots for all 10 researched hardware components.
- [evidence/windows-specs.txt](evidence/windows-specs.txt) — Raw command-line output showing the authentic 11th Gen i5 host CPU, dual 8 GB RAM sticks, and Samsung NVMe drive details from the Windows command prompt.
- [evidence/linux-specs.txt](evidence/linux-specs.txt) — Raw command-line output from the VirtualBox Linux guest VM, verifying its 2 allocated virtual CPU cores and 40 GB virtual SATA drive.
