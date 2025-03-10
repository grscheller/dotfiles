--[[ Plugins for general Text editing Related taske ]]

return {

   -- Colorize color names, hexcodes, and other color formats
   {
      'norcalli/nvim-colorizer.lua',
      keys = {
         { '<leader>tC', '<cmd>ColorizerToggle<cr>', desc = 'toggle colorizer' },
      },
      opts = {
         '*',
         css = { rgb_fn = true },
         html = { names = false },
      },
   },

   -- Comment out or restore lines and blocks of code
   {
     'numToStr/Comment.nvim',
      event = 'VeryLazy',
      config = true,
   },

   -- Surround text objects with matching symbols
   {
      'kylechui/nvim-surround',
      version = '*',
      event = 'VeryLazy',
      config = function()
         require('nvim-surround').setup {
            keymaps = {
               insert          = '<C-g>z',
               insert_line     = '<C-g>Z',
               normal          = 'gz',
               normal_cur      = 'gZ',
               normal_line     = 'gzz',
               normal_cur_line = 'gZZ',
               visual          = 'gz',
               visual_line     = 'gZ',
               delete          = 'gzd',
               change          = 'gzr',
               change_line     = 'gzR',
            },
         }
      end,
   },

   -- Quickly jump around window - like sneak but on steroids
   {
      'ggandor/leap.nvim',
      keys = {
         { 's', mode = { 'n', 'x', 'o' }, desc = 'leap forward to' },
         { 'S', mode = { 'n', 'x', 'o' }, desc = 'leap backward to' },
         { 'gs', mode = { 'n', 'x', 'o' }, desc = 'leap from window' },
         { 'gS', mode = { 'n', 'x', 'o' }, desc = 'leap' },
      },
      config = function()
         local leap = require 'leap'
         leap.opts.case_sensitive = true
         leap.add_default_mappings(true)
      end,
   },

   -- Show line indentations when editing code
   {
      'lukas-reineke/indent-blankline.nvim',
      event = 'InsertEnter',
   },

}
