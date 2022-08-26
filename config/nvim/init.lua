--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Use new Lua based filetype detection instead of the vimL based one.
-- Speeds up start time, avoids generating huge numbers of autocmds.
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Plugin manager
require('grs.util.packer')

-- General Text editing reflecting personnal preferences
require('grs.options') -- Neovim options
require('grs.commands') -- Commands & autocmds not related to specific plugins
require('grs.util.keymappings') -- Set general keymappings
require('grs.textedit') -- Configure general text editing related plugins

-- Configure an IDE like Neovim based software development environment
require('grs.telescope') -- Configure telescope, an extendable fuzzy finder
require('grs.completions') -- Configure completions & snippets
require('grs.devel_environment') -- Development environment and LSP configuration

-- Theme/Overall Appearance 
require('grs.appearance') -- Colorscheme, statusline & zen-mode
