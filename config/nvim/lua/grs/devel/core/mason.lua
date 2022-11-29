--[[ Mason Core Infrastructure & Boilerplate ]]

--[[ Mason package manager infrastructer used to install/upgrade
     3rd party tools like LSP & DAP servers, linters and formatters. ]]

local M = {}

local grsDevel = require 'grs.devel.core'
local grsUtils = require 'grs.utilities.grsUtils'

local msg = grsUtils.msg_hit_return_to_continue

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

   local pred = function(_, v) return v ~= grsDevel.conf.ignore end

   -- Mason-tool-installer, automates Mason tool installation.

   local masonPackages = grsDevel.concat {
      grsDevel.lspconfig2mason(LspServers, pred),
      grsDevel.dap2mason(DapServers, pred),
      grsDevel.nullLs2mason(BuiltinTools.code_actions, pred),
      grsDevel.nullLs2mason(BuiltinTools.completions, pred),
      grsDevel.nullLs2mason(BuiltinTools.diagnostics, pred),
      grsDevel.nullLs2mason(BuiltinTools.formatting, pred),
      grsDevel.nullLs2mason(BuiltinTools.hover, pred),
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
