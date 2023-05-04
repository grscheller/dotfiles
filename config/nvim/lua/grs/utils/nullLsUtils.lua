--[[ Null-ls Infrastructure & Boilerplate ]]
local M = {}

local tooling = require 'grs.config.tooling'
local BuiltinTbls = tooling.BuiltinTbls
local m = tooling.MasonEnum

local func = require 'grs.lib.functional'
local iFlatten = func.iFlatten
local getFilteredKeys = func.getFilteredKeys

M.setup = function()
   local configure = function(_, v)
      return v == m.auto
   end

   local builtins = {}
   builtins['code_actions'] = iFlatten {
      getFilteredKeys(BuiltinTbls.code_actions.mason, configure),
      getFilteredKeys(BuiltinTbls.code_actions.system, configure),
   }
   builtins['completions'] = iFlatten {
      getFilteredKeys(BuiltinTbls.completions.mason, configure),
      getFilteredKeys(BuiltinTbls.completions.system, configure),
   }
   builtins['diagnostics'] = iFlatten {
      getFilteredKeys(BuiltinTbls.diagnostics.mason, configure),
      getFilteredKeys(BuiltinTbls.diagnostics.system, configure),
   }
   builtins['formatting'] = iFlatten {
      getFilteredKeys(BuiltinTbls.formatting.mason, configure),
      getFilteredKeys(BuiltinTbls.formatting.system, configure),
   }
   builtins['hover'] = iFlatten {
      getFilteredKeys(BuiltinTbls.hover.mason, configure),
      getFilteredKeys(BuiltinTbls.hover.system, configure),
   }

   local null_ls = require 'null-ls'

   local sources = {}
   for key, list in pairs(builtins) do
      for _, builtin in ipairs(list) do
         table.insert(sources, null_ls.builtins[key][builtin])
      end
   end

   null_ls.setup { sources = sources }
end

return M
