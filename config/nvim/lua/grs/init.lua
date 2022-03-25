--[[ Lua module grs: sequencing & configuration

       Module: grs
       File: ~/.config/nvim/lua/grs/init.lua

  ]]

require('grs.Options')      -- Setup options, functions, autocmds
require('grs.Packer')       -- Setup plugin manager
require('grs.WhichKey')     -- Setup keybindings
require('grs.Colorscheme')  -- Colorscheme & statusline
require('grs.Treesitter')   -- Install language modules for built in treesitter
require('grs.Telescope')    -- Configure telescope, an extendable fuzzy finder
require('grs.Completions')  -- Setup completions & snippets
require('grs.DevEnv')       -- Development environment and LSP setup
