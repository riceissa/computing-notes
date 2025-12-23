# Installing Music on Console on Fedora 43

[Music on Console](https://moc.daper.net/) is my favorite music player, but it hasn't had any updates since November 2016.
Fedora as of version 43 does not have MOC in its default package repository, probably because the upstream hasn't been updated in so long.
There is a version on RPM Fusion, but at least when I install and run this version, it just dies with:

```bash
$ mocp
Segmentation fault         (core dumped) mocp
```

Luckily, Debian [maintains a package for MOC](https://packages.debian.org/search?searchon=names&keywords=moc) and it actually works.
The only problem is that it's a Debian package, not a Fedora-compatible package.
So to get MOC working on Fedora 43, I decided to use the Debian-patched source of MOC, and then compile that on Fedora.
This plan ended up working perfectly, so here I record the steps.

```bash
# Installs the dget command, which makes it easy to fetch .dsc files from Debian
sudo dnf install devscripts


# Install dependencies for MOC and other packages that will be needed to compile it.
# This list was generated with the help of Claude 4.5 Sonnet,
# and it is possible that not all of these packages are necessary.
sudo dnf install gcc make autoconf automake gcc-c++ alsa-lib-devel libdb-devel \
    faad2-devel libid3tag-devel libtool-ltdl-devel libmad-devel file-devel \
    libmodplug-devel musepack-tools ncurses-devel libogg-devel opusfile-devel \
    popt-devel libsamplerate-devel taglib-devel libvorbis-devel libtool \
    libcurl-devel flac-devel speex-devel ffmpeg-free-devel libsndfile-devel \
    jack-audio-connection-kit-devel wavpack-devel

# Create a new directory in which to do the compilation
mkdir -p ~/Downloads/moc-build
cd ~/Downloads/moc-build

# You can find the latest .dsc file by going to
# https://packages.debian.org/stable/moc
# and then grabbing the link to the .dsc file in the sidebar.
# The -u flag disables checking of GPG key signature verification, which is not
# great but I haven't yet figured out how to do the verification.
dget -u 'https://deb.debian.org/debian/pool/main/m/moc/moc_2.6.0~svn-r3005-6.dsc'

cd moc-2.6.0~svn-r3005/

# Make the directory into which we will install MOC
mkdir -p ~/opt

# Now build and install it
autoreconf -if
./configure --prefix=$HOME/opt/moc
make
make install

# Now for the moment of truth:
~/opt/moc/bin/mocp

# If the above worked, you can add that to your PATH:
echo 'PATH="$HOME/opt/moc/bin/:$PATH"' >> ~/.bashrc
```
