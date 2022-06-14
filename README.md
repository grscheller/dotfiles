# Configuration Files "dotfiles"

This repo contains the infrastructure I use to manage my
Fish, Bash, Neovim, Sway, Alacritty, GIT, SSH, Python, 
and Haskell configurations.  Also contains my Personnal
"homepage" used in lieu of browser bookmarks.

Geared to Systemd/Wayland Arch Linux systems.

## Installation Scripts

Installs my software development environment onto my Arch Linux systems.

* [dotfilesInstall](dotfilesInstall)
  * installs my Linux environment into `$HOME`
  * from cloned repo run:
    ```
       $ ./dotfilesInstall
    ```

* [systemfilesInstall](systemfilesInstall)
  * for Arch Linux ONLY
  * installs system configuration files into `/etc`
  * from cloned repo run:
    ```
       $ sudo ./systemfilesInstall
    ```

## Contains

* Bin scripts: [bin/](bin/) -> `$HOME/bin/`
* Global Haskell Cabal configs: [cabal/](cabal/) -> `$HOME/.cabal/`
* XDG configuration files: [config/](config/) -> `$XDG_CONFIG_HOME/`
* $HOME configuration files: [home/](home/) -> `$HOME/`
* System configuration files: [root/](root/) -> `/`
* SSH configuration files: [ssh/](ssh/) -> `$HOME/.ssh/`
* Personnal "homepage" files: [web/](web/) -> `$HOME/web/`

## Factoids

* Contains examples of Fish, Bash, and POSIX shell scripting
* Contains my Neovim configuration
  * Assumes Neovim version 0.7.0+
  * Neovim configs are Lua based and use LSP heavily
* Contain Pyenv hooks to manage Python versions and environments
* Tested regularly against Arch Linux
