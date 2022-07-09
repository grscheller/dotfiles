# dotfiles

This repo contains the infrastructure I use to manage my
Neovim, Fish, Sway, Alacritty, Bash, GIT, SSH as well as
system configurations geared to Systemd/Wayland Arch Linux.

## Installation Scripts

Installs into my home directory.

* [dotfilesInstall](dotfilesInstall)
  * installs my Linux environment into `$HOME`
  * from cloned repo run:
    ```
       $ ./dotfilesInstall
    ```

Installs into the system directories of my Arch Linux systems.

* [systemfilesInstall](systemfilesInstall)
  * for Arch Linux ONLY
  * installs into system directories
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

## Factoids

* Contains examples of Fish, Bash, and POSIX shell scripting
* Contains my Neovim configuration
  * Assumes Neovim version 0.7.0+
  * Neovim configs are Lua based and use LSP, BSP, DAP heavily
* Contain Pyenv hooks to manage Python versions and environments

## License Information

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="https://github.com/grscheller/dotfiles">
    <span property="dct:title">Geoffrey R. Scheller</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">dotfiles</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="US" about="https://github.com/grscheller/dotfiles">
  United States</span>.
</p>
