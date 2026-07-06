--[[ External tooling for LSP, DAP, formatting, and linting ]]

return {
   -- Mason tool installer
   {
      [1] = 'mason-org/mason.nvim',
      lazy = true,
   },

   -- Ensure LSP servers are installed
   {
      [1] = 'mason-org/mason-lspconfig.nvim',
      dependencies = { 'mason-org/mason.nvim' },
      event = 'VeryLazy',
      opts = {
         ensure_installed = require('config.tooling').lsp_servers,
         automatic_enable = false,
      },
   },

   -- Ensure DAP adapters are installed
   {
      [1] = 'jay-babu/mason-nvim-dap.nvim',
      dependencies = {
         'mason-org/mason.nvim',
         'mfussenegger/nvim-dap',
      },
      event = 'VeryLazy',
      opts = {
         ensure_installed = require('config.tooling').debug_adapters,
         handlers = {},
      },
   },

   -- Ensure linters and formatters are installed
   {
      [1] = 'WhoIsSethDaniel/mason-tool-installer.nvim',
      dependencies = { 'mason-org/mason.nvim' },
      event = 'VeryLazy',
      opts = {
         ensure_installed = require('config.tooling').linters_and_formatters,
         auto_update = true,
         run_on_start = true,
         debounce_hours = 0,
      },
   },
}
