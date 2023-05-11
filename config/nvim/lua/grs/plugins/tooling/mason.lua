--[[ Tooling: Install 3rd party tools & Treesitter language modules ]]

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local message
local info = vim.log.levels.INFO

local masonPackages = require('grs.plugins.tooling.utils').masonPackages()

return {

   --  Mason package manager infrastructure used to install/upgrade
   --  3rd party tools like LSP & DAP servers and Null-ls builtins.
   {
      'williamboman/mason.nvim',
      cmd = { 'Mason', 'MasonUpdate' },
      keys = {{ '<leader>mm', '<cmd>Mason<cr>', desc = 'Mason' }},
      config = function()
         require('mason').setup {
            ui = {
               icons = {
                  package_installed = '✓',
                  package_pending = '➜',
                  package_uninstalled = '✗',
               },
            },
         }
      end,
      build = ':MasonUpdate'
   },

   -- Install & update Mason packages on neovim startup
   -- TODO: figure out what event best to use to start this
   {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      dependencies = {
         'williamboman/mason.nvim',
         'rcarriga/nvim-notify',
      },
      keys = {
         { '<leader>mi', '<cmd>MasonToolsInstall<cr>', desc = 'Mason Tools Installer' },
         { '<leader>mu', '<cmd>MasonToolsUpdate<cr>', desc = 'Mason Tools Update' },
      },
      config = function()
         local grsMasonGrp = autogrp('GrsMason', { clear = true })

         autocmd('User', {
            pattern = 'MasonToolsStartingInstall',
            callback = function()
               vim.schedule(function()
                  message = '● mason-tool-installer is starting!'
                  vim.notify(message, info)
               end)
            end,
            group = grsMasonGrp,
            desc = 'Give feedback when updating Mason tools',
         })

         autocmd('User', {
            pattern = 'MasonToolsUpdateCompleted',
            callback = function()
               vim.schedule(function()
                  message = '● mason-tool-installer has finished!'
                  vim.notify(message, info)
               end)
            end,
            group = grsMasonGrp,
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
