--[[ Needed by multiple plugins or important to infrastructure ]]

return {

   {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      config = function ()
         local wk = require 'which-key'
         wk.setup {
            plugins = {
               spelling = {
                  enabled = true,
                  suggestions = 36,
               },
            },
         }

         --[[ Prefixes for keymaps_early.lua keymaps ]]

         wk.add {
            { '<bslash>', group = 'diagnostics & dap' },
            { '<leader>', group = 'space' },
            { '<c-b>', group = 'blackhole' },
            { '<c-s>', group = 'system clipboard' },
         }

         wk.add {
            mode = { 'v' },
            { '<leader>', group = 'space' },
            { '<c-b>', group = 'blackhole' },
            { '<c-s>', group = 'system clipboard' },
         }

         --[[ Prefixes used by multiple plugins ]]

         wk.add {
            { '<leader>s', group = 'search' },
            { '<leader>t', group = 'toggle' },
         }

         --[[ Logical keymap groupings spanning multiple plugins ]]

         wk.add {
            -- plugin/package managers keymaps
            name = 'package managers',
            { '<leader>p', group = 'plugin/package managers' },
            { '<leader>pl', '<cmd>Lazy<cr>', desc = 'Lazy gui' },
            { '<leader>pm', '<cmd>Mason<cr>', desc = 'Mason gui' },
         }

         --[[ Keymaps for plugins configured with just an opts table ]]

         wk.add {
            { '<leader>R', group = 'refactoring' },
            { '<leader>tt', '<cmd>TSBufToggle highlight<cr>', desc = 'toggle treesitter highlighting' }
         }

         wk.add {
            mode = { 'v' },
            { '<leader>R', group = 'refactoring' },
         }
      end
   },

}
