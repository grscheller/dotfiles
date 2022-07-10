# System Configuration Files

This directory contains system configureation files which
I used to MANUALLY install on my Systemd/Wayland based Linux
systems.

Paths are realtive to the `/` directory.

Eventually, due to making too many errors, I wrote an
installation script `systemfilesInstall`.  From the
base of the dotfiles repository, run

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
