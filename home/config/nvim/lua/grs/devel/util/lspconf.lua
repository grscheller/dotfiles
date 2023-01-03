--[[ LSP Client Configuration Infrastructure ]]

local M = {}

local confMason = require 'grs.conf.mason'
local develMason = require 'grs.devel.util.mason'

local msg = require('grs.lib.Vim').msg_return_to_continue
local lsp_kb = require('grs.conf.keybindings').lsp_kb
local LspTbl = confMason.LspTbl
local m = confMason.MasonEnum

local ok, lspconf, cmp_nvim_lsp, capabilities

ok, lspconf = pcall(require, 'lspconfig')
if not ok then
   lspconf = nil
end

ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
   capabilities = cmp_nvim_lsp.default_capabilities()
else
   capabilities = nil
end

M.setup = function()
   if not lspconf or not capabilities then
      if not lspconf then
         msg 'Error: Setup LSP servers failed, PUNTING!!!'
      end
      if not capabilities then
         msg 'Error: Setup LSP completions failed, PUNTING!!!'
      end
      return lspconf, capabilities
   end

   -- Add LSP serves we are letting lspconfig automatically configure
   for _, lspServer in ipairs(develMason.serverList(LspTbl, m.auto)) do
      lspconf[lspServer].setup {
         capabilities = capabilities,
         on_attach = lsp_kb,
      }
   end

   return lspconf, capabilities
end

return M
