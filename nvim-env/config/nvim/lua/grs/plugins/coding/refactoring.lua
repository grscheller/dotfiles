--[[ Refactoring.nvim, Refactoring library based on Martin Fowler's book ]]
--
-- This one will require a bit of a learning curve.
--

return {

   {
      'ThePrimeagen/refactoring.nvim',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'nvim-treesitter/nvim-treesitter',
      },
      cmd = 'Refactor',
      keys = {
         {
            '<leader>rs',
            function()
               require('refactoring').select_refactor()
            end,
            mode = { 'n', 'v' },
            noremap = true,
            silent = true,
            expr = false,
            desc = 'select refactoring',
         },
      },
      opts = {},
   },

}
