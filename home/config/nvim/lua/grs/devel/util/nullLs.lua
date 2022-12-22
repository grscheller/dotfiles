--[[ Null-ls Infrastructure & Boilerplate ]]

local M = {}

local confMason = require 'grs.conf.mason'
local func = require 'grs.lib.functional'
local Vim = require 'grs.lib.Vim'

local msg = Vim.msg_hit_return_to_continue
local iFlatten = func.iFlatten
local getFilteredKeys = func.getFilteredKeys
local BuiltinTbls = confMason.BuiltinToolTbls
local m = confMason.MasonEnum

M.setup = function()
   local ok, null_ls = pcall(require, 'null-ls')
   if not ok then
      msg 'Error: Problem null-ls, PUNTING!!!'
      return
   end

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
