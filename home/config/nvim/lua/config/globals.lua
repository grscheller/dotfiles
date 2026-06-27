--[[ Globals - loaded before lazy takes control

     - First thing loaded in init.lua
     - most plugins only read these globals on startup

--]]

-- Define leader keys once and for all
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Python provider for pynvim
vim.g.python3_host_prog = vim.fs.joinpath(
   vim.fs.abspath '~',
   'devel',
   'venvs',
   'python_venv',
   'bin',
   'python'
)

-- Nerd fonts need to be installed and configured in terminal emulator
vim.g.have_nerd_font = true

-- Perl had its day - it had the best man pages ever
vim.g.loaded_perl_provider = 0

--{{ Globals for plugins ]]

-- Return to last place you edited when reediting
vim.g.nvim_lastplace = {
   ignore_buftype = { 'quickfix', 'nofile', 'help' },
   ignore_filetype = { 'gitcommit', 'gitrebase' },
   open_folds = true,
}

-- Default nvim-surround mappings clash with leap.nvim mappings
vim.g.nvim_surround_no_mappings = true
