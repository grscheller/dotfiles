--[[ Globals - loaded before lazy takes control ]]

-- Loaded very early in init.lua, most plugins only read these on startup.

-- Set leader keys once and for all
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Python managed by pyenv
vim.g.python3_host_prog = string.format(
   '%s/devel/python_envs/neovim/bin/python',
   os.getenv 'HOME'
)

-- Perl had its day
vim.g.loaded_perl_provider = 0
