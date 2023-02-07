# User Indicator Redux

![License](https://img.shields.io/badge/license-GPL--2.0--or--later-blue)
[![Translate into your language!](https://img.shields.io/badge/help%20translate-Transifex-4AB)](https://www.transifex.com/buddiesofbudgie/budgie-user-indicator-redux)
[![Latest stable GitHub release](https://img.shields.io/github/v/tag/EbonJaeger/budgie-user-indicator-redux?label=stable&sort=semver)](https://github.com/EbonJaeger/budgie-user-indicator-redux/releases/latest)
[![Latest GitHub release, including pre-releases](https://img.shields.io/github/v/tag/EbonJaeger/budgie-user-indicator-redux?include_prereleases&label=latest&sort=semver)](https://github.com/EbonJaeger/budgie-user-indicator-redux/releases)

![Screenshot](data/screenshot.png?raw-true)

Manage your user session from the Budgie panel.

This project is born from the changes to the User Indicator applet shipped with Budgie. Since it simply opens the Budgie Power Dialog, I figured people might still want the old menu. This applet gives them that option. The design is largely inspired from Elementary's Wingpanel session indicator, with some bits of the old Budgie user indicator mixed in, with options to show/hide items in the menu.

# Building

First, you'll need to install the following dependencies:

```
accountsservice
budgie-desktop
gee-0.8
gtk+-3.0
glib-2.0
libpeas-1.0
sassc
vala
```

## Building and Installing

1. Configure the build directory and meson with:

```bash
mkdir build
meson --prefix=/usr build
```

2. Build the project with:

```bash
ninja -C build
```

3. Install the files with:

```bash
sudo ninja install -C build
```
