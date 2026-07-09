--[[ Manage external tooling for LSP, DAP, formatting, and linting.

     Nothing installs automatically. mason-tool-installer is the single engine
     for install / update / clean across ALL categories; mason-lspconfig and
     mason-nvim-dap are kept only for (a) translating lspconfig / nvim-dap names
     into Mason package names and (b) their runtime wiring. Only ONE plugin owns
     `ensure_installed`, which keeps `:MasonToolsClean` from removing tooling it
     doesn't know about.

        <leader>M    - Launch Mason UI
        <leader>mi   - Install missing tools           (:MasonToolsInstall)
        <leader>mu   - Install + update all tools       (:MasonToolsUpdate)
        <leader>mc   - Clean tools not in ensure_installed  (:MasonToolsClean)
        <leader>mrl  - Remove ALL LSP servers           (by category)
        <leader>mrd  - Remove ALL DAP adapters          (by category)
        <leader>mrf  - Remove ALL linters & formatters  (by category)
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
         'MasonUpdate', -- NOTE: updates the registry INDEX, not installed packages
         'MasonLog',
      },
      keys = {
         { '<leader>M', '<cmd>Mason<cr>', desc = 'Mason UI' },
      },
      build = ':MasonUpdate', -- refresh the registry index when lazy.nvim installs/updates the plugin
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

   -- Kept ONLY for lspconfig<->Mason name translation and `:LspInstall`.
   -- Installation/updating/cleaning of LSP servers is delegated to
   -- mason-tool-installer below. No `ensure_installed` lives here.
   {
      [1] = 'mason-org/mason-lspconfig.nvim',
      dependencies = { 'mason-org/mason.nvim' },
      cmd = { 'LspInstall', 'LspUninstall' },
      opts = {
         automatic_enable = false, -- LSP is configured natively
      },
   },

   -- Kept for nvim-dap<->Mason name translation, adapter/handler wiring, and
   -- `:DapInstall`. Installation is delegated to mason-tool-installer below.
   {
      [1] = 'jay-babu/mason-nvim-dap.nvim',
      dependencies = {
         'mason-org/mason.nvim',
         'mfussenegger/nvim-dap',
      },
      cmd = { 'DapInstall', 'DapUninstall' },
      opts = {
         handlers = {}, -- default handlers: wire installed debuggers into nvim-dap
      },
   },

   -- Single source of truth for install / update / clean across every category.
   -- With the integrations enabled (default) and the two plugins above present,
   -- ensure_installed accepts lspconfig names (e.g. lua_ls), nvim-dap names,
   -- and plain Mason names alike.
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
            '<leader>mi',
            '<cmd>MasonToolsInstall<cr>',
            desc = 'Install missing tools',
         },
         {
            '<leader>mu',
            '<cmd>MasonToolsUpdate<cr>',
            desc = 'Install + update all tools',
         },
         {
            '<leader>mc',
            '<cmd>MasonToolsClean<cr>',
            desc = 'Clean tools not in ensure_installed',
         },
         -- Category removal (destructive) lives behind the `mr` prefix.
         {
            '<leader>mrl',
            function()
               require('lib.mason').clean_lsp()
            end,
            desc = 'Remove ALL LSP servers',
         },
         {
            '<leader>mrd',
            function()
               require('lib.mason').clean_dap()
            end,
            desc = 'Remove ALL DAP adapters',
         },
         {
            '<leader>mrf',
            function()
               require('lib.mason').clean_linters_and_formatters()
            end,
            desc = 'Remove ALL linters & formatters',
         },
      },
      opts = function()
         local tools = require('config.tooling')
         local flatten = require('lib.functional').flatten_array

         return {
            ensure_installed = flatten {
               tools.lsp_servers,
               tools.debug_adapters,
               tools.linters_and_formatters,
            },
            run_on_start = false, -- Nothing installs automatically.
         }
      end,
   },
}
