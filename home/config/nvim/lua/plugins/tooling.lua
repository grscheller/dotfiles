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
      opts = { PATH = 'skip' }, -- prepended in config.lsp, mason is lazy-loaded
   },

   -- Single source of truth for install/update/clean across every mason
   -- category. With the integrations enabled (default) the two dependencies
   -- after mason.nvim itself, ensure_installed opts key accepts lspconfig
   -- names (e.g. lua_ls), nvim-dap names, and plain Mason names alike.
   {
      [1] = 'WhoIsSethDaniel/mason-tool-installer.nvim',
      dependencies = {
         {
            [1] = 'mason-org/mason-lspconfig.nvim',
            dependencies = { 'mason-org/mason.nvim' },  -- needs to be installed first
            opts = {
               automatic_enable = false, -- LSP is configured natively
            },
         },
         {
            [1] = 'jay-babu/mason-nvim-dap.nvim',
            dependencies = { 'mason-org/mason.nvim' },  -- needs to be installed first
            opts = {},
         },
      },
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
               require('lib.mason').remove_lsp()
            end,
            desc = 'Remove ALL LSP servers',
         },
         {
            '<leader>mrd',
            function()
               require('lib.mason').remove_dap()
            end,
            desc = 'Remove ALL DAP adapters',
         },
         {
            '<leader>mrf',
            function()
               require('lib.mason').remove_linters_and_formatters()
            end,
            desc = 'Remove ALL linters & formatters',
         },
         {
            '<leader>mre',
            function()
               require('lib.mason').remove_everything()
            end,
            desc = 'Remove everything',
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
