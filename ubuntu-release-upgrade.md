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
so you will need to re-install all pip packages.
You can run:

```bash
pip list --not-required --user
```

to see a list of all the currently-installed pip packages _before_ the upgrade.
The `--not-required` flag restricts to packages that you yourself installed,
not the packages that came as a dependency to something else, and `--user` flag
restricts to packages that were installed by your user. I find that not doing
`--user` lists a bunch of garbage, probably because it's listing packages that
were installed via the distro's package manager. See also
[this script](https://github.com/riceissa/dotfiles/blob/master/.local/bin/global_python_packages.sh)
for a quick way to install the most common pip packages that I tend to use.
