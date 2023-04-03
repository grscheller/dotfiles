--[[ Which-Key - helps make keymaps user discoverable ]]

return {

   {
      'folke/which-key.nvim',
      event = 'VeryLazy',
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
      end,
   }

}
