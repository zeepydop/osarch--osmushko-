# Ticket 2 — Kitting out the new office | Diana Osmushko | Group 6

## 1. What was asked
```
From: Daniyar K. (Director)
Subject: computers for the new office

We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included.
```

## 2. What was actually needed
### Are four identical computers the best choice?
No. Each employee has different responsibilities and workloads. An accountant mainly needs reliable office performance, a sales manager needs memory for multitasking, a web developer needs resources for programming and containers, and a designer needs graphics performance and a colour-accurate display. Four identical computers would either waste money on unnecessary components or leave some employees without enough performance.

### What does each employee do?
- Accountant: Uses accounting software, Excel, spreadsheets, PDFs, email and browser tabs. Reliability, sufficient memory and a comfortable screen are important.
- Sales manager: Works with CRM, 30–40 browser tabs, Excel, email and video calls simultaneously. Memory is the main bottleneck.
- Web developer: Uses a code editor, Git, browsers, local databases and Docker containers. Memory and CPU performance are important, especially when running several tools together.
- Designer: Works with Photoshop, Illustrator, Figma and large image files. Graphics performance, memory and monitor quality are important.

### What should the 3,000,000 KZT budget include?
The budget must include four complete computers and four monitors, as explicitly requested. It must also include licensed operating systems. I assume keyboards, mice, cables and network equipment are already available in the office. I would confirm this with the director before purchasing. I also include the necessary internal components, such as power supplies, cases and CPU coolers.

### How long should the computers last?
I assume the computers should remain useful for approximately four years. This means choosing components that can handle future software updates and allow reasonable upgrades. The selected DDR4 platforms are more affordable, but their upgrade options are more limited than newer DDR5 platforms. Memory can be expanded where the motherboard supports it, although a future CPU upgrade may require replacing the motherboard as well.

### Which software and operating systems are needed?
- Accountant: Accounting software, Excel and office applications. Windows 11 Home is selected because many commonly used accounting applications in Kazakhstan are designed for Windows.
- Sales manager: CRM, browser applications, Excel and video conferencing. Windows 11 Home is suitable.
- Web developer: VS Code, Git, browsers, databases and Docker. Ubuntu LTS is selected because it supports common development tools and is free and open-source.
- Designer: Photoshop, Illustrator and Figma. Windows 11 Home is selected, with an NVIDIA graphics card for GPU-accelerated tasks.

I would confirm the exact applications and their system requirements before buying the computers.

### 6. What would I ask Daniyar, and what did I assume?
I would ask Daniyar:
- Are keyboards, mice, cables and backup devices already available?
- Which accounting and design applications will the employees use?
- Does the designer work with 3D rendering or video editing?
- Will the developer need virtual machines or several containers at once?
- Does the company require Windows Pro or any specific business software?
- Is the four-year lifespan acceptable?

Since these details were not provided, I assumed ordinary office workloads for the accountant and sales manager, moderate development workloads, and mainly 2D design work. I also assumed a four-year service life, existing peripherals and network equipment, and that Windows 11 Home is sufficient for the three Windows computers.

## 3. What I did
I chose each computer according to its workload instead of using the
same configuration for everyone. All four builds have at least 16 GB
of RAM, a 1 TB SSD, a monitor and an operating system.

The estimated total after correcting the two office SSDs is
2,073,670 KZT, leaving approximately 926,330 KZT from the budget.
The detailed component prices and vendor links are in [budget.csv](evidence/budget.csv).
The workload reasoning is in [builds.md](builds.md).

### Director's questions
**1. Which computer would I upgrade first after eighteen months?**

I would upgrade the web developer's RAM from 32 GB to 64 GB.
Running several containers, a local database and virtual machines
together may use more memory as projects become larger. More RAM would
help avoid swapping and keep development tools responsive.

**2. What if the company bought pre-built computers instead?**

A pre-built computer would save time because the vendor assembles and
tests it. The company may also receive a single warranty and technical
support contact. However, it would have less control over the exact
components and future upgrades, and the price may be higher.

**3. Who is most likely to complain about performance within a month?**

The designer is the most likely to complain. The RTX 3050 with 6 GB
of VRAM is an entry-level graphics card and may struggle with large
projects or demanding 3D rendering. This is the main compromise I
accepted to keep the total budget low.

## 4. Evidence
- [builds.md](builds.md) — explains the workload, bottleneck and trade-off for
  each computer.
- [budget.csv](evidence/budget.csv) — lists components, prices, vendors and price dates.
- [evidence/pcpartpicker-links.md](evidence/pcpartpicker-links.md) — contains compatibility and
  estimated power checks for the four builds.
- [evidence/vendor-quotes/](evidence/vendor-quotes/) — contains dated screenshots of the
  vendor product pages used for the prices.

Shop.kz product pages are used as price evidence.

## 5. What I would do differently
I would first confirm the exact software used by the designer and
accountant. This could change the GPU or operating-system choice.
I would also request pre-built quotes and compare their warranty and
support conditions before the company makes its final purchase.
**Why four identical machines is wrong:**  
Buying four identical computers forces an unacceptable compromise across different workloads. An accountant runs 1C and spreadsheets that require zero 3D graphics power, whereas a designer relies heavily on GPU acceleration and a color-accurate monitor. Buying identical mid-range machines wastes budget on unused graphics hardware for office roles while leaving the developer and designer underpowered and bottlenecked from day one.
