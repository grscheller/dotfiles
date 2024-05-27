# grscheller/dotfiles

GitHub repository to maintain and install multiple configuration files
for the Linux based workstation computers I use.

## Installation scripts

* install various "dotfiles" to my $HOME directory
  * [nvimInstall](bin/nvimInstall) - Neovim (always a work in progress)
  * [fishInstall](bin/fishInstall) - Fish (my primary shell)
  * [bashInstall](bin/bashInstall) - Bash (my backup shell, mostly for Pop!OS)
  * [swayInstall](bin/swayInstall) - Sway (my Wayland desktop on Arch)
  * [miscInstall](bin/miscInstall) - miscellaneous config files
* install all of the above in parallel
  * [dfInstall](bin/dfInstall)
* install Arch Linux system files
  * sudo [rootInstall](bin/rootInstall)
* core infrastructure used by scripts
  * [source_setup.sh](bin/source_setup.sh)

## Factoids

* POSIX compliant installation scripts
  * actually Dash compliant (I use the "local" keyword)
  * rootInstall is a Fish script
* fish abbreviations to install from $DOTFILES_GIT_REPO
  * nvInstall -> for nvimInstall
  * fInstall  -> for fishInstall
  * bInstall  -> for bashInstall
  * swInstall -> for swayInstall
  * mInstall  -> for miscInstall
  * dfInstall -> for dfInstall
* currently only tested regularly on Arch Linux
* tested intermittently on Pop!OS

## Public Domain Declaration

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
