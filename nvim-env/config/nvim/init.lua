--[[ GRS Neovim Configuration - using lazy.nvim without LazyVim ]]

-- Load globals & options here, before lazy starts. Keymaps and autocmds
-- are done at rhe end.
require 'grs.config.globals'
require 'grs.config.options'

-- Bootstrap folke/lazy.nvim if not already installed,
-- if bootstrapped remove packer infrastucture too.
local lazypath = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath 'data')
local packerpath = string.format('%s/site/pack/packer', vim.fn.stdpath 'data')
local packercomp = string.format('%s/plugin/packer/packer_compiled.lua', vim.fn.stdpath 'config')
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
   }
   vim.fn.system {
      'rm',
      '-rf',
      packerpath,
      packercomp,
   }
end

-- Enable Neovim to find lazy.nvim
vim.opt.rtp:prepend(lazypath)

-- Initial lazy.nvim configuration, see :h lazy.nvim-lazy.nvim-configuration
local lazy_opts = {
   spec = { { import = 'grs.plugins' } },
   defaults = { lazy = true, version = false },
   git = {
      log = { '--since=5 days ago' },
      url_format = 'https://github.com/%s.git',
   },
   dev = {
      path = '~/devel/plugins',
      patterns = {}, -- { 'grscheller' },
      fallback = true,
   },
   ui = { browser = '/usr/bin/firefox' },
   checker = { enabled = true },
   performance = {
      cache = { enabled = true },
      rtp = {
         disabled_plugins = {
            '2html_plugin',
            'getscript',
            'getscriptPlugin',
            'gzip',
            'logiPat',
            'matchit',
            'matchparen',
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
