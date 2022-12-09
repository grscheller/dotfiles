# Dotfiles

Contains my user configuation files.

* Neovim configuration
* Fish and Bash configurations
* Sway and Alacritty configurations
* Other miscellaneous configurations
* Arch Linux system configuration tweaks

## Scripts

### Install Into Home Directory

Run the [dotfilesInstall](bin/dotfilesInstall) POSIX shell script.

### Install System Configurations (Arch Linux Only!)

Run the [systemfilesInstall](bin/systemfilesInstall) Fish shell script
as root.

### Toggle Installed/Repo Neovim Configs

Run the [grsSwap](bin/grsSwap) Fish shell script to toggle between
the installed ~/.config/nvim/lua/grs/ directory and a symlink to the
corresponding directory in the dotfiles repo.

## Repo's purposes is to

1. maintain my own personal configuration files
1. help quickly configure new systems for myself
1. preserve this information for myself
1. provide others useful examples for their own configuration files
1. allow others to use as a starting point for their own version of this repo

## License information

[license info](license.html)
