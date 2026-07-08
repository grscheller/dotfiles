--[[ Manage external tooling for LSP, DAP, formatting, and linting.

     Nothing installs automatically.

        <leader>M   - Launch Mason UI
        <leader>ml  - Install LSP servers
        <leader>ml  - Install DAP adapters
        <leader>mt  - Install linters and formatters
        <leader>mc  - Remove linters and formatters not in ensure_installed
]]

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
         { '<leader>M', '<cmd>Mason<cr>', desc = 'Mason UI' },
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
         {
            '<leader>ml',
            '<cmd>LspInstall<cr>',
            desc = 'Install LSP servers (ensure_installed)',
         },
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
         {
            '<leader>md',
            '<cmd>DapInstall<cr>',
            desc = 'Install DAP adapters (ensure_installed)',
         },
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
         {
            '<leader>mt',
            '<cmd>MasonToolsUpdate<cr>',
            desc = 'Install & update tools',
         },
         {
            '<leader>mc',
            '<cmd>MasonToolsClean<cr>',
            desc = 'Remove linters & formatters not in ensure_installed',
         },
      },
      opts = {
         ensure_installed = require('config.tooling').linters_and_formatters,
      },
   },
}
