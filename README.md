# Configuration Files "dotfiles"

This repo contains the infrastructure I use to maintain and
install my Fish, Neovim, Alacritty, Sway and SSH configurations.

## Installation Script

Installs my shell & GUI environment into the $HOME directory
of my sufficiently POSIX like systems.

* [installDotfiles](installDotfiles) installation script
  * run `./installDotfiles` from cloned repo
  * installs everything into `$HOME`

## Factoids

* Tested regularly against Arch Linux and MacOS
* Assumes Fish version 3.0+
* Contains minimal BASH and "POSIX SH" configurations
* Should work with most, more or less, POSIX like environments
* Contain Pyenv hooks to manage Python versions and environments
* Contains examples of Fish, BASH, and POSIX shell scripting
