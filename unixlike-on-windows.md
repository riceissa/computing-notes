# Thoughts on getting a Unixlike environment on Windows 10

After switching to Windows from Linux after 10+ years, I've been looking at the various ways to replicate a Unixlike environment on Windows
(since a lot of my workflow was on a commandline, and there's a few programs like newsboat and ways of doing things like programming that I
find easier on Linux). Here's my take so far:

# VMWare Workstation

This worked pretty well, but I didn't like that it ate up all the memory at once, and having to start it up each time, and there was
some friction too like alt-tabbing didn't work quite well. There was also some slight lag at times.

Also font size is pretty small because of some monitor resolution stuff that I couldn't figure out. But this isn't such a big problem
in the end because I could just increase the terminal font size. This was a problem for all the virtualization options.

# Git-Bash

This works pretty well, and I still use this in parallel with WSL1. However, it's not really a full Linux experience -- even
some basic programs like `make` are not available. There's a way to install more packages by installing MSYS2 MinGW, and I
actually did this and tried installing tmux. Tmux did kind of work, but then whenever I tried to load a config file it would
crash. So I gave up trying to make this a fancy Linux environment, and decided to have Git-Bash + a more fancy thing (currently WSL1).

# Hyper-V

I tried this a bit but it was lagging very noticeably. Apparently there's a fix but it only works on LTS or something, so I gave up.

# Virtualbox

I tried this a bit but it couldn't detect my window size and I think it was also slow.

# WSL1

I am trying this now. It seems to work pretty well so far. I've noticed that `git status` can be quite slow at times.

# WSL2

Haven't tried this.
