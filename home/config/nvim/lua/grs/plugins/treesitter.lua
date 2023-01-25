--[[ Install Language Modules for Neovim's built-in Treesitter ]]

local ts = require('grs.config.treesitter')

return {

   {
      'nvim-treesitter/nvim-treesitter',
      version = false,
      build = ':TSUpdateSync',
      event = 'BufReadPost',
      config = function()
         require('nvim-treesitter.configs').setup {
            highlight = { enable = true },
            indent = { enable = true },
            context_commentstring = {
               enable = true,
               enable_autocmd = false,
            },
            ensure_installed = ts.ensure_installed,
         }
      end,
   },

}
