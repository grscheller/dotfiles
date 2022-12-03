--[[ Null-ls Core Infrastructure & Boilerplate ]]

local M = {}

local libVim = require 'grs.lib.libVim'
local msg = libVim.msg_hit_return_to_continue

M.setup = function(BuiltinTools)
   local ok, null_ls = pcall(require, 'null-ls')
   if not ok then
      msg 'Problem null-ls, PUNTING!!!'
      return
   end

   -- Temporary hack - need to create sources table from BuiltinTools
   null_ls.setup {
      sources = {
         null_ls.builtins.diagnostics['cppcheck'],
         null_ls.builtins.diagnostics['cpplint'],
         null_ls.builtins.diagnostics['markdownlint'],
         null_ls.builtins.diagnostics['mdl'],
         null_ls.builtins.formatting['stylua'],
      },
   }
end

return M
