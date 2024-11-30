--[[ Add indentation guides even on blank lines - See :help ibl ]]

return {

   {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      opts = {
         -- indent = { char = '╎' },
         indent = { char = '▏' },
      },
   },

}
