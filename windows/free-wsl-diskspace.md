# Free unused WSL diskspace

WSL automatically grows the disk image file when files are created inside of WSL,
but when files are deleted inside of WSL, it does not automatically shrink the
disk image file. See <https://askubuntu.com/a/1363021>. This can lead to huge disk image
file sizes, and the space isn't even being used for anything!

However, it is possible to manually shrink the disk image file.

First, find your `.vhdx` file.
Open Windows Explorer and navigate to `%userprofile%\AppData\Local\Packages`.
There should be a folder starting with `Canonical...`; open that.
Inside, there should be a folder called `LocalState`; open that.
There should be a file called `ext4.vhdx`.
**Take note of the size of the file, and keep the Explorer window open so you can compare the file after shrinking.**

The following steps come from [this comment](https://github.com/microsoft/WSL/issues/4699#issuecomment-627133168):

Open Windows PowerShell and type:

```
wsl --shutdown
diskpart
```

This will pop up a new command-prompt window for diskpart.

Now type:

```
select vdisk file="C:\location\of\your\vhdx\file"
attach vdisk readonly
compact vdisk
detach vdisk
exit
```

Now the `.vhdx` file should have shrunk by quite a bit.

When I ran this on 2025-03-13, the size went from around 40GB to around 30GB.
