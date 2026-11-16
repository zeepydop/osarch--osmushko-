# Ticket 2 — Kitting out the new office

## 1. What was asked
```
From: Daniyar K. (Director)
Subject: computers for the new office

We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included.
```

## 2. What was actually needed

**Why four identical machines is wrong:**  
Buying four identical computers forces an unacceptable compromise across different workloads. An accountant runs 1C and spreadsheets that require zero 3D graphics power, whereas a designer relies heavily on GPU acceleration and a color-accurate monitor. Buying identical mid-range machines wastes budget on unused graphics hardware for office roles while leaving the developer and designer underpowered and bottlenecked from day one.

**What the request left out:**
* Operating System Licenses: Windows 11 licenses were not mentioned, yet accounting and design software require licensed OS environments.
* Peripherals & Cables: "Monitors included" omits keyboards, mice, display cables (HDMI/DisplayPort), and basic surge protection.
* Lifespan Definition : No exact timeframe was given,("a few years"), which determines whether we can use older dead-end sockets (AM4/DDR4) or must invest in upgradeable platforms (AM5/DDR5).
* Network & Workspace Constraints: No mention of whether desks have wired Ethernet drops or require Wi-Fi adapters, or if local backups/UPS protection are needed.

**What I would ask Daniyar && what I assumed instead:**
* *Question 1:* Does the accountant run a local 1C database or connect to a cloud server, and is a UPS needed to prevent data loss during power fluctuations?  
  * Assumption: Assumed local/hybrid 1C usage requiring a fast NVMe SSD, Windows 11 Pro, and a standard surge protector within budget.
* *Question 2:* Does the designer work strictly with 2D graphics (Figma, Photoshop, Illustrator) or also render heavy 3D/4K video?  
  * Assumption: Assumed 2D branding/UI work plus light 1080p/4K promotional video editing, requiring a dedicated GPU (8–12 GB VRAM) and a 100% sRGB IPS panel.
* *Question 3:* How many years is "a few years" before the next hardware refresh?  
  * Assumption: Assumed a 4-year service life, meaning motherboards must have spare RAM/M.2 slots and modern sockets for an easy mid-life upgrade.
* *Question 4:* Are keyboards, mice, and OS licenses included in the 3,000,000 KZT cap?  
  * Assumption: Yes, budgeted for four keyboard/mouse combos and licensed operating systems inside the 3,000,000 KZT limit.
(Why four identical machines is wrong. What the request left out.
What you would ask Daniyar, and what you assumed instead.)

## 3. What I did

I started by analyzing the daily software load of each employee to identify which hardware resource (RAM, CPU cores, GPU VRAM, or screen space) runs out first. Instead of splitting the 3,000,000 KZT equally (750,000 KZT each), I shifted money away from unneeded components—such as skipping dedicated GPUs for the accountant, sales manager, and web developer—and concentrated funds on 32 GB RAM kits, modern upgradeable platforms, and a dedicated GPU plus color-accurate monitor for the designer. Full workload reasoning is documented in [`builds.md`](builds.md), and itemized local prices totaling **[GRAND_TOTAL] KZT** are recorded in [`budget.csv`](budget.csv).

* 1. Which of the four machines will you upgrade first, eighteen months from now, and why?
The 'Designer's' workstation will be upgraded first by adding a second 2 TB NVMe SSD into its spare M.2 slot. Raw Photoshop files, Illustrator assets, and 4K video project caches quickly consume the initial 1 TB drive, and adding secondary storage is an inexpensive, zero-downtime upgrade that extends the machine's lifespan without replacing core parts.

* 2. Pre-built vs. Custom Build comparison:
Comparable pre-built systems priced from Kazakhstani vendors (see the second table in [`budget.csv`](budget.csv)) total [PREBUILT_TOTAL] KZT without matching monitor quality or peripheral inclusion. By buying pre-built machines, the company gains a single-point vendor warranty, immediate out-of-the-box deployment, and zero assembly labor. However, the company loses component transparency (pre-builts often pair good CPUs with cheap power supplies and single-channel RAM), upgrade paths due to proprietary cases/motherboards, and budget efficiency, paying a markup for lower-tier monitors and unneeded RGB aesthetics.

* 3. One of these four people will complain about performance within a month. Which one, and about what?
The Designer will likely complain first when exporting multi-layer 4K video timelines or batch-processing heavy RAW photo sets. To fit a dedicated GPU and a color-accurate IPS monitor under the 3,000,000 KZT ceiling, I traded down from an 8-core CPU to a 6-core processor and kept RAM at 32 GB instead of 64 GB, which will bottleneck heavy concurrent rendering in After Effects and Premiere Pro.
(How you went from roles to loads to parts; the budget; links to builds.md and budget.csv.
Then the three answers below.)
## 4. Evidence
* [`evidence/pcpartpicker-links.md`](evidence/pcpartpicker-links.md) — 
* [`evidence/vendor-quotes/`](evidence/vendor-quotes/) —

## 5. What I would do differently
(At least one specific thing.)
