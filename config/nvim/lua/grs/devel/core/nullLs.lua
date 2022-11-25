--[[ Null-ls Core Infrastructure & Boilerplate ]]

local M = {}

local grsUtils = require('grs.utilities.grsUtils')
local msg = grsUtils.msg_hit_return_to_continue

M.setup = function(NullLsBuiltins)

   local ok, null_ls = pcall(require, 'null-ls')
   if not ok then
      msg('Problem null-ls, PUNTING!!!')
      if not NullLsBuiltins then
         msg('never print this - hack to gag')
      end
      return
   end

   -- Temporary hack - need to create sources table from NullLsBuiltins
   null_ls.setup {
      sources = {
         null_ls.builtins.diagnostics['cppcheck'],
         null_ls.builtins.diagnostics['cpplint'],
         null_ls.builtins.diagnostics['markdownlint'],
         null_ls.builtins.diagnostics['mdl'],
         null_ls.builtins.diagnostics['selene'],
         null_ls.builtins.formatting['stylua']
      }
   }
end

return M
