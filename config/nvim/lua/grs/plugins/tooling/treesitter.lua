--[[ Install Language Modules for Neovim's built-in Treesitter ]]

local tooling = require('grs.config.tooling')

return {

   {
      'nvim-treesitter/nvim-treesitter',
      version = false,
      build = ':TSUpdateSync',
      event = { 'BufReadPost', 'BufNewFile' },
      config = function()
         require('nvim-treesitter.configs').setup {
            ensure_installed = tooling.treesitter_ensure_installed,
            auto_install = true,
            ignore_install = {},
            highlight = {
               enable = true,
               disable = {},
            },
            indent = { enable = true },
         }
      end,
   },

}
