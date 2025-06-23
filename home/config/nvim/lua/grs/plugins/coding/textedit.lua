--[[ Plugins for general Text editing Related tasks ]]

return {
   {
      -- Show line indentations when editing code
      'lukas-reineke/indent-blankline.nvim',
      event = 'InsertEnter',
      main = 'ibl',
      opts = {
         indent = { char = '│' },
      },
   },

   {
      -- when re-editing a file, return to last place file changed
      'mrcjkb/nvim-lastplace'
   },

   {
      -- Colorize color names, hexcodes, and other color formats
      'norcalli/nvim-colorizer.lua',
      keys = {
         { '<leader>C', '<cmd>ColorizerToggle<cr>', desc = 'toggle colorizer' },
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
      -- Quickly jump around window - like sneak but on steroids
      'ggandor/leap.nvim',
      keys = {
         { 's', mode = { 'n', 'x', 'o' }, desc = 'leap forward to' },
         { 'S', mode = { 'n', 'x', 'o' }, desc = 'leap backward to' },
         { 'gs', mode = { 'n' }, desc = 'leap from window' },
      },
      config = function()
         local leap = require 'leap'
         leap.opts.case_sensitive = true
         leap.add_default_mappings(true)
      end,
   },
}
