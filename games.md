# Fedora 44 Stardew Valley multiplayer

Single-player works, but when selecting "co-op" from the start menu, the game hangs at "connecting to online services...".

The following fix, found [here](https://www.reddit.com/r/StardewValley/comments/1kxcm8h/online_multiplayer_stuck_connecting_to_online/nkv8uc9/), worked for me. Proton was not needed.

```bash
sudo dnf install execstack
cd ~/.local/share/Steam/steamapps/common/Stardew\ Valley
execstack -c libGalaxy*
```

# Fedora Civilization 5

This game runs fine, but then crashes after a few minutes. I found a fix for this [here](https://www.reddit.com/r/linux_gaming/comments/k4yzzt/sidciv_5_random_crashes/gebmlw2/):

```bash
vim ~/.local/share/Aspyr/Sid\ Meier\'s\ Civilization\ 5/config.ini
# search for MaxSimultaneousThreads, and set the value equal to
# the number of threads of your CPU. To find that number,
# run something like htop and see the number of distinct threads
# listed at the top. In my case, it was 12. Then save the file.
```
