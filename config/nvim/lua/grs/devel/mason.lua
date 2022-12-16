--[[ Mason Setup - Infrastructure & Boilerplate ]]

--[[
     Mason package manager infrastructure used to install/upgrade
     3rd party tools like LSP & DAP servers, linters and formatters.
--]]

local M = {}

local confMason = require 'grs.conf.mason'
local utilMason = require 'grs.util.mason'
local libFunc = require 'grs.lib.Functional'

local msg = libFunc.msg_hit_return_to_continue
local m = confMason.MasonEnum
local LspTbl = confMason.LspSrvTbl
local DapTbl = confMason.DapSrvTbl
local BuiltinTbls = confMason.BuiltinToolTbls

local ok, mason, mason_tool_installer

ok, mason = pcall(require, "mason")
if not ok then
   msg('Problem setting up Mason: grs.devel.mason')
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
   msg 'Problem setting up Mason Tool Installer: grs.devel.mason'
   return
end

-- Mason-tool-installer, automates Mason tool installation.

local install = function(_, v) return v ~= m.ignore end

local masonPackages = libFunc.iFlatten {
   utilMason.lspconfig2mason(LspTbl, install),
   utilMason.dap2mason(DapTbl, install),
   utilMason.nullLs2mason(BuiltinTbls.code_actions, install),
   utilMason.nullLs2mason(BuiltinTbls.completions, install),
   utilMason.nullLs2mason(BuiltinTbls.diagnostics, install),
   utilMason.nullLs2mason(BuiltinTbls.formatting, install),
   utilMason.nullLs2mason(BuiltinTbls.hover, install),
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

return M
