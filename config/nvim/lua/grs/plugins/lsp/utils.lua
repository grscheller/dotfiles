--[[ Null-ls Infrastructure & Boilerplate ]]

local km = require 'grs.config.keymaps'
local ct = require('grs.config.tooling')
local LspTbl = ct.LspTbl
local BuiltinTbls = ct.BuiltinTbls

local func = require 'grs.lib.functional'
local iFlatten = func.iFlatten
local getKeys = func.getKeys
local getFilteredKeys = func.getFilteredKeys
local mergeTables= func.mergeTables

local M = {}

--[[ Config lspconfig servers and opts to override ]]

-- table of functions returning LSP server configuration overrides
local LspconfigServerOpts = {
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
   local function p(_, v)
      return v
   end
   return iFlatten {
      getFilteredKeys(LspTbl.mason, p),
      getFilteredKeys(LspTbl.system, p),
   }
end

--[[ Get null-ls builtins and builtin overrides ]]

-- table of indexed tables NullLs builtin overrides
local NullLSBuiltinOpts = {
   yamllint = {
      extra_args = {
         '-d',
         '{extends: relaxed, rules: {key-ordering: "disable"}}',
      },
   }
}

-- Return an empty table if a builtin overrides not defined
local NullLSBuiltinOptsMT = {}
NullLSBuiltinOptsMT.__index = function()
   return {}
end

setmetatable(NullLSBuiltinOpts, NullLSBuiltinOptsMT)

M.getNullLsBuiltins = function(null_ls)
   local function p(_, v)
      return v
   end
   local builtins = {}
   for _, nullLsType in pairs(getKeys(BuiltinTbls)) do
      builtins[nullLsType] = mergeTables {
         getFilteredKeys(BuiltinTbls[nullLsType].mason, p),
         getFilteredKeys(BuiltinTbls[nullLsType].system, p),
      }
   end

   -- Create source table for NullLs setup function
   local nullLsSources = {}
   for nullLsType, nullLsBuiltins in pairs(builtins) do
      for _, builtin in pairs(nullLsBuiltins) do
         table.insert(
            nullLsSources,
            null_ls.builtins[nullLsType][builtin].with(
               NullLSBuiltinOpts[builtin]
            )
         )
      end
   end

   return nullLsSources
end

return M
