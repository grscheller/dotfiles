# Configuration Files "dotfiles"

This repo contains the infrastructure I use
to maintain and install my Fish, Bash, Neovim,
Alacritty, Sway and SSH configurations.

## Installation Script

Installs my shell & GUI environment into the $HOME
directory of any sufficiently POSIX like system.
Geared to Systemd/Wayland Linux systems.

* [dotfilesInstall](installDotfiles) installation script
  * installs Linux environment into `$HOME`
  * run `./dotfilesInstall` from cloned repo

* [systemfilesInstall](installDotfiles) installation script
  * For (Arch) Linux ONLY
  * installs Linux system configuration files into `/etc`
  * run `sudo ./systemfilesInstall` from cloned repo

## Contains

* $HOME configuration files in [home/](home/)
* XDG configuration files in [config/](config/)
* SSH configuration files in [ssh/](ssh/)
* BIN scripts installed from [bin/](bin/)
* System configuration files in [root/](root/)
* Personnal "homepage" files in [web/](web/)

## Factoids

* Contains examples of Fish, Bash, and POSIX shell scripting
  * Assumes Fish version 3.0+
* Contains my Neovim configuration
  * Assumes Neovim version 0.7.0+
  * Neovim configs are Lua based and use LSP heavily
  * Neovim configs are coming together, but still a work in progress
* Contain Pyenv hooks to manage Python versions and environments
* Tested regularly against Arch Linux
* No longer tested regularly against MacOS
