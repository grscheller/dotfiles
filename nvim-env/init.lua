--[[ GRS Neovim Configuration - using lazy.nvim ]]

-- Fallback colorscheme
vim.cmd [[colorscheme lunaperche]]

-- Load globals & options
require 'grs.config.globals'
require 'grs.config.options'

-- Configure LSP clients natively
require 'grs.core/lsp'

-- Load initial keymaps
require 'grs.config.keymaps'

-- Bootstrap lazy.nvim and configure plugins
require 'grs.core.lazy'

-- Load autocmds
require 'grs.config.autocmds'
