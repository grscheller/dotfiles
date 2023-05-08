--[[ Null-ls Infrastructure & Boilerplate ]]

local ct = require('grs.config.tooling')
local LspTbl = ct.LspTbl
local BuiltinTbls = ct.BuiltinTbls

local func = require 'grs.lib.functional'
local iFlatten = func.iFlatten
local getKeys = func.getKeys
local mergeTables= func.mergeTables

local M = {}

M.getLspServers = function()
   return iFlatten {
      getKeys(LspTbl.mason),
      getKeys(LspTbl.system),
   }
end

M.getNullLsSources= function(null_ls)

   -- Combine Mason and Systems tables
   local builtins = {}
   for _, nullLsType in pairs(getKeys(BuiltinTbls)) do
      builtins[nullLsType] = mergeTables {
         getKeys(BuiltinTbls[nullLsType].mason),
         getKeys(BuiltinTbls[nullLsType].system),
      }
   end

   -- Create source table for NullLs setup function
   local nullLsSources = {}
   for nullLsType, nullLsBuiltins in pairs(builtins) do
      for _, builtin in pairs(nullLsBuiltins) do
         table.insert(nullLsSources, null_ls.builtins[nullLsType][builtin])
      end
   end

   return nullLsSources

end

return M
