--[[ Needed by multiple plugins or important to infrastructure ]]

return {
   -- Once bootstrapped, lazy.nvim will keep itself updated
   { 'folke/lazy.nvim' },

   -- library used by many other plugins
   { 'nvim-lua/plenary.nvim' },

   -- make plugins dot-repeatable, if they "opt-in"
   { 'tpope/vim-repeat', lazy = false },
}
