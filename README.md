# grscheller/dotfiles

GitHub repository to maintain and install multiple configuration files
for the Linux based workstation computers I use.

## Installation scripts

* Install various "dotfiles" to my $HOME directory
  * [nvimInstall](bin/nvimInstall) - Neovim (always a work in progress)
  * [fishInstall](bin/fishInstall) - Fish (my primary shell)
  * [homeInstall](bin/homeInstall) - Bash & other miscellaneous configs
  * [swayInstall](bin/swayInstall) - Sway (my Wayland desktop on Arch)
* Install all of the above in parallel
  * [dfInstall](bin/dfInstall)
* Install Arch Linux system files
  * sudo [rootInstall](bin/rootInstall)
* Core infrastructure used by scripts
  * [source_setup.sh](bin/source_setup.sh)

## Factoids

* POSIX compliant installation scripts
  * actually Dash compliant (I use the "local" keyword)
  * rootInstall is a Fish script
* Fish abbreviations to install from anywhere
  * nvInstall -> for nvimInstall
  * fInstall  -> for fishInstall
  * hInstall  -> for homeInstall
  * swInstall -> for swayInstall
  * mInstall  -> for miscInstall
  * dfInstall -> for dfInstall
* Currently only tested regularly on Arch Linux
* Tested intermittently on Pop!OS

## Public Domain Declaration

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
