--[[ LSP Client Configuration Infrastructure ]]

local M = {}

M.setup = function(LspServers)
   local ok, lspconf = pcall(require, 'lspconfig')
   if ok then
      return lspconf
   else
      return
   end

   -- TODO: Do lspconfig auto-config setup here
end

return M
