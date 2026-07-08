--[[ GRS Neovim Configuration - using lazy.nvim ]]

-- Load globals, options & diagnostics
require 'config.globals'
require 'config.options'
require 'config.diagnostics'

-- Configure LSP clients natively
require 'config.lsp'

-- Fallback colorscheme
vim.cmd [[colorscheme lunaperche]]

-- Load initial keymaps
require 'config.keymaps'

-- Bootstrap lazy.nvim and configure plugins
require 'core.lazy'

-- Load autocmds
require 'config.usercmds_lsp'
require 'config.autocmds_text'
