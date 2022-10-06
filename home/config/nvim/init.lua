--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Plugin management
require('grs.util.packer')

-- Define keybindings then set nav/motion/layout keybindings
require('grs.util.keybindings').motion_layout_kb()

-- General Text editing reflecting my personnal preferences
require('grs.options') -- set Neovim options
require('grs.commands') -- commands & autocmds
require('grs.textedit') -- general text editing related plugins

-- Configure IDE like Neovim software development environment
require('grs.telescope') -- an extendable fuzzy finder
require('grs.completions') -- configure completions & snippets
require('grs.devel_environment') -- soft dev env & LSP config

-- Theme/Overall Appearance 
require('grs.theming') -- colorscheme, statusline & zen-mode
