--[[ Plugin for comenting/uncommenting code ]]


return {

   -- comment out or restore lines and blocks of code
   {
      'numToStr/Comment.nvim',
      keys = {
         { '<leader>tc', mode = { 'n', 'x'}, desc = 'toggle comment' },
      },
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
   },

}
