# Add minimize/maximize buttons

```
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
```

# Make alt+tab switch windows instead of apps

```
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
```

# Change cursor size

```
gsettings set org.gnome.desktop.interface cursor-size 20
```

# Change volume step

```
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-step 4
```
