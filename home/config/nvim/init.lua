--[[ GRS Neovim Configuration - using lazy.nvim

     Note: libuv-watchdirs has known performance issues.
     Consider installing inotify-tools. To install on
     PopOS and other Ubuntu derivatives use

       $ sudo apt install inotify-tools

     Load order is deliberate. In particular `core.lsp` must precede
     `core.lazy` so that `vim.lsp.config['*']` exists before any
     plugin sources a `plugin/` file that reads it, and `config.lsp`
     must follow `core.lazy` because it references telescope.

]]

-- Load globals, options & diagnostics
require 'config.globals'
require 'config.options'
require 'config.diagnostics'

-- Fallback colorscheme
vim.cmd [[colorscheme lunaperche]]

-- Load initial keymaps
require 'config.keymaps'

-- Configure LSP clients natively -- before lazy.nvim, see core/lsp.lua
require 'core.lsp'

-- Bootstrap lazy.nvim and configure plugins
require 'core.lazy'

-- LSP keymaps, commands & autocmds -- after lazy.nvim
require 'config.lsp'

-- Load autocmds
require 'config.autocmds'
