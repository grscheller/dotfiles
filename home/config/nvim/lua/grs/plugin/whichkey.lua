--[[ Which-Key - helps make keybindings user discoverable ]]

return {
   'folke/which-key.nvim',
   event = 'VeryLazy',
   config = function()
      require('which-key').setup {
         plugins = {
            spelling = {
               enabled = true,
               suggestions = 36,
            },
         }
      }
   end,
}
