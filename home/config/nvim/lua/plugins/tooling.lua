--[[ Manage installation of external tooling for LSP, DAP, formatting, and linting.

     Nothing installs automatically. mason-tool-installer is the single engine
     for install/update/clean across ALL categories; mason-lspconfig and
     mason-nvim-dap are not used anymore. The single source of truth for LSP
     configuration comes from files in the `~/.config/nvim/lsp/` directory.
     Native Neovim LSP configuration is managed via module `config.lsp`.
 
        <leader>M    - Launch Mason UI
        <leader>mi   - Install missing tools           (:MasonToolsInstall)
        <leader>mu   - Install + update all tools       (:MasonToolsUpdate)
        <leader>mc   - Clean tools not in ensure_installed  (:MasonToolsClean)
        <leader>mrl  - Remove ALL LSP servers           (by category)
        <leader>mrd  - Remove ALL DAP adapters          (by category)
        <leader>mrf  - Remove ALL linters & formatters  (by category)
]]

---@type LazySpec
return {
   -- Mason package manager for external tooling.
   ---@type LazyPluginSpec
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
         { '<leader>mU', '<cmd>MasonUpdate<cr>', desc = 'Mason update registry' },
      },
      build = ':MasonUpdate', -- refresh the registry index when lazy.nvim installs/updates the plugin
      opts = { PATH = 'skip' }, -- prepended in config.tooling, mason is lazy-loaded
   },

   -- Single source of truth for install/update/clean across every mason
   -- category. With the integrations enabled (default) the two dependencies
   -- after mason.nvim itself, ensure_installed opts key accepts lspconfig
   -- names (e.g. lua_ls), nvim-dap names, and plain Mason names alike.
   ---@type LazyPluginSpec
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
            desc = 'Update/Install all tools',
         },
         -- Category removal (destructive) lives behind the `mr` prefix.
         {
            '<leader>mrc',
            '<cmd>MasonToolsClean<cr>',
            desc = 'Cleanout all tools not in ensure_installed',
         },
         {
            '<leader>mrd',
            function()
               require('lib.mason').remove_dap()
            end,
            desc = 'Remove ALL DAP adapters',
         },
         {
            '<leader>mre',
            function()
               require('lib.mason').remove_everything()
            end,
            desc = 'Remove everything',
         },
         {
            '<leader>mrf',
            function()
               require('lib.mason').remove_linters_and_formatters()
            end,
            desc = 'Remove (non-LSP) linters & formatters',
         },
         {
            '<leader>mrl',
            function()
               require('lib.mason').remove_lsp()
            end,
            desc = 'Remove ALL LSP servers',
         },
      },

      ---@return table opts mason-tool-installer settings
      opts = function()
         local tools = require('config.tooling')
         local flatten = require('lib.functional').flatten_array
         return {
            ensure_installed = flatten {
               tools.lsp_servers_mason,
               tools.debug_adapters_mason,
               tools.linters_and_formatters_mason,
            },
            run_on_start = false, -- Nothing installs automatically.
         }
      end,
   },
}
