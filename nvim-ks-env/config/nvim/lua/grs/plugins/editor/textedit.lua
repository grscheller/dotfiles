--[[ Plugins for general Text editing Related taske ]]

local comment_overrides = {
   opleader = {
      line = 'gcc',
      block = 'gbb',
   },
   extra = {
      above = 'gcO',
      below = 'gco',
      eol = 'gcA',
   },
}

return {

   -- comment out or restore lines and blocks of code
   { 'numToStr/Comment.nvim', opts = comment_overrides },

   -- makes some plugins dot-repeatable like leap
   { 'tpope/vim-repeat', lazy = false },

   -- Surround text objects with matching symbols
   {
      'kylechui/nvim-surround',
      keys = {
         { 'ys', mode = { 'n', 'x' }, desc = 'surround around text' },
         { 'ds', mode = { 'n', 'x' }, desc = 'delete surrounding pair' },
         { 'cs', mode = { 'n', 'x' }, desc = 'change surrounding pair' },
         { '<c-g>s', mode = 'i', desc = 'empty surrounding pair' },
      },
      config = function()
         require('nvim-surround').setup()
      end
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

}
