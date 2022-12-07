--[[ Mason Infrastructure & Boilerplate ]]

--[[
     Mason package manager infrastructure used to install/upgrade
     3rd party tools like LSP & DAP servers, linters and formatters.
--]]

local M = {}

local libTooling = require 'grs.devel.lib.libTooling'
local libFunc = require 'grs.lib.libFunc'

local msg = libFunc.msg_hit_return_to_continue
local m = libTooling.configEnum

M.setup = function(LspServers, DapServers, BuiltinTools)
   local ok, mason, mason_tool_installer

   ok, mason = pcall(require, "mason")
   if not ok then
      msg('Problem setting up Mason: grs.devel.lib.mason')
      return
   end

   mason.setup {
      ui = {
         icons = {
            package_installed = ' ',
            package_pending = ' ',
            package_uninstalled = ' ﮊ'
         }
      }
   }

   ok, mason_tool_installer = pcall(require, 'mason-tool-installer')
   if not ok then
      msg 'Problem setting up Mason Tool Installer: grs.devel.lib.mason'
      return
   end

   -- Mason-tool-installer, automates Mason tool installation.

   local install = function(_, v) return v ~= m.ignore end

   local masonPackages = libFunc.iFlatten {
      libTooling.lspconfig2mason(LspServers, install),
      libTooling.dap2mason(DapServers, install),
      libTooling.nullLs2mason(BuiltinTools.code_actions, install),
      libTooling.nullLs2mason(BuiltinTools.completions, install),
      libTooling.nullLs2mason(BuiltinTools.diagnostics, install),
      libTooling.nullLs2mason(BuiltinTools.formatting, install),
      libTooling.nullLs2mason(BuiltinTools.hover, install),
   }

   mason_tool_installer.setup {
      ensure_installed = masonPackages,
      auto_update = true,
      run_on_start = true,
      start_delay = 3000 -- milliseconds
   }

   vim.api.nvim_create_autocmd('User', {
      pattern = 'MasonToolsUpdateCompleted',
      callback = function()
         vim.schedule(function()
            print('ﮊ  mason-tool-installer has finished!')
         end)
      end
   })

end

return M
