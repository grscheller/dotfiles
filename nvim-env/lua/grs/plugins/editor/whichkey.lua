--[[ Which-Key - helps make keymaps user discoverable ]]

local keymaps = require 'grs.config.keymaps'

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

         -- Setup prefix keys
         keymaps.prefixes(wk)
      end,
   }

}
