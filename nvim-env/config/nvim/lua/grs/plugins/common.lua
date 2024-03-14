--[[ Plugins with no good place or could go multiple places ]]

local ensureInstalled = require('grs.config.treesitter').ensure_installed

return {

   -- Once bootstrapped, lazy.nvim will keep itself updated ]]
   { 'folke/lazy.nvim' },

   -- library used by many other plugins
   { "nvim-lua/plenary.nvim" },

   -- Install Language Modules for Neovim's built-in Treesitter
   {
      'nvim-treesitter/nvim-treesitter',
      config = function()
         require('nvim-treesitter.configs').setup {
            ensure_installed = ensureInstalled,
            auto_install = true,
            ignore_install = {},
            highlight = {
               enable = true,
               disable = {},
            },
            indent = { enable = true },
         }
      end,
      build = ':TSUpdate',
   }

}
