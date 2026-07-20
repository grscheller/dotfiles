--[[ Manage installation of external tooling for LSP, DAP, formatting, and linting.

     Nothing installs automatically. mason-tool-installer is the single engine
     for install/update/clean across ALL categories, mason-lspconfig and
     mason-nvim-dap are not used anymore. The single source of truth for LSP
     configuration comes from files in the `~/.config/nvim/lsp/` directory.
     Native Neovim LSP configuration is managed via module `config.lsp`.
 
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
         { '<leader>mg', '<cmd>Mason<cr>', desc = 'Mason gui' },
         {
            '<leader>mU',
            '<cmd>MasonUpdate<cr>',
            desc = 'Mason update registry (not tools)',
         },
      },
      build = ':MasonUpdate', -- refresh the registry index when lazy.nvim installs/updates the plugin
      opts = { PATH = 'skip' }, -- prepended in config.tooling, mason is lazy-loaded
   },

   -- Single source of truth for install/update/clean across every mason category.
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
            desc = 'Masontools install missing',
         },
         {
            '<leader>mu',
            '<cmd>MasonToolsUpdate<cr>',
            desc = 'Masontools update/install',
         },
         -- Category removal (destructive) lives behind the `mr` prefix.
         {
            '<leader>mrc',
            '<cmd>MasonToolsClean<cr>',
            desc = 'Masontools clean (not ensure_installed)',
         },
         {
            '<leader>mrd',
            function()
               require('lib.mason').remove_dap()
            end,
            desc = 'Masontools remove DAP adapters',
         },
         {
            '<leader>mre',
            function()
               require('lib.mason').remove_everything()
            end,
            desc = 'Masontoos remove everything',
         },
         {
            '<leader>mrf',
            function()
               require('lib.mason').remove_linters_and_formatters()
            end,
            desc = 'Masontools remove (non-LSP) linters & formatters',
         },
         {
            '<leader>mrl',
            function()
               require('lib.mason').remove_lsp()
            end,
            desc = 'Masontools remove LSP servers',
         },
      },

      ---@return table opts mason-tool-installer settings
      opts = function()
         local tools = require 'config.tooling'
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
