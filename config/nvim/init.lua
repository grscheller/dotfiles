--[[ GRS Neovim Configuration - using lazy.nvim without LazyVim ]]

-- load globals & options here, before lazy starts,
require 'grs.config.globals'
require 'grs.config.options'

-- autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd('User', {
   pattern = 'VeryLazy',
   callback = function()
      require 'grs.config.autocmds'
      require 'grs.config.keymaps'
   end,
})

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

local lazy_opts = {
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

local ok, lazy, keymaps
ok, lazy = pcall(require, 'lazy')
if ok then
   -- Let lazy.nvim take control
   lazy.setup('grs.plugins', lazy_opts)
else
   -- otherwise, at least load key mappings
   print(string.format('lazy.nvim failed with error: %s', lazy))
   ok, keymaps = pcall(require, 'grs.config.keymaps')
   if not ok then
      print(string.format('Keymaps failed to load with error: %s', keymaps))
   end
end
