--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Use new Lua based filetype detection instead of vimL
-- based one.  Speeds up start time and avoids the many
-- the generation of a huge number of autocommands.
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Speed up start times, impatient must be 1st Lua module loaded.
if not pcall(require, 'impatient') then
  print('Warning: Plugin "impatient" not loaded ')
end

-- Using "wbthomason/packer.nvim" as plug-in manager
require('grs.Packer')

-- Configure an IDE like Neovim software development environment
require('grs.Options')      -- Setup options and autocmds
require('grs.KeyMappings')  -- Setup some general purpose keybindings
require('grs.TextEdit')     -- Configure general text editing related plugins
require('grs.Treesitter')   -- Install language modules for built in treesitter
require('grs.Telescope')    -- Configure telescope, an extendable fuzzy finder
require('grs.Completions')  -- Setup completions & snippets
require('grs.DevEnv')       -- Development environment and LSP setup
require('grs.Colorscheme')  -- Colorscheme & statusline
