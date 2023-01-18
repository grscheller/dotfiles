--[[ Globals - most plugins only read these on startup ]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.python3_host_prog =
   string.format('%s/.local/share/pyenv/shims/python', os.getenv 'HOME')
