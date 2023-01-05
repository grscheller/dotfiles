--[[ Lazy Lua Plugin Manager ]]

-- Install it if it is not already present
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
   spec = 'grs.plugin',
   defaults = { lazy = true, version = '*' },
   install = { colorscheme = { 'kanagawa' } },
   checker = { enabled = true },
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

vim.keymap.set('n', ' L', '<Cmd>Lazy<CR>', { desc = 'lazy gui' })
