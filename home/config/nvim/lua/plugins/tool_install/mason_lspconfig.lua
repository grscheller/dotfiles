--[[ Ensure all LSP servers are installed - actual configs in ~/.config/lsp/ ]]

return {
   'mason-org/mason-lspconfig.nvim',
   dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
   },
   opts = {
      ensure_installed = require('config.tools').mason_lsp_servers,
      automatic_enable = false,
   },
}
