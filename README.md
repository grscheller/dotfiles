# grscheller/dotfiles

My GitHub repository to maintain and install
all my Linux based "dotfiles."

## Installation scripts

Scripts install my "dotfiles" from the cloned repo
into my $HOME directory. These scripts can be
launched from anywhere. They will honor the
[XDG directory specification](https://specifications.freedesktop.org/basedir/latest/).

- POSIX installation scripts.
  - [bashInstall](bin/bashInstall) for Bash, my fallback shell.
  - [fishInstall](bin/fishInstall) for Fish, my primary shell.
  - [nvimInstall](bin/nvimInstall) for Neovim, always a work in progress.
  - [otherInstall](bin/develInstall) for Other configuration files.
  - [dotfileInstall](bin/dotfileInstall) to Install all of the above.
- Fish abbreviations
  - bI 🠖 bin/bashInstall
  - fI 🠖 bin/fishInstall
  - nI 🠖 bin/nvimInstall
  - oI 🠖 bin/otherInstall
  - dfI 🠖 bin/dfInstall (installs all of the above)
- Sourced core infrastructure for scripts.
  - [parse_cmdline.sh](bin/sourced/parse_cmdline.sh)
  - [functions.sh](bin/sourced/functions.sh)
  - [configure_xdg_dirs.sh](bin/sourced/configure_xdg_dirs.sh)

## Public Domain Declaration

To the extent possible under law,
[Geoffrey R. Scheller](https://github.com/grscheller)
has waived all copyright and related or neighboring rights
to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
