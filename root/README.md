# System Configuration Files

This directory contains system configureation files for my
Arch Linux systemd/wayland/sway based desktop workstations.

Paths are all realtive to the `/` directory.

I originally installed these files by hand.  Eventually, due
to making too many errors, I wrote an installation script
called `systemfilesInstall`.  From the base of the dotfiles
repository, run

```
    sudo ./systemfilesInstall
```

## Services using these configuration files

* avahi-daemon.service
* dhcpcd.service
* iwd.service
* systemd-resolved.service

## Timers using these configuration files

* reflector.timer
