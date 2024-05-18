# grscheller/dotfiles

GitHub repository to maintain and install the configuration files for my
Linux based workstation computers.

* nvim-env - Neovim configuration files
  * always a work in progress
  * uses folke/lazy.nvim as the plugin manager
  * hrsh7th/nvim-cmp completions integrated with LSP
  * dundalek/lazy-lspconfig for Nix based LSP management
  * neovim/nvim-lspconfig for system or manually installed LSP servers
  * mfussenegger/nvim-lint to inject cli linting into vim.diagnostics
  * mhartington/formatter.nvim to run formatters
* nvim-ks-env - Refactoring my Neovim configuration files
    * using nvim-lua/kickstart as a template/guide
    * mostly to change back from lazy-lspconfig (with nix) to mason
    * to improve my choice of key mappings
    * will eventually replace nvim-env
* fish-env - Fish shell configuration files
  * very opinionated - my main shell
  * permanent configuration flows from configuration files
    * manual configurations can be used for temporary changes
    * manual changes can be lost on configuration file updates
* sway-env - Sway configuration files
  * Sway is a Wayland based tiling window manager modeled after i3
* bash-env - Bash $HOME based configuration files
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
