# Ubuntu release upgrade

Make sure current release is up to date:

```
sudo apt update
sudo apt upgrade
```

Check current release:

```
lsb_release -a
```

Check which type of release (normal-six-month-release vs LTS) one is tracking:

```
less /etc/update-manager/release-upgrades
```

Begin the release upgrade:

```
sudo do-release-upgrade
```

Note that even for the same release number, the LTS release is delayed
compared to the normal release (see [here](https://askubuntu.com/a/1403657/258410) for details).

Python pip packages are usually completely deleted during the upgrade process,
so you will need to re-install all pip packages. Maybe there's a way to list
all the currently-installed pip packages _before_ the upgrade, but I have
always just dealt with the missing module errors as they come up.
