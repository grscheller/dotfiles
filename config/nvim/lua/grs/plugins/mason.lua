--[[ Mason Setup ]]

local confMason = require 'grs.config.mason'
local m = confMason.MasonEnum
local LspTbl = confMason.LspTbl
local DapTbl = confMason.DapTbl
local BuiltinTbls = confMason.BuiltinTbls

local utilMason = require 'grs.util.mason'

local iFlatten = require('grs.lib.functional').iFlatten

local install = function(_, v)
   return v ~= m.ignore
end

local masonPackages = iFlatten {
   utilMason.lspconfig2mason(LspTbl, install),
   utilMason.dap2mason(DapTbl, install),
   utilMason.nullLs2mason(BuiltinTbls.code_actions, install),
   utilMason.nullLs2mason(BuiltinTbls.completions, install),
   utilMason.nullLs2mason(BuiltinTbls.diagnostics, install),
   utilMason.nullLs2mason(BuiltinTbls.formatting, install),
   utilMason.nullLs2mason(BuiltinTbls.hover, install),
}

return {

   --  Mason package manager infrastructure used to install/upgrade
   --  3rd party tools like LSP & DAP servers and Null-ls builtins.
   {
      'williamboman/mason.nvim',
      cmd = 'Mason',
      keys = { { '<leader>mm', '<cmd>Mason<cr>', desc = 'Mason' } },
      opts = { ensure_installed = masonPackages },
   },

   -- Install & update Mason packages on neovim startup
   {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      event = 'VeryLazy',
      dependencies = {
         'williamboman/mason.nvim',
         'rcarriga/nvim-notify',
      },
      cmd = { 'MasonToolsInstaller', 'MasonToolsUpdate' },
      keys = {
         {
            '<leader>mi',
            '<cmd>MasonToolsInstaller<cr>',
            desc = 'Mason Tools Installer',
         },
         {
            '<leader>mu',
            '<cmd>MasonToolsUpdate<cr>',
            desc = 'Mason Tools Update',
         },
      },
      config = function()

         --[[ Give user some mason-tool-installer feedback ]]
         local grs_mason_group = vim.api.nvim_create_augroup('grs_mason', {})

         vim.api.nvim_create_autocmd('User', {
            pattern = 'MasonToolsStartingInstall',
            callback = function()
               vim.schedule(function()
                  vim.notify '  mason-tool-installer is starting!'
               end)
            end,
            group = grs_mason_group,
            desc = 'Give feedback when updating Mason tools',
         })

         vim.api.nvim_create_autocmd('User', {
            pattern = 'MasonToolsUpdateCompleted',
            callback = function()
               vim.schedule(function()
                  vim.notify '  mason-tool-installer has finished!'
               end)
            end,
            group = grs_mason_group,
            desc = 'Give feedback when Mason tools are finished updating',
         })

         --[[ Configure mason-tool-installer ]]
         require('mason-tool-installer').setup {
            ensure_installed = masonPackages,
            auto_update = false,
            run_on_start = true,
            start_delay = 3000, -- 3 second delay
            debounce_hours = 5, -- at least 5 hour between attemps
         }

      end,
   },
}
