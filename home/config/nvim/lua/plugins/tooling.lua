--[[ Manage external tooling for LSP, DAP, formatting, and linting.

     Nothing installs automatically. Tooling is installed on demand via:
       :MasonToolsInstall  - linters & formatters from config.tooling
       :LspInstall         - LSP servers (no args: ensure_installed pass runs on load)
       :DapInstall         - DAP adapters (likewise)
       :Mason              - interactive UI                                        ]]

return {
   -- Mason package manager for external tooling.
   {
      [1] = 'mason-org/mason.nvim',
      cmd = {
         'Mason',
         'MasonInstall',
         'MasonUninstall',
         'MasonUninstallAll',
         'MasonUpdate',
         'MasonLog',
      },
      keys = {
         { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason UI' },
      },
      build = ':MasonUpdate', -- refresh registry when lazy.nvim installs/updates the plugin
      opts = {
         ui = {
            icons = {
               package_installed = '✓',
               package_pending = '➜',
               package_uninstalled = '✗',
            },
         },
         PATH = 'skip',
      },
   },

   -- Install LSP servers on demand.
   {
      [1] = 'mason-org/mason-lspconfig.nvim',
      dependencies = { 'mason-org/mason.nvim' },
      cmd = { 'LspInstall', 'LspUninstall' },
      keys = {
         { '<leader>cl', '<cmd>LspInstall<cr>', desc = 'Install LSP servers (ensure_installed)' },
      },
      opts = {
         ensure_installed = require('config.tooling').lsp_servers,
         automatic_enable = false,
      },
   },

   -- Install DAP adapters on demand.
   {
      [1] = 'jay-babu/mason-nvim-dap.nvim',
      dependencies = {
         'mason-org/mason.nvim',
         'mfussenegger/nvim-dap',
      },
      cmd = { 'DapInstall', 'DapUninstall' },
      keys = {
         { '<leader>cd', '<cmd>DapInstall<cr>', desc = 'Install DAP adapters (ensure_installed)' },
      },
      opts = {
         ensure_installed = require('config.tooling').debug_adapters,
         handlers = {},
      },
   },

   -- Install linters and formatters on demand
   {
      [1] = 'WhoIsSethDaniel/mason-tool-installer.nvim',
      dependencies = { 'mason-org/mason.nvim' },
      cmd = {
         'MasonToolsInstall',
         'MasonToolsInstallSync',
         'MasonToolsUpdate',
         'MasonToolsUpdateSync',
         'MasonToolsClean',
      },
      keys = {
         { '<leader>cT', '<cmd>MasonToolsInstall<cr>', desc = 'Install linters & formatters' },
         { '<leader>ct', '<cmd>MasonToolsUpdate<cr>',  desc = 'Install & update tools' },
      },
      opts = {
         ensure_installed = require('config.tooling').linters_and_formatters,
      },
   },
}
