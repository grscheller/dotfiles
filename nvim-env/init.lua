--)[[ GRS Neovim Configuration - using lazy.nvim ]]

local ok, lazy, pcall_msg

-- Load globals, options & keymaps not depending on external plugins
ok, pcall_msg = pcall(require, 'grs.config.globals')
if not ok then
   local fmt = '\n\nGlobals failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, pcall_msg))
end

ok, pcall_msg = pcall(require, 'grs.config.options')
if not ok then
   local fmt = '\n\nOptions failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, pcall_msg))
end

ok, pcall_msg = pcall(require, 'grs.config.keymaps.early')
if not ok then
   local fmt = '\n\nEarly keymaps failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, pcall_msg))
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
   -- Configure plugins with lazy.nvim
   lazy.setup(lazy_opts)

   -- Configure LSP's not requiring plugins
   ok, pcall_msg = pcall(require, 'grs.config.lsp')
   if not ok then
      local fmt = '\n\nLSP configurations failed to load with error:\n\n %s\n\n'
      print(string.format(fmt, pcall_msg))
   end

   --  Load autocmds that depend on plugins
   ok, pcall_msg = pcall(require, 'grs.config.autocmds.lsp')
   if not ok then
      local fmt = '\n\nLSP autocmds failed to load with error:\n\n %s\n\n'
      print(string.format(fmt, pcall_msg))
   end
else
   local fmt = '\n\nERROR: lazy.nvim failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, lazy))
end

--[[ Load auto-commands that don't rely on plugins ]]

ok, pcall_msg = pcall(require, 'grs.config.autocmds.text')
if not ok then
   local fmt = '\n\nText autocmds failed to load with error:\n\n %s\n\n'
   print(string.format(fmt, pcall_msg))
end
