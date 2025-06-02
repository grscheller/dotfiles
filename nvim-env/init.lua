--[[ GRS Neovim Configuration - using lazy.nvim ]]

-- Fallback colorscheme
vim.cmd [[colorscheme lunaperche]]

-- Load globals & options
require 'grs.config.globals'
require 'grs.config.options'

-- Bootstrap lazy.nvim and configure plugins
require 'grs.core.lazy'

-- Configure LSP clients and keymaps
require 'grs.core/lsp'

-- Load remaining keymaps & autocmds
require 'grs.config.keymaps.early'
require 'grs.config.autocmds.text'
