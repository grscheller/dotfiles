--[[ lazy.nvim configuration, see :h lazy.nvim-lazy.nvim-configuration ]]

local ok, lazy

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

local lazy_opts = {
   defaults = { lazy = false, version = nil, cond = nil },
   spec = { { import = 'grs.plugins' } },
   ui = {
      browser = '/usr/bin/firefox',
      icons = {
         plugin = '🔌',
      },
   },
   performance = {
      pkg = {
         enabled = true,
         cache = vim.fn.stdpath 'state' .. '/lazy/pkg-cache.lua',
         -- the first package source that is found for a plugin will be used.
         sources = {
            'lazy',
            'rockspec', -- will only be used when rocks.enabled is true
            'packspec',
         },
      },
      rocks = {
         enabled = true,
         root = vim.fn.stdpath 'data' .. '/lazy-rocks',
         server = 'https://nvim-neorocks.github.io/rocks-binaries/',
         -- use hererocks to install luarocks?
         -- set to `nil` to use hererocks when luarocks is not found
         -- set to `true` to always use hererocks
         -- set to `false` to always use luarocks
         hererocks = false,
      },
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
   lazy.setup(lazy_opts)
else
   local fmt = '\n\nERROR: lazy.nvim failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, lazy))
end
