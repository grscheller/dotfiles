return {
   -- Show line indentations when editing code.
   [1] = 'lukas-reineke/indent-blankline.nvim',
   event = 'InsertEnter',
   main = 'ibl',
   opts = {
      indent = { char = '│' },
   },
}
