--[[ Null-ls Infrastructure & Boilerplate ]]

local M = {}

local confMason = require 'grs.conf.mason'
local libFunc = require 'grs.lib.Functional'
local libVim = require 'grs.lib.Vim'

local BuiltinTbl = confMason.BuiltinToolTbls
local msg = libVim.msg_hit_return_to_continue
local m = confMason.MasonEnum

M.setup = function()
   local ok, null_ls = pcall(require, 'null-ls')
   if not ok then
      msg 'Problem null-ls, PUNTING!!!'
      return
   end

   local configure = function(_, v) return v == m.auto end

   local builtins = {}
   builtins['code_actions'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTbl.code_actions.mason, configure),
      libFunc.getFilteredKeys(BuiltinTbl.code_actions.system, configure),
   }
   builtins['completions'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTbl.completions.mason, configure),
      libFunc.getFilteredKeys(BuiltinTbl.completions.system, configure),
   }
   builtins['diagnostics'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTbl.diagnostics.mason, configure),
      libFunc.getFilteredKeys(BuiltinTbl.diagnostics.system, configure),
   }
   builtins['formatting'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTbl.formatting.mason, configure),
      libFunc.getFilteredKeys(BuiltinTbl.formatting.system, configure),
   }
   builtins['hover'] = libFunc.iFlatten {
      libFunc.getFilteredKeys(BuiltinTbl.hover.mason, configure),
      libFunc.getFilteredKeys(BuiltinTbl.hover.system, configure),
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
