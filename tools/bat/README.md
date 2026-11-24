# bat — A text file looks completely fine and is breaking your script anyway.
**Presented:** Zadorozhnaya / Osmushko
## The problem
all is a template example for read me from down here 
The lab VM ran out of space. df -h says 100% used but not what used it.
du -sh /* prints forty lines that tell you nothing.
## What we showed
```
sudo ncdu /
```
Interactive tree, arrow keys down through the heaviest directories.
Twenty seconds to /var/log/journal — 3.1 GB of systemd logs.
```
sudo journalctl --vacuum-size=200M
```
## When to reach for it
When you know space is gone and do not know where. If you already know
the directory, du -sh * is enough and ncdu is overkill.
## Installing
- Linux: `sudo apt install ncdu`
- Windows: WizTree, or `Get-ChildItem -Recurse | Sort Length -Desc
