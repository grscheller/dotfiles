--[[ Globals - loaded before lazy takes control ]]

-- First thing loaded in init.lua, most plugins only read these on startup.

-- Set leader keys once and for all
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Perl had its day
vim.g.loaded_perl_provider = 0

-- Nerd fonts need to be configured in terminal emulator
vim.g.have_nerd_font = true
