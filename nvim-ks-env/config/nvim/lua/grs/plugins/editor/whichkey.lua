--[[ Which-Key - helps make keymaps user discoverable ]]

local km = vim.keymap.set

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

         wk.register(
            {
               name = 'diagnosics & dap',
            }, {
               prefix = '<bslash>',
               mode = 'n',
            }
         )

         wk.register(
            {
               name = 'package managers',
            }, {
               prefix = '<leader>p',
               mode = 'n',
            }
         )

         wk.register(
            {
               name = 'code',
            }, {
               prefix = '<leader>c',
               mode = 'n',
            }
         )

         wk.register(
            {
               name = 'document',
            }, {
               prefix = '<leader>d',
               mode = 'n',
            }
         )

         wk.register(
            {
               name = 'goto',
            }, {
               prefix = '<leader>g',
               mode = 'n',
            }
         )

         wk.register(
            {
               name = 'rename',
            }, {
               prefix = '<leader>r',
               mode = 'n',
            }
         )

         wk.register(
            {
               name = 'search',
            }, {
               prefix = '<leader>s',
               mode = 'n',
            }
         )

         wk.register(
            {
               name = 'toggle',
            }, {
               prefix = '<leader>t',
               mode = 'n',
            }
         )

         wk.register(
            {
               name = 'git Hunk'
            }, {
               prefix = '<leader>H',
               mode = { 'n', 'v' },
            }
         )

         wk.register(
            {
               name = 'harpoon',
            }, {
               prefix = '<leader>h',
               mode = 'n',
            }
         )

         --[[ Setup some general keymapping ]]

         -- plugin/package managers keymaps
         km('n', '<leader>pl', '<cmd>Lazy<cr>', { desc = 'lazy gui' })
         km('n', '<leader>pm', '<cmd>Mason<cr>', { desc = 'mason gui' })

         -- treesitter related keymaps
         km('n', '<leader>tt', '<cmd>TSBufToggle highlight<cr>', {
            desc = 'toggle treesitter highlighting',
         })
      end,
   }

}
