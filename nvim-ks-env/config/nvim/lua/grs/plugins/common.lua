--[[ Plugins used as dependencies for multiple plugins in different places ]]

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

}
