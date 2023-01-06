--[[ GRS Neovim Configuration - transitioning to lazy.nvim ]]

-- These are just redundant navigation keys, so if some plugin
-- unexpectently sets leader or localleader keymappingd, they
-- are less likely to collide with my keymappings.
vim.g.mapleader = "-"
vim.g.maplocalleader = "+"

require('grs.config.lazy')
