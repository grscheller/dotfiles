--[[ Plugins for general Text editing Related taske ]]

vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion

return {

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

   -- Folke Zen Mode
   {
      'folke/zen-mode.nvim',
      dependencies = {
         'folke/twilight.nvim',
      },
      keys = {
         { 'zZ', '<cmd>ZenMode<cr>', desc = 'zen-mode toggle' },
      },
      opts = {
         window = {
            backdrop = 1.0, -- shade backdrop, 1 to keep normal
            width = 0.85, -- abs num of cells when > 1, % of width when <= 1
            height = 1, -- abs num of cells when > 1, % of height when <= 1
            options = {
               number = false,
               relativenumber = false,
               colorcolumn = '',
            },
         },
         plugins = {
            options = {},
            twilight = { enable = true },
         },
         on_open = function(win)
            vim.api.nvim_win_set_option(win, 'scrolloff', 10)
            vim.api.nvim_win_set_option(win, 'sidescrolloff', 8)
         end,
         on_close = function() end,
      },
   },

}
