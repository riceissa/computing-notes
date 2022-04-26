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
