# Lab 5 — Encoding forensics

Pair: Diana Osmushko                Driver first half: Diana Osmushko
Machine: Windows Laptop             Tools: Excel, LibreOffice, Git Bash
Date: 14.11.2026

## What I received
- **Excel:** Opened the file using a legacy single-byte encoding, turning Russian and Kazakh letters into unreadable garbled symbols (mojibake).
- **LibreOffice:** Showed an import dialog defaulting to a Western European character set, displaying broken symbols instead of Cyrillic and Kazakh text.
- **Terminal:** Printed raw single-byte characters as replacement diamonds (``) because Git Bash expected UTF-8.

## Diagnosis (made before the fix)
- file said: `Non-ISO extended-ASCII text, with CRLF line terminators` [evidence/file-before.txt](evidence/file-before.txt)
- First 16 bytes: `4944 3bd4 e0ec e8eb e8ff 3bc8 ecff 3bce` [evidence/hexdump-before.txt](evidence/hexdump-before.txt)
- Line ending: `CRLF` — because the first line ends with the bytes `0d 0a` (at offset `0x24`).
- BOM: `no` — because the first bytes are `49 44` (`"ID"`), not `ef bb bf`; in the fixed file I added it because Windows Excel requires the UTF-8 BOM (`ef bb bf`) to recognize UTF-8 automatically when opening a CSV file by double-clicking.
- Encoding: `KZ-1048` — because each Cyrillic/Kazakh letter is stored as a single byte (for example, `"А"` is the single byte `c0`, `"Ә"` is `a3`, and `"і"` is `b3` in `Әбдірахманова`, whereas Windows-1251 decodes `a3` as `Ј`).
- Separator: `;` — because fields are separated by the single byte `3b` (semicolon).

## Fix
```sh
#!/bin/sh
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv
iconv -f KZ-1048 -t UTF-8 "\(in" > "\)out"
printf '\357\273\277' | cat - "\$out" > tmp && mv tmp "\$out"
```

## Verification
- `evidence/file-after.txt` shows `Unicode text, UTF-8 (with BOM) text, with CRLF line terminators`, confirming the UTF-8 BOM (`ef bb bf`) at the start and multi-byte UTF-8 pairs (`d0 a4`, `d0 b0`, etc.) for Cyrillic letters.
- Screenshot `evidence/opens-correctly.png` shows `staff-fixed.csv` opening cleanly with all Russian and Kazakh names (`Әбдірахманова`, `Қасымов`, `Нұрлан`) and semicolon-separated columns intact in Excel, LibreOffice Calc, and Git Bash.

## What did not work the first time

1. Running `iconv -f KZ1048` failed with `conversion from KZ1048 unsupported` until checking `iconv -l | grep -i 1048` and using the hyphenated name `KZ-1048`.
2. Running `cat << 'EOF' > scripts/fix.sh` initially failed with `No such file or directory` because the `scripts/` folder had not been created yet (`mkdir -p scripts`).

## Evidence

- [evidence/file-after.txt](evidence/file-after.txt) — `file` and `xxd` verification output confirming UTF-8 with BOM and CRLF line endings after conversion.
- [evidence/file-before.txt](evidence/file-before.txt) — Initial `file` command output identifying the original file as `Non-ISO extended-ASCII text, with CRLF line terminators`.
- [evidence/hexdump-before.txt](evidence/hexdump-before.txt) — Raw hexadecimal dump (`xxd`) of the first 8 lines used to prove single-byte `KZ-1048` encoding, `CRLF` endings, and the absence of a BOM.
- [evidence/staff-broken.csv](evidence/staff-broken.csv) — Original untouched input CSV file.
- [evidence/staff-fixed.csv](evidence/staff-fixed.csv) — Converted output CSV file encoded in `UTF-8` with `BOM` (`ef bb bf`) and `CRLF` line endings.
- [evidence/opens-correctly.png](evidence/opens-correctly.png) — Side-by-side screenshot showing `staff-fixed.csv` displaying staff names properly in Excel, LibreOffice Calc, and Git Bash.
