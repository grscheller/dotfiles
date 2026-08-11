--[[ GRS Neovim Configuration - using lazy.nvim

     Note: libuv-watchdirs has known performance issues.
     Consider installing inotify-tools. To install on
     PopOS and other Ubuntu derivatives use

       $ sudo apt install inotify-tools

]]

-- Load globals, options & diagnostics
require 'config.globals'
require 'config.options'
require 'config.diagnostics'

-- Fallback colorscheme
vim.cmd [[colorscheme lunaperche]]

-- Load initial keymaps
require 'config.keymaps'

-- Bootstrap lazy.nvim and configure plugins
require 'core.lazy'

-- Configure LSP clients natively
require 'core.lsp'

-- Load autocmds
require 'config.autocmds'
