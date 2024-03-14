# nvim

Neovim configuration files.

* uses folke/lazy.nvim as the plugin manager
* hrsh7th/nvim-cmp completions integrated with LSP
* dundalek/lazy-lspconfig for Nix based LSP management
* neovim/nvim-lspconfig for PM or manually installed LSP servers
* mfussenegger/nvim-lint to inject cli linting into vim.diagnostics
* mhartington/formatter.nvim to run formatters
* always a work in progress

Can be used either as a standalone repo, or as a git submodule for
the `grscheller/dotfiles` GitHub repo.

## Installation Location

To install these files to `$XDG_CONFIG_HOME/nvim` from a standalone
alone `grscheller/nvim` repo:

```
   $ ./nvInstall [-s {install|check|repo}]
```

If `grscheller/nvim` is a submodule of `grscheller/dotfiles`, do not run
it directly from the submodule.  It is designed to be called from
a subshell of `dfInstall`.

## Public Domain Declaration

To the extent possible under law,
[Geoffrey R. Scheller](https://github.com/grscheller)
has waived all copyright and related or neighboring rights to
[grscheller/nvim](https://github.com/grscheller/nvim).
This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
