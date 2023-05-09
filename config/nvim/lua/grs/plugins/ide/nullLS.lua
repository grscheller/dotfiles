--[[ Configure null-ls builtins ]]

local getNullLsSources = require('grs.utils.lspUtils').getNullLsSources

return {

   {
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
         local null_ls = require 'null-ls'
         null_ls.setup { sources = getNullLsSources(null_ls) }
      end,
   },

}
