--[[ Configure null-ls builtins ]]

-- Do like LazyVim but decouple mason and null-ls

local ideUtils = require 'grs.plugins.ide.utils'
local getNullLsSources = ideUtils.getNullLsSources

return {

   {
      'jose-elias-alvarez/null-ls.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
         local null_ls = require 'null-ls'
         null_ls.setup {
            sources = getNullLsSources(null_ls),
         }
      end,
   },

}
