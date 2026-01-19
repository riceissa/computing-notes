# Switching between light and dark modes based on circadian rhythm on Fedora Gnome

On computers, I like using light mode during the day and dark mode at night; it helps to cue my body about what time of day it is, and I think it helps with sleep.
(I also use a white ceiling light during the day and an amber bulb lamp at night, etc., but other circadian rhythm things won't be covered on this page.)
On this page, I will explain how to set things up so that the OS and application themes will automatically switch based on the time of day.
I only cover the Gnome desktop on Fedora 43; things will probably work pretty differently on other systems.

The Gnome desktop is actually pretty good about switching between light and dark modes out of the box; there's a button that says "Dark Style" in the indicator applet menu in the top right corner.
For a long time, I would just manually toggle this switch twice a day.
This page is a result of me finally getting sick of doing this twice a day for months on end, and figuring out how to automate it so I never have to think about it again.

## Setting up the OS master switch

Install `sunwait`:

```bash
sudo dnf install sunwait
```

Note that there seem to be multiple implementations/forks of the `sunwait` command floating around.
The command I use below works for the `sunwait` that is packaged with Fedora 43; it might not work with the other versions.

Now we add a cronjob to automatically switch to dark mode at the end of civil twilight (I prefer civil twilight to sunset, because at sunset the sky is still kind of light).

```bash
crontab -e
```

Add the following cronjob:

```
0  15 * * * sunwait civ down 47.603889N 122.33W; gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

The given coordinates are for Seattle, where I am located.
Obviously you should change it to wherever you are located!

For the morning, I decided to write a short Python script, intended to be run upon logging in, which checks if it is daytime and then switch to light mode if it is.
This way if I happen to log out and then log back in at night time, it won't switch back to light mode.
(I thought of adding a cronjob, but I turn off my computer every night, and cronjobs only run if the computer is on at the time of the scheduled job, and how am I supposed to know when I wake up and turn on the computer every morning?)

```
mkdir -p ~/.config/autostart
vim ~/.config/autostart/set-theme-on-login.desktop
```

Now add the following lines:

```
[Desktop Entry]
Type=Application
Name=Set the correct light or dark theme on login
Exec=set_light_dark_on_login.py
```

To obtain the script `set_light_dark_on_login.py`, go [here](https://github.com/riceissa/dotfiles/blob/master/.local/bin/set_light_dark_on_login.py) and save it somewhere on your computer, and then make sure it is in your `PATH`.
For simplicity I hardcoded the coordinates in the script, so you should modify that there as well.

In the script, instead of `'default'`, you can also do `'prefer-light'`, but this seems to change the top bar in Gnome to also turn white, which I don't want. Using `'default'` makes applications use light mode but keeps the top bar black, i.e. the same behavior as toggling off the "Dark Style" button from the indicator applet menu in the top right corner.

At this point, we've set up the "master switch" to toggle between light and dark modes.
For every application and website, you must now make it follow the OS theme.
I will cover some of the trickier ones below.

## Kitty

Run the command from within kitty:

```bash
kitten themes
```

Now pick a theme, and then when prompted, say it is for Dark mode, Light mode, or No preference mode.
Go through the themes picker three times, saving a theme for each mode until kitty knows your preference for each mode.
In my experience, the Light mode theme is never used; when the Gnome dark mode is enabled, the Dark mode kitty theme is used, and when the Gnome dark mode is disabled, the No preference mode kitty theme is used.
But it doesn't hurt to have the extra theme set.

## Vim

Neovim (compared to Vim proper) does a better job of automatically switching themes.
If you use a supported terminal like kitty, Neovim will change the theme even while it is already running, just like a light/dark-aware GUI application like Firefox.
Just make sure you don't set a particular theme or do things like `set background=light` in your vimrc; Neovim can already detect the terminal's background color, so don't force it one way or the other.
If you prefer a theme that is not the default one, you will need to add an autocommand to toggle between two different chosen themes.
I won't show that here since it's kind of a subtle issue and leads to other problems (in particular, it can lead to weird screen flickers when opening Vim); it's best to just use a theme that already has light and dark modes built in.

Neovim's "background auto-switching while running" feature doesn't work under tmux (in my experience, you need to detach the tmux session, then reattach, and only then will Neovim know what the terminal background color is), so if you care about having light/dark modes switch automatically, I suggest switching to a terminal like kitty and using kitty's native splits.

In Vim proper, there's a bit more work involved.
On some terminals, the terminal background color is auto-detected.
But Vim will never automatically switch the theme while running, so you need to quit Vim and reopen it for it to re-detect the terminal background color.
On kitty, background color detection doesn't work by default, and you will need to add the following:

```vim
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
```

See [here](https://sw.kovidgoyal.net/kitty/faq/#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim) for more information.
