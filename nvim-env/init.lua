--)[[ GRS Neovim Configuration - using lazy.nvim ]]

local ok, globals, options, keymaps_early, lazy, autocmds

-- Load globals, options & keymaps not depending on external plugins
ok, globals = pcall(require, 'grs.config.globals')
if not ok then
   local fmt = '\n\nGlobals failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, globals))
end

ok, options = pcall(require, 'grs.config.options')
if not ok then
   local fmt = '\n\nOptions failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, options))
end

ok, keymaps_early = pcall(require, 'grs.config.keymaps_early')
if not ok then
   local fmt = '\n\nEarly keymaps failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, keymaps_early))
end

-- Fallback colorscheme
vim.cmd [[colorscheme lunaperche]]

-- Bootstrap folke/lazy.nvim if not already installed
local lazypath = string.format('%s/lazy/lazy.nvim', vim.fn.stdpath 'data')
local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
if not vim.uv.fs_stat(lazypath) then
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
vim.opt.runtimepath:prepend(lazypath)

--[[ lazy.nvim configuration, see :h lazy.nvim-lazy.nvim-configuration ]]

local lazy_opts = {
   -- defaults = { lazy = true, version = nil, cond = nil },
   defaults = { lazy = true, version = nil, cond = nil },
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

--[[ Kickoff lazy.nvim or fail gracefully ]]

ok, lazy = pcall(require, 'lazy')
if ok then
   -- Let lazy.nvim take control
   lazy.setup(lazy_opts)
else
   local fmt = '\n\nERROR: lazy.nvim failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, lazy))
end

--[[ Load auto-commands ]]

ok, autocmds = pcall(require, 'grs.config.autocmds')
if not ok then
   local fmt = '\n\nAutocmds failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, autocmds))
end
