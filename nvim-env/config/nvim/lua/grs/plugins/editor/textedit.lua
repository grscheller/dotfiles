--[[ Plugins for general Text editing Related taske ]]

return {

   -- comment out or restore lines and blocks of code
   {
      'numToStr/Comment.nvim',
      lazy = false,
      opts = {
         opleader = {
            line = '<leader>tcc',
            block = '<leader>tcb',
         },
         extra = {
            above = '<leader>tcO',
            below = '<leader>tco',
            eol = '<leader>tcA',
         },
      },
      keys = {
         { '<leader>tc', mode = { 'n', 'x'}, desc = 'toggle comment' },
      },
   },

   -- Surround text objects with matching symbols
   {
      'kylechui/nvim-surround',
      keys = {
         { 'ys', mode = { 'n', 'x' }, desc = 'surround around text' },
         { 'ds', mode = { 'n', 'x' }, desc = 'delete surrounding pair' },
         { 'cs', mode = { 'n', 'x' }, desc = 'change surrounding pair' },
         { '<c-g>s', mode = 'i', desc = 'create empty surrounding pair' },
      },
      config = function()
         require('nvim-surround').setup()
      end,
   },

   -- Quickly jump around window - like sneak but on steroids
   {
      'ggandor/leap.nvim',
      keys = {
         { 's', mode = { 'n', 'x', 'o' }, desc = 'leap forward to' },
         { 'S', mode = { 'n', 'x', 'o' }, desc = 'leap backward to' },
         { 'gs', mode = { 'n', 'x', 'o' }, desc = 'leap from window' },
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
      dependencies = { 'hrsh7th/cmp_nvim_lsp' },
   },

}
