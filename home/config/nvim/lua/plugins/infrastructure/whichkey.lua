--[[ Make keymaps discoverable ]]

return {
   {
      -- Makes keymaps discoverable.
      [1] = 'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = {
         plugins = {
            spelling = {
               enabled = true,
               suggestions = 36,
            },
         },
      },
      keys = function()
         return {
            -- which-key keymaps
            {
               '<leader>?',
               function()
                  require('which-key').show { global = false }
               end,
               desc = 'Buffer Local Keymaps (which-key)',
            },

            -- lazy.nvim keymaps
            { '<leader>L', '<cmd>Lazy<cr>', desc = 'Lazy gui' },
         }
      end,
   },
}
