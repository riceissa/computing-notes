# Installing RPM Fusion and media codecs on Fedora 45

```bash
# Instructions from https://rpmfusion.org/Configuration#Command_Line_Setup_using_rpm
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Instructions from https://rpmfusion.org/Howto/Multimedia
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
```

Now open Firefox and go to hamburger menu → Extensions and Themes → Plugins → set the "OpenH264 Video Codec provided by Cisco Systems, Inc." to Always Activate.
