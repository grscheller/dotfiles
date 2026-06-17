--[[ GRS Neovim Configuration - using lazy.nvim ]]

-- Load globals, options & other configurations
require 'grs.config.globals'
require 'grs.config.options'
require 'grs.config.configs'

-- Fallback colorscheme
vim.cmd [[colorscheme lunaperche]]

-- Configure LSP clients natively
require 'grs.core.lsp'

-- Load initial keymaps
require 'grs.config.keymaps'

-- Bootstrap lazy.nvim and configure plugins
require 'grs.core.lazy'

-- Load autocmds
require 'grs.config.autocmds_lsp'
require 'grs.config.autocmds_text'
