--[[ GRS Neovim Configuration - using lazy.nvim ]]

-- Load globals & options here, before lazy starts.
-- Keymaps and autocmds are done at the end.
require 'grs.config.globals'
require 'grs.config.options'

-- Bootstrap folke/lazy.nvim if not already installed
local lazypath = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath 'data')
local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      '--branch=stable',
      lazyrepo,
      lazypath,
   }
end

-- Enable Neovim to find lazy.nvim
vim.opt.rtp:prepend(lazypath)

-- Initial lazy.nvim configuration, see :h lazy.nvim-lazy.nvim-configuration
local lazy_opts = {
   -- defaults = { lazy = true, version = nil, cond = nil },
   defaults = { lazy = false, version = nil, cond = nil },
   spec = { { import = 'grs.plugins' } },
   dev = {
      path = '~/devel/nvim/plugins',
      patterns = {},
      fallback = true,
   },
   ui = {
      browser = '/usr/bin/firefox',
      icons = {
         plugin = '🔌',
      },
   },
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
            'netrwPlugin',
            'rplugin',
            'rrhelper',
            'tar',
            'tarPlugin',
            'tohtml',
            'tutor',
            'vimball',
            'vimballPlugin',
            'zip',
            'zipPlugin',
         },
      },
   },
}

-- Kickoff lazy.nvim or fail gracefully
local ok, lazy, keymaps, autocmds
ok, lazy = pcall(require, 'lazy')
if ok then
   -- Let lazy.nvim take control
   lazy.setup(lazy_opts)
else
   print(string.format('lazy.nvim failed with error: %s', lazy))
   vim.cmd [[colorscheme habamax]]
end

-- Load keymaps and auto commands
ok, keymaps = pcall(require, 'grs.config.keymaps')
if not ok then
   print(string.format('Keymaps failed to load with error: %s', keymaps))
end
ok, autocmds = pcall(require, 'grs.config.autocmds')
if not ok then
   print(string.format('Autocmds failed to load with error: %s', autocmds))
end
