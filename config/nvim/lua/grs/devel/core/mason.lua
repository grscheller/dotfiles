--[[ Mason Core Infrastructure & Boilerplate ]]

--[[ Mason package manager infrastructer used to install/upgrade
     3rd party tools like LSP & DAP servers, linters and formatters. ]]

local M = {}

local coreTooling = require 'grs.devel.core.tooling'
local libFunc = require 'grs.lib.libFunc'

local msg = libFunc.msg_hit_return_to_continue

M.setup = function(LspServers, DapServers, BuiltinTools)
   local ok, mason, mason_tool_installer

   ok, mason = pcall(require, 'mason')
   if not ok then
      msg 'Problem setting up Mason: grs.devel.core.mason'
      return
   end

   mason.setup {
      ui = {
         icons = {
            package_installed = ' ',
            package_pending = ' ',
            package_uninstalled = ' ﮊ',
         },
      },
   }

   ok, mason_tool_installer = pcall(require, 'mason-tool-installer')
   if not ok then
      msg 'Problem setting up Mason Tool Installer: grs.devel.core.mason'
      return
   end

   local pred = function(_, v) return v ~= coreTooling.conf.ignore end

   -- Mason-tool-installer, automates Mason tool installation.

   local masonPackages = libFunc.iFlatten {
      coreTooling.lspconfig2mason(LspServers, pred),
      coreTooling.dap2mason(DapServers, pred),
      coreTooling.nullLs2mason(BuiltinTools.code_actions, pred),
      coreTooling.nullLs2mason(BuiltinTools.completions, pred),
      coreTooling.nullLs2mason(BuiltinTools.diagnostics, pred),
      coreTooling.nullLs2mason(BuiltinTools.formatting, pred),
      coreTooling.nullLs2mason(BuiltinTools.hover, pred),
   }

   mason_tool_installer.setup {
      ensure_installed = masonPackages,
      auto_update = true,
      run_on_start = true,
      start_delay = 3000, -- milliseconds
   }

   vim.api.nvim_create_autocmd('User', {
      pattern = 'MasonToolsUpdateCompleted',
      callback = function()
         vim.schedule(
            function() print 'ﮊ  mason-tool-installer has finished!' end
         )
      end,
   })
end

return M
