--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Use new Lua based filetype detection instead of
-- vimL based one.  Speeds up start time and avoids
-- the generation of a huge number of autocommands.
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Configure an IDE like Neovim software development environment
require('grs.Packer')       -- Plug-in manager "wbthomason/packer.nvim"
require('grs.Options')      -- Setup options and autocmds
require('grs.KeyMappings')  -- Setup some general purpose keybindings
require('grs.TextEdit')     -- Configure general text editing related plugins
require('grs.Treesitter')   -- Install language modules for built in treesitter
require('grs.Telescope')    -- Configure telescope, an extendable fuzzy finder
require('grs.Completions')  -- Setup completions & snippets
require('grs.DevEnv')       -- Development environment and LSP setup
require('grs.Colorscheme')  -- Colorscheme & statusline
