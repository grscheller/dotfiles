# Configuration Files "dotfiles"

This repo contains the infrastructure I use
to maintain and install my Fish, Bash, Neovim,
Alacritty, Sway and SSH configurations.

## Installation Script

Installs my shell & GUI environment into the $HOME
directory of any sufficiently POSIX like system.
Geared to Systemd/Wayland Linux systems.

* [installDotfiles](installDotfiles) installation script
  * run `./installDotfiles` from cloned repo
  * installs everything into `$HOME`

## Factoids

* Tested regularly against Arch Linux and MacOS
* Assumes Fish version 3.0+
* Contains examples of Fish, Bash, and POSIX shell scripting
* Contain Pyenv hooks to manage Python versions and environments
* Neovim configs are Lua based and use LSP heavily
* Neovim configs are coming together, but still a work in progress
