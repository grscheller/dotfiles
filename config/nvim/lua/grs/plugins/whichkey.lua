--[[ Which-Key - helps make keymaps user discoverable ]]

return {

   {
      'folke/which-key.nvim',
      lazy = false,
      priority = 800,
      config = function()
         local wk = require('which-key')
         wk.setup {
            plugins = {
               spelling = {
                  enabled = true,
                  suggestions = 36,
               },
            }
         }

         -- for Which-Key menus
         wk.register(
            { name = '<space>' },
            { prefix = '<leader>' }
         )
         wk.register(
            { name = 'lazy' },
            { prefix = '<leader>l' }
         )
         wk.register(
            { name = 'system clipboard'},
            { mode = { 'n', 'x'}, prefix = '<leader>s' }
         )
         wk.register(
            { name = 'mason' },
            { prefix = '<leader>m' }
         )
         wk.register(
            { name = 'telescope' },
            { prefix = '<leader>t' }
         )
         wk.register(
            { name = 'dap' },
            { prefix = '<\\>' }
         )
         wk.register(
            { name = 'lsp+g' },
            { prefix = 'g' }
         )
         wk.register(
            { name = 'lsp+z (no folds)' },
            { prefix = 'z' }
         )
      end,
   }

}
