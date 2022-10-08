--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Plugin manager
require('grs.util.packer')

-- Define keybindings, then set window/tab related keybindings
require('grs.util.keybindings').navigation_layout_kb()

-- General text editing & text editing related plugins
require('grs.options')
require('grs.textedit')

-- Configure an IDE like LSP based software development environment
require('grs.telescope')
require('grs.completions_snippets')
require('grs.devel_environment')

-- Theme/Appearance - colorscheme, statusline & zen-mode
require('grs.theming')
