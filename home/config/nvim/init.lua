--[[ GRS Neovim Configuration - using lazy.nvim without LazyVim ]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install folke/lazy.nvim if not already installed
local lazypath = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath 'data')
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
   }
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
   spec = 'grs.plugins',
   defaults = { lazy = true, version = '*' },
   install = { colorscheme = { 'kanagawa' } },
   checker = { enabled = true }, -- check for plugin updates
   performance = {
      rtp = {
         disabled_plugins = {
            'gzip',
            'matchit',
            'matchparen',
            'netrwPlugin',
            'tarPlugin',
            'tohtml',
            'tutor',
            'zipPlugin',
         },
      },
   },
}

vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = 'lazy gui' })
