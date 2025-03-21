# How to shut down Ubuntu WSL1

From the WSL terminal window, type:

```
wsl.exe --terminate $WSL_DISTRO_NAME
```

([source](https://stackoverflow.com/a/67090137/3422337))

I recommend running the following command first:

```
#wsl.exe --terminate $WSL_DISTRO_NAME  # turn off/reboot wsl; uncomment line to run
```

This will save the commented out command in your `~/.bash_history` so that you can search
for it with CTRL-R. If you just run the uncommented version, WSL will shut down before the
line gets added to your history, so you will never be able to find it in your bash history.
