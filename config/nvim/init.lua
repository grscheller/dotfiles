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

-- Setup lazy.nvim, see :h lazy.nvim-lazy.nvim-configuration
require('lazy').setup {
   defaults = { lazy = true, version = '' },
   spec = 'grs.plugins',
   git = {
      log = { '--since=5 days ago' },
      timeout = 120,  -- seconds
      url_format = 'https://github.com/%s.git',
      filter = true,
   },
   dev = {
      path = '~/devel/scheller-linux-archive/plugins',
      patterns = { 'grscheller' },
      fallback = false,
   },
   install = {
      missing = true,
      colorscheme = { 'habamax' },
   },
   ui = { browser = '/usr/bin/firefox' },
   diff = { cmd = 'git' },
   checker = { enabled = true },
   performance = {
      rtp = {
         disabled_plugins = {
            '2html_plugin',
            'getscript',
            'getscriptPlugin',
            'gzip',
            'logiPat',
            'matchit',
            'matchparen',
            'rrhelper',
            'tar',
            'tarPlugin',
            'tutor',
            'vimball',
            'vimballPlugin',
            'zip',
            'zipPlugin',
         },
      },
   },
}

vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = 'lazy gui' })
