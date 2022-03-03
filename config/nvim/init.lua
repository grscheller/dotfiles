--[[ Neovim configuration ~/.config/nvim/init.lua ]]

require('grs.myBehaviors')       -- Personnal Neovim Tweaks
require('grs.myPlugins')         -- Using Packer
require('grs.setupColorscheme')  -- Colorscheme & Statusline
require('grs.setupTreesitter')   -- Install Language Modules for Treesitter 
require('grs.setupTelescope')    -- Fuzzy Finder Over Lists
require('grs.setupLSP')          -- Language Server Protocol Settings
require('grs.setupCompletions')  -- Completion and Snippet Support
require('grs.myKeybindings')     -- WhickKey to Manage Keybindings
