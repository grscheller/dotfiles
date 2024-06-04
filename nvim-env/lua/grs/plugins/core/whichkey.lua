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

         wk.register {
            ['<bslash>']  = { name = 'diagnostics' },
            ['<leader>']  = { name = 'space' },
            ['<c-b>'] = { name = 'blackhole' },
            ['<c-s>'] = { name = 'system clipboard' },
         }

         wk.register({
            ['<leader>']  = { name = 'space' },
            ['<c-b>']     = { name = 'blackhole' },
            ['<c-s>']     = { name = 'system clipboard' },
         }, { mode = 'v' })

         --[[ Prefixes used by multiple plugins ]]

         wk.register {
            ['<leader>s'] = { name = 'search' },
            ['<leader>t'] = { name = 'toggle' },
         }

         --[[ Logical keymap groupings spanning multiple plugins ]]

         wk.register {
            -- plugin/package managers keymaps
            name = 'package managers',
            ['<leader>p']  = { name = 'plugin/package managers' },
            ['<leader>pl'] = { '<cmd>Lazy<cr>', 'Lazy gui' },
            ['<leader>pm'] = { '<cmd>Mason<cr>', 'Mason gui' },
         }

         --[[ Keymaps for plugins configured with just an opts table ]]

         wk.register {
            ['<leader>h'] = { name = 'harpoon' },
            ['<leader>R'] = { name = 'refactoring' },
            ['<leader>tt'] = { '<cmd>TSBufToggle highlight<cr>', 'toggle treesitter highlighting' }
         }

         wk.register({
            ['<leader>R'] = { name = 'refactoring' },
         }, { mode = 'v' })
      end
   },

}
