--[[ LSP Client Configuration Infrastructure ]]

local M = {}

local confMason = require 'grs.config.mason'
local utilMason = require 'grs.util.mason'
local lsp_km = require('grs.config.keymaps').lsp_km
local LspTbl = confMason.LspTbl
local m = confMason.MasonEnum

M.setup = function()
   local lspconf = require 'lspconfig'
   local capabilities = require('cmp_nvim_lsp').default_capabilities()

   -- Add LSP serves we are letting lspconfig automatically configure
   for _, lspServer in ipairs(utilMason.serverList(LspTbl, m.auto)) do
      lspconf[lspServer].setup {
         capabilities = capabilities,
         on_attach = lsp_km,
      }
   end

   return lspconf, capabilities
end

return M
