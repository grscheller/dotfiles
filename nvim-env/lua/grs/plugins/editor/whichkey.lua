--[[ Which-Key - helps make keymaps user discoverable ]]

local keymaps = require 'grs.config.keymaps'

return {

   {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = {
         plugins = {
            spelling = {
               enabled = true,
               suggestions = 36,
            },
         }
      }
   }

}
