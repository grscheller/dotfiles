# grscheller/dotfiles

My GitHub repository to maintain and install my Linux based "dotfiles."

## Installation scripts

- Install various "dotfiles" to my $HOME directory
  - [nvimInstall](bin/nvimInstall) - Neovim (always a work in progress)
  - [fishInstall](bin/fishInstall) - Fish (my primary shell)
  - [develInstall](bin/develInstall) - Devel environment & Bash fallback
- Install all of the above in parallel
  - [dfInstall](bin/dfInstall)
- Sourced core infrastructure for scripts
  - [parse_cmdline_and_source_functions](bin/parse_cmdline_and_source_functions,sh)

## Factoids

- POSIX compliant installation scripts
  - actually Dash compliant (I use the non-POSIX "local" keyword)
  - on Pop!OS /usr/bin/sh -> dash
- Fish abbreviations - dotfiles can be installed from anywhere
  - nvI  -> bin/nvimInstall
  - fI   -> bin/fishInstall
  - devI -> bin/develInstall
  - dfI  -> bin/dfInstall (installs all of the above in parallel)

## Public Domain Declaration

To the extent possible under law,
[Geoffrey R. Scheller](https://github.com/grscheller)
has waived all copyright and related or neighboring rights
to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
