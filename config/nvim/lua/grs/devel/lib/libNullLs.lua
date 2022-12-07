--[[ Null-ls Infrastructure & Boilerplate ]]

local M = {}

local libTooling = require 'grs.devel.lib.libTooling'
local libFunc= require 'grs.lib.libFunc'
local libVim = require 'grs.lib.libVim'

local msg = libVim.msg_hit_return_to_continue
local m = libTooling.configEnum

M.setup = function(BuiltinTools)
   local ok, null_ls = pcall(require, 'null-ls')
   if not ok then
      msg 'Problem null-ls, PUNTING!!!'
      return
   end

   local configure = function(_, v) return v == m.auto end

   local builtins = {}
   builtins['code_actions'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTools.code_actions.mason, configure),
      libFunc.getFilteredKeys(BuiltinTools.code_actions.system, configure),
   }
   builtins['completions'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTools.completions.mason, configure),
      libFunc.getFilteredKeys(BuiltinTools.completions.system, configure),
   }
   builtins['diagnostics'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTools.diagnostics.mason, configure),
      libFunc.getFilteredKeys(BuiltinTools.diagnostics.system, configure),
   }
   builtins['formatting'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTools.formatting.mason, configure),
      libFunc.getFilteredKeys(BuiltinTools.formatting.system, configure),
   }
   builtins['hover'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTools.hover.mason, configure),
      libFunc.getFilteredKeys(BuiltinTools.hover.system, configure),
   }

   local sources = {}
   for key, list in pairs(builtins) do
      for _, builtin in ipairs(list) do
         table.insert(sources, null_ls.builtins[key][builtin])
      end
   end

   null_ls.setup {
      sources = sources,
   }

   return null_ls
end

return M
