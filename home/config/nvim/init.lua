--[[ GRS Neovim Configuration - using lazy.nvim ]]

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
require 'config.lsp'

-- Load text editing autocmds
require 'config.autocmds'
