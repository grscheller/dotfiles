--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Plugin management
require('grs.util.packer')

-- Define keybindings; set nav-motion-layout related ones
require('grs.util.keybindings').motion_layout_kb()

-- General Text editing reflecting my personnal preferences
require('grs.options') -- set Neovim options
require('grs.commands') -- Commands & autocmds not related to specific plugins
require('grs.textedit') -- Configure general text editing related plugins

-- Configure an IDE like Neovim based software development environment
require('grs.telescope') -- an extendable fuzzy finder
require('grs.completions') -- configure completions & snippets
require('grs.devel_environment') -- development environment and LSP configuration

-- Theme/Overall Appearance 
require('grs.theming') -- colorscheme, statusline & zen-mode
