--[[ LSP Client Configuration Infrastructure ]]

local M = {}

local confMason = require 'grs.conf.mason'
local utilMason = require 'grs.util.mason'
local keymaps = require 'grs.conf.keybindings'


local LspTbl = confMason.LspSrvTbl
local m = confMason.MasonEnum
local ok, lspconf, cmp_nvim_lsp, capabilities

ok, lspconf = pcall(require, 'lspconfig')
if not ok then lspconf = nil end

ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
   capabilities = cmp_nvim_lsp.default_capabilities()
else
   capabilities = nil
end

M.setup = function()
   if not lspconf or not capabilities then
      return lspconf, capabilities
   end

   -- Add LSP serve we are letting lspconfig automatically configure
   for _, lspServer in ipairs(utilMason.serverList(LspTbl, m.auto)) do
      lspconf[lspServer].setup {
         capabilities = capabilities,
         on_attach = keymaps.lsp_kb
      }
   end

   return lspconf, capabilities
end

return M
