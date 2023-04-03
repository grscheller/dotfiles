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
            { name = 'system clipboard'},
            { mode = { 'n', 'x'}, prefix = ' s' }
         )
         wk.register(
            { name = 'telescope' },
            { prefix = ' t' }
         )
         wk.register(
            { name = 'mason' },
            { prefix = ' m' }
         )
      end,
   }

}
