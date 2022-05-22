# Windows 10 prevent auto-restart after update

Windows 10 has a really annoying default behavior where every month
or so when it installs a new update (which tends to happen overnight),
it will automatically reboot the machine.  This means all programs
just get killed, and a lot of implicit state one may have wanted
to preserve gets destroyed.  (However, apparently this is only
the default on some machines?  I know someone who uses Windows 10
and who hasn't done special configuration who has never had to deal
with this issue.)

I believe it was [this method](https://www.reddit.com/r/Windows10/comments/qtb1cr/ive_tried_everything_to_disable_automatic/hki9k0r/)
that finally did the trick. Full steps:

- Press Windows key to open start menu
- Type "gpedit"
- Select "Edit group policy"
- Go to Computer Configuration → Administrative Templates → Windows Components → Windows Update (click on the "Windows Update folder")
- Scroll to find "No auto-restart with logged on users for scheduled automatic updates installations", then right click this and click "Edit"
- Select "Enabled" in the radio menu
- Click Apply/OK

With the above setting enabled, Windows will show an orange
'you have an update you need to install, and this will reboot the computer'
(I forget the exact wording) icon show up in the notifications panel
whenever an update is available, so one can update+reboot when one chooses.
