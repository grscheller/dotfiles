--[[ Tooling: Install 3rd party tools & Treesitter language modules ]]

local ensureInstalled = require('grs.config.tooling').treesitter_ensure_installed

return {

   -- Install Language Modules for Neovim's built-in Treesitter
   {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdateSync',
      event = { 'BufReadPost', 'BufNewFile' },
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
   }

}
