--[[ GRS Neovim Configuration - using lazy.nvim ]]

local ok, globals, options, keymaps, autocmds, lazy

-- Load globals & options before the lazy plugin manager starts,
-- the keymaps and autocmds can wait until the end to be loaded.
ok, globals = pcall(require, 'grs.config.globals')
if not ok then
   print(string.format('\n\nGlobals failed to load with error:\n\n %s\n\n', globals))
end

ok, options = pcall(require, 'grs.config.options')
if not ok then
   print(string.format('\n\nKeymaps failed to load with error:\n\n %s\n\n', options))
end

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
ok, lazy = pcall(require, 'lazy')
if ok then
   -- Let lazy.nvim take control
   lazy.setup(lazy_opts)
else
   print(string.format('\n\nERROR: lazy.nvim failed to load with error:\n\n %s\n\n', lazy))
   vim.cmd [[colorscheme habamax]]
end

-- Load keymaps and auto commands
ok, keymaps = pcall(require, 'grs.config.keymaps')
if not ok then
   print(string.format('\n\nKeymaps failed to load with error:\n\n %s\n\n', keymaps))
end

-- Load auto-commands
ok, autocmds = pcall(require, 'grs.config.autocmds')
if not ok then
   print(string.format('\n\nAutocmds failed to load with error:\n\n %s\n\n', autocmds))
end
