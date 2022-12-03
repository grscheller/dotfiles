--[[ LSP Client Configuration Infrastructure ]]

local M = {}

local ok, lspconf, cmp_nvim_lsp, capabilities

M.setup = function(LspServers)
   ok, lspconf = pcall(require, 'lspconfig')
   if not ok then lspconf = nil end

   ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
   if ok then
      capabilities = cmp_nvim_lsp.default_capabilities()
   else
      cmp_nvim_lsp = nil
   end

   -- TODO: Do lspconfig auto-config setup here

   return lspconf, capabilities
end

return M
