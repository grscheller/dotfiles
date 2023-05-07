--[[ Null-ls Infrastructure & Boilerplate ]]

local ct = require('grs.config.tooling')
local LspTbl = ct.LspTbl
local BuiltinTbls = ct.BuiltinTbls

local func = require 'grs.lib.functional'
local iFlatten = func.iFlatten
local getKeys = func.getKeys

local message
local warn = vim.log.levels.WARN

local M = {}

M.getLspServers = function()
   return iFlatten {
      getKeys(LspTbl.mason),
      getKeys(LspTbl.system),
   }
end

M.getNullLsSources= function(null_ls)

   -- Combine Mason and Systems tables
   -- TODO: Don't hardcode names
   local builtins = {}
   builtins.code_actions = iFlatten {
      getKeys(BuiltinTbls.code_actions.mason),
      getKeys(BuiltinTbls.code_actions.system),
   }
   builtins.completion = iFlatten {
      getKeys(BuiltinTbls.completion.mason),
      getKeys(BuiltinTbls.completion.system),
   }
   builtins.diagnostics = iFlatten {
      getKeys(BuiltinTbls.diagnostics.mason),
      getKeys(BuiltinTbls.diagnostics.system),
   }
   builtins.formatting = iFlatten {
      getKeys(BuiltinTbls.formatting.mason),
      getKeys(BuiltinTbls.formatting.system),
   }
   builtins.hover = iFlatten {
      getKeys(BuiltinTbls.hover.mason),
      getKeys(BuiltinTbls.hover.system),
   }

   local nullLsSources = {}
   for nullLsType, nullLsBuiltins in pairs(builtins) do
      if null_ls.builtins[nullLsType] then
         for _, builtin in pairs(nullLsBuiltins) do
            if null_ls.builtins[nullLsType][builtin] then
               table.insert(
                  nullLsSources,
                  null_ls.builtins[nullLsType][builtin]
               )
            else
               message = string.format('No such NullLs builtin: %s', builtin)
               vim.notify(message, warn)
            end
         end
      else
         message = string.format('No such NullLs builtin-type: %s', nullLsType)
         vim.notify(message, warn)
      end
   end

   return nullLsSources

end

return M
