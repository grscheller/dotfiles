--[[ LSP Client Configuration Infrastructure ]]

local M = {}

local libTooling = require 'grs.devel.lib.libTooling'
local keymaps = require 'grs.core.keybindings'
local m = libTooling.configEnum
local ok, neodev, lspconf, cmp_nvim_lsp, capabilities

-- More ppowerful Lua editing for Neovim configurations 
ok, neodev = pcall(require, 'neodev')
if ok then neodev.setup {} else neodev = nil end

ok, lspconf = pcall(require, 'lspconfig')
if not ok then lspconf = nil end

ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
   capabilities = cmp_nvim_lsp.default_capabilities()
else
   capabilities = nil
end

M.setup = function(LspServerTbl)
   if not lspconf or not capabilities then
      return lspconf, capabilities
   end

   local lspServers = libTooling.serverList(LspServerTbl, m.auto)

   -- Add LSP servers we are not manually configuring
   for _, lspServer in ipairs(lspServers) do
      lspconf[lspServer].setup {
         capabilities = capabilities,
         on_attach = keymaps.lsp_kb
      }
   end

   return neodev, lspconf, capabilities
end

return M
