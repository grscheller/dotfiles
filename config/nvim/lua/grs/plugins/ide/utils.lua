--[[ Null-ls Infrastructure & Boilerplate ]]

local km = require 'grs.config.keymaps'
local ct = require('grs.config.tooling')
local LspTbl = ct.LspTbl
local BuiltinTbls = ct.BuiltinTbls

local func = require 'grs.lib.functional'
local iFlatten = func.iFlatten
local getKeys = func.getKeys
local mergeTables= func.mergeTables

local M = {}

--[[ Config lspconfig servers and opts to overide ]]

-- table of functions returning LSP server configuration overrides
local LspconfigServerOpts = {
   -- Lua Configuration
   lua_ls = function(capabilities)
      return {
         capabilities = capabilities,
         setting = {
            Lua = { completion = { callSnippet = 'Replace' } },
         },
         filetypes = { 'lua' },
         on_attach = function(_, bufnr)
            km.lsp(bufnr)
         end,
      }
   end,
   -- Haskell Configuration
   hls = function(capabilities)
      return {
         capabilities = capabilities,
         filetypes = { 'haskell', 'lhaskell', 'cabal' },
         on_attach = function(_, bufnr)
            km.lsp(bufnr)
            km.haskell(bufnr)
         end,
      }
   end,
}

-- If an LSP server configuration is not explicitly defined above,
-- return function generating default LSP server configuration.
local LspconfigServerOptsMT = {}
LspconfigServerOptsMT.__index = function()
   return function(capabilities)
      return {
         capabilities = capabilities,
         on_attach = function(_, bufnr)
            km.lsp(bufnr)
         end,
      }
   end
end

setmetatable(LspconfigServerOpts, LspconfigServerOptsMT)

M.getLspServerOpts = function()
   return LspconfigServerOpts
end

M.getLspServers = function()
   return iFlatten {
      getKeys(LspTbl.mason),
      getKeys(LspTbl.system),
   }
end

--[[ Get null-ls builtins and TODO: configure overides ]]

M.getNullLsSources= function(null_ls)
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
