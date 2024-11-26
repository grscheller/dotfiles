# grscheller/dotfiles

GitHub repository to maintain and install multiple configuration files
for the Linux based workstation computers I use.

## Installation scripts

* Install various "dotfiles" to my $HOME directory
  * [nvimInstall](bin/nvimInstall) - Neovim (always a work in progress)
  * [fishInstall](bin/fishInstall) - Fish (my primary shell)
  * [homeInstall](bin/homeInstall) - Bash & other miscellaneous configs
* Install all of the above in parallel
  * [dfInstall](bin/dfInstall)
* Core infrastructure used by scripts
  * [source_setup.sh](bin/source_setup.sh)

## Factoids

* POSIX compliant installation scripts
  * actually Dash compliant (I use the "local" keyword)
  * on Pop!OS /usr/bin/sh -> dash
* Fish abbreviations to install from anywhere
  * dfInstall -> for dfInstall
  * fInstall  -> for fishInstall
  * hInstall  -> for homeInstall
  * nvInstall -> for nvimInstall
* Currently only tested regularly on Pop!OS
* Old Arch Linux - sway version on branch arch-sway

## Public Domain Declaration

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.

See [LICENSE](LICENSE) for details.

