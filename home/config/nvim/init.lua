--[[ GRS Neovim Configuration - transitioning to lazy.nvim ]]

-- I don't use these, so set them to something I don't use much
vim.g.mapleader = "^"
vim.g.maplocalleader = "^"

require('lazyvim.config.lazy')
