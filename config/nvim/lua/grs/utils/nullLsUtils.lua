--[[ Null-ls Infrastructure & Boilerplate ]]
local M = {}

local tooling = require 'grs.config.tooling'
local BuiltinTbls = tooling.BuiltinTbls

local func = require 'grs.lib.functional'
local iFlatten = func.iFlatten
local getFilteredKeys = func.getFilteredKeys

M.getNullLsBuiltins= function()

   local configure = function(_, v)
      return v
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

   return builtins

end

return M
