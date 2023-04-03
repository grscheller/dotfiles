--[[ GRS Neovim Configuration - using lazy.nvim without LazyVim ]]

-- Set leader keys once and for all
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

-- lazy.nvim configuration , see :h lazy.nvim-lazy.nvim-configuration
vim.opt.rtp:prepend(lazypath)

local opts = {
   defaults = { lazy = true, version = '*' },
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
   ui = { browser = '/usr/bin/firefox' },
   checker = { enabled = true },
   performance = {
      cache = { enabled = true },
      rtp = {
         reset_packpath = true,
         paths = {},
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

-- Let lazy.nvim take control
require('lazy').setup('grs.plugins', opts)
