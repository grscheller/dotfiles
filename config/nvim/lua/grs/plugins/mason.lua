--[[ Mason Setup ]]

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local configMason = require 'grs.config.mason'
local m = configMason.MasonEnum
local LspTbl = configMason.LspTbl
local DapTbl = configMason.DapTbl
local BuiltinTbls = configMason.BuiltinTbls

local masonCore = require 'grs.core.masonCore'

local iFlatten = require('grs.lib.functional').iFlatten

local install = function(_, v)
   return v ~= m.ignore
end

local masonPackages = iFlatten {
   masonCore.lspconfig2mason(LspTbl, install),
   masonCore.dap2mason(DapTbl, install),
   masonCore.nullLs2mason(BuiltinTbls.code_actions, install),
   masonCore.nullLs2mason(BuiltinTbls.completions, install),
   masonCore.nullLs2mason(BuiltinTbls.diagnostics, install),
   masonCore.nullLs2mason(BuiltinTbls.formatting, install),
   masonCore.nullLs2mason(BuiltinTbls.hover, install),
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
      dependencies = {
         'williamboman/mason.nvim',
         'rcarriga/nvim-notify',
      },
      cmd = {
         'MasonToolsInstall',
         'MasonToolsUpdate',
      },
      keys = {
         {
            '<leader>mi',
            '<cmd>MasonToolsInstall<cr>',
            desc = 'Mason Tools Installer',
         },
         {
            '<leader>mu',
            '<cmd>MasonToolsUpdate<cr>',
            desc = 'Mason Tools Update',
         },
      },
      init = function()
         autogrp('GrsMason', { clear = true })
      end,
      config = function()
         autocmd('User', {
            pattern = 'MasonToolsStartingInstall',
            callback = function()
               vim.schedule(function()
                  vim.notify '  mason-tool-installer is starting!'
               end)
            end,
            group = autogrp('GrsMason', { clear = false }),
            desc = 'Give feedback when updating Mason tools',
         })

         autocmd('User', {
            pattern = 'MasonToolsUpdateCompleted',
            callback = function()
               vim.schedule(function()
                  vim.notify '  mason-tool-installer has finished!'
               end)
            end,
            group = autogrp('GrsMason', { clear = false }),
            desc = 'Give feedback when Mason tools are finished updating',
         })

         --[[ Configure mason-tool-installer ]]
         require('mason-tool-installer').setup {
            ensure_installed = masonPackages,
            auto_update = false,
            run_on_start = true,
            start_delay = 3000, -- 3 second delay
            debounce_hours = 8, -- at least 8 hour between attemps
         }
      end,
   },
}