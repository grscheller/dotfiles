--[[ Plugins for general Text editing Related tasks ]]

return {
   {
      -- Show line indentations when editing code.
      'lukas-reineke/indent-blankline.nvim',
      event = 'InsertEnter',
      main = 'ibl',
      opts = {
         indent = { char = '│' },
      },
   },

   {
      -- When re-editing a file, return
      -- to last place file changed.
      'mrcjkb/nvim-lastplace',
   },

   {
      -- Colorize color names, hexcodes,
      -- and other color formats.
      'norcalli/nvim-colorizer.lua',
      keys = {
         {
            '<leader>C',
            '<cmd>ColorizerToggle<cr>',
            desc = 'toggle colorizer',
         },
      },
      opts = {
         '*',
         css = { rgb_fn = true },
         html = { names = false },
      },
   },

   {
      -- Surround text objects and motions with matching symbols
      'kylechui/nvim-surround',
      version = '^3.1.2',
      event = 'VeryLazy',
      config = function()
         require('nvim-surround').setup {
            keymaps = {
               normal = 'gzz',
               change = 'gzc',
               delete = 'gzd',
               visual = 'gzz',
               visual_line = 'gzl',
            },
         }
      end,
   },

   {
      -- Quickly jump around window
      url = 'https://codeberg.org/andyg/leap.nvim',
      dependencies = { 'folke/which-key.nvim' },
      config = function()
         local wk = require 'which-key'
         wk.add {
            {
               's',
               '<Plug>(leap)',
               mode = { 'n', 'x', 'o' },
               noremap = false,
               desc = 'leap',
            },
            {
               'x',
               '<Plug>(leap-next-to)',
               mode = { 'x', 'o' },
               noremap = false,
               desc = 'leap till',
            },
            {
               'S',
               '<Plug>(leap-from-window)',
               mode = 'n',
               noremap = false,
               desc = 'leap from window',
            },
            {
               'gx',
               '<Plug>(leap-anywhere)',
               mode = { 'n', 'x', 'o' },
               noremap = false,
               desc = 'leap anywhere',
            },
         }

         do
            -- Repeat the last leap with <enter>; step back with <backspace>.
            local leap = require 'leap'
            local clever = require('leap.user').with_traversal_keys
            wk.add {
               {
                  '<cr>',
                  function()
                     leap.leap {
                        ['repeat'] = true,
                        opts = clever('<cr>', '<bs>'),
                     }
                  end,
                  mode = { 'n', 'x', 'o' },
                  desc = 'leap repeat',
               },
               {
                  '<bs>',
                  function()
                     leap.leap {
                        ['repeat'] = true,
                        opts = clever('<bs>', '<cr>'),
                        backward = true,
                     }
                  end,
                  mode = { 'n', 'x', 'o' },
                  desc = 'leap repeat',
               },
            }
         end
      end,
   },
}
