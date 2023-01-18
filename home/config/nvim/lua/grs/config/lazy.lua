--[[ Lazy Lua Plugin Manager ]]

-- Install if not already installed
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
   spec = 'grs.plugins',
   defaults = { lazy = true, version = '*' },
   install = { colorscheme = { 'kanagawa' } },
   checker = { enabled = true }, -- check for plugin updates
   performance = {
      rtp = {
         disabled_plugins = {
            'gzip',
            'matchit',
            'matchparen',
            'netrwPlugin',
            'rplugin',
            'tarPlugin',
            'tohtml',
            'tutor',
            'zipPlugin',
         },
      },
   },
}

vim.keymap.set('n', '<leader>L', '<Cmd>Lazy<CR>', { desc = 'lazy gui' })
