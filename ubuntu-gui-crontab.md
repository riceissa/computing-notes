# Running GUI programs like zenity via crontab on Ubuntu

For some reason, on Ubuntu 26.04, running zenity via crontab does not work by default.

The following script, modified from [here](https://discourse.ubuntu.com/t/cron-job-doesnt-work-after-update-to-24-04/65330/36), does the trick:

```bash
#!/usr/bin/bash

# This script is modified from
# https://discourse.ubuntu.com/t/cron-job-doesnt-work-after-update-to-24-04/65330/36

export DISPLAY=:0
XAUTHORITY=$(find /run/user/"$(id -u)"/ -maxdepth 1 -type f -name .mutter-Xwaylandauth.*)
export XAUTHORITY
echo $XAUTHORITY > /tmp/zenity-crontab.log
zenity --info --text="This is a message sent using zenity." >> /tmp/zenity-crontab.log 2>&1
```
