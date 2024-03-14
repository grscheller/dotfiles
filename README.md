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
* fish-env - Fish shell configuration files
  * very opinionated
  * permanent configuration flows from configuration files
    * manual configurations can be used for temporary changes
    * manual changes can be lost on configuration file updates
* home-env - Bash & other $HOME based configuration files
  * bash (startup files)
  * ~/bin scripts
  * other configuration files
    * ssh
    * bloop (Scala)
    * Cabal (Haskell)
* sway-env - Sway configuration files
  * Sway is a Wayland based tiling window manager modeled after i3 
* root-env - Arch Linux system configuration files

Currently only tested out on Arch Linux.

## Scripts

* [dfInstall](dfInstall)
  * Installs "dotfiles" to "$HOME"
  * Usage: `./dfInstall [-s {install|check|repo}]`
* [sfInstall](sfInstall)
  * Installs "root-env/" files to "/"
  * Usage: `sudo ./root-env/sfInstall`

## Public Domain Declaration

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
