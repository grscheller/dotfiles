--[[ Globals - loaded before lazy takes control

     - First thing loaded in init.lua
     - most plugins only read these globals on startup

]]

-- Define leader keys once and for all
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd fonts need to be installed and configured in terminal emulator
vim.g.have_nerd_font = true

-- Turn off providers - modern plugins don't use these anymore
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

--{{ Globals for plugins ]]

-- Return to last place you edited when reediting
vim.g.nvim_lastplace = {
   ignore_buftype = { 'quickfix', 'nofile', 'help' },
   ignore_filetype = { 'gitcommit', 'gitrebase' },
   open_folds = true,
}
