--[[ Null-ls Core Infrastructure & Boilerplate ]]

local M = {}

local grsUtils = require('grs.utilities.grsUtils')
local msg = grsUtils.msg_hit_return_to_continue

M.setup = function(NullLsBuiltinTbl)

   local ok, null_ls = pcall(require, 'null-ls')
   if not ok then
      msg('Problem null-ls, PUNTING!!!')
      return
   end

   -- Temporary hack - need to create sources table from NullLsBuiltinTools
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
