# Auto-starting MySQL on WSL2 in Windows 10

After trying a bunch of solutions I found online, the only one that worked is to add the following to my `~/.bashrc`:

```bash
wsl.exe -u root service mysql status > /dev/null || wsl.exe -u root service mysql start > /dev/null
```

Found in [this answer](https://superuser.com/a/1701903) on Super User.
