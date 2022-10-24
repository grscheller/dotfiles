--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Plugin manager
require('grs.util.packer')

-- Set options and general text editing related plugins
require('grs.options')
require('grs.textedit')

-- Configure an IDE like LSP based software development environment
require('grs.devel')

-- Theme/Appearance - colorscheme, statusline & zen-mode
require('grs.theming')
