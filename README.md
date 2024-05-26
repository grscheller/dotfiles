# grscheller/dotfiles

GitHub repository to maintain and install the configuration files for my
Linux based workstation computers.

* nvim-env - Neovim configuration files
  * always a work in progress
  * uses folke/lazy.nvim as the plugin manager
  * used nvim-lua/kickstart as a guide to my key mappings
  * uses mason as an LSP/DAP/Linter/Formatter package manager
    * made to play nice with locally installed tools
* fish-env - Fish shell configuration files
  * very opinionated - my main shell
  * permanent configuration flows from configuration files
    * manual configurations can be used for temporary changes
    * manual changes can be lost on configuration file updates
* sway-env - Sway configuration files
  * Sway is a Wayland based tiling window manager modeled after i3
  * using systemd, so only one session possible on a host at a time
* bash-env - Bash $HOME based configuration files
  * currently the shell I use on Pop!OS
  * bash startup files
    * attempted to be kept Linux/Unix system independent
    * not POSIX compatible
* home-env - other $HOME based configuration files
  * ~/bin scripts
    * bash, POSIX shell, python
  * other configuration files
    * ssh
    * bloop (Scala)
    * cabal (Haskell)
* root-env - Arch Linux system configuration files
  * customization not as necessary as was the case 4-6 years ago

Currently only tested out on Arch Linux.

## Scripts

* bin/[dfInstall](dfInstall)
  * Installs all "dotfiles" to the $HOME directory
  * Usage: `$DOTFILES_GIT_REPO/bin/dfInstall [--install|--check}]`
* bin/[sfInstall](sfInstall)
  * Installs "root-env/" files to "/"
  * Usage: `sudo $DOTFILES_GIT_REPO/bin/sfInstall`
* fish abbreviations provided to install from anywhere
  * fInstall to install fish-env files
  * nvInstall to install nvim-env files
  * swInstall to install sway-env files
  * hInstall  to install home-env files
  * dfInstall to install all of the above in parallel
  * sfInstall to install system configuration files

## Public Domain Declaration

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
