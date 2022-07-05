--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Use new Lua based filetype detection instead of the vimL based one.
-- Speeds up start time, avoids generating huge numbers of autocmds.
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Configure an IDE like Neovim based software development environment
require('grs.Packer')       -- Plug-in manager "wbthomason/packer.nvim"
require('grs.Options')      -- Setup options reflecting personal preferences
require('grs.Commands')     -- Commands & autocmds not related to specific plugins
require('grs.KeyMappings')  -- Setup general purpose and plug-in specific keybindings
require('grs.Treesitter')   -- Install language modules for built in treesitter
require('grs.Telescope')    -- Configure telescope, an extendable fuzzy finder
require('grs.TextEdit')     -- Configure general text editing related plugins
require('grs.Completions')  -- Setup completions & snippets
require('grs.DevEnv')       -- Development environment and LSP setup
require('grs.Colorscheme')  -- Colorscheme & statusline
