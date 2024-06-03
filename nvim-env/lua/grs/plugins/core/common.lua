--[[ Needed by multiple plugins or important to infrastructure ]]

return {

   -- Once bootstrapped, lazy.nvim will keep itself updated
   { 'folke/lazy.nvim' },

   -- library used by many other plugins
   { 'nvim-lua/plenary.nvim' },

   -- make plugins dot-repeatable, if they "opt-in"
   { 'tpope/vim-repeat', lazy = false },

   -- configure patched fonts for plugins that need them
   -- note: terminal must be configured to use a patch font
   {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
      opts = {
         color_icons = true,
         default = true,
         strict = true,
      },
   },

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

         --[[ setup prefixes for km_early.lua keymaps ]]

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

         --[[ prefixes used by multiple plugins ]]

         wk.register {
            ['<leader>h'] = { name = 'harpoon' },  -- TODO: move to harpoon2 configuration
            ['<leader>p'] = { name = 'plugin/package managers' },
            ['<leader>R'] = { name = 'refactoring' },  -- TODO: move to refactoring configuration
            ['<leader>s'] = { name = 'search' },
            ['<leader>t'] = { name = 'toggle' },
         }

         wk.register({
            ['<leader>R'] = { name = 'refactoring' },  -- TODO: move to refactoring configuration
         }, { mode = 'v' })

         -- plugin/package managers keymaps
         wk.register {
            name = 'package managers',
            ['<leader>pl'] = { '<cmd>Lazy<cr>', 'Lazy gui' },
            ['<leader>pm'] = { '<cmd>Mason<cr>', 'Mason gui' },
         }

         -- toggle treesitter highlighting
         wk.register {  -- TODO: move to treesitter configuration
            ['<leader>tt'] = { '<cmd>TSBufToggle highlight<cr>', 'treesitter highlighting' }
         }
      end
   },

}
