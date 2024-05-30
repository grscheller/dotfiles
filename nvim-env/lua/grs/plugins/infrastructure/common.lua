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
         local km_late = require'grs.config.km_late'
         wk.setup {
            plugins = {
               spelling = {
                  enabled = true,
                  suggestions = 36,
               },
            },
         }
         km_late.init(wk)
      end
   },

}
