--[[ Mason Setup - Infrastructure & Boilerplate ]]

--[[
     Mason package manager infrastructure used to install/upgrade
     3rd party tools like LSP & DAP servers, linters and formatters.
--]]

local M = {}

local confMason = require 'grs.conf.mason'
local m = confMason.MasonEnum
local LspTbl = confMason.LspTbl
local DapTbl = confMason.DapTbl
local BuiltinTbls = confMason.BuiltinTbls

local develMason = require 'grs.devel.util.mason'

local msg = require('grs.lib.Vim').msg_return_to_continue

local ok, mason, mason_tool_installer

ok, mason = pcall(require, 'mason')
if not ok then
   msg 'Problem in grs.devel.mason setting up Mason'
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
   msg 'Problem in grs.devel.mason setting up Mason Tool Installer'
   return
end

-- Mason-tool-installer, automates Mason tool installation.

local install = function(_, v)
   return v ~= m.ignore
end

local masonPackages = require('grs.lib.functional').iFlatten {
   develMason.lspconfig2mason(LspTbl, install),
   develMason.dap2mason(DapTbl, install),
   develMason.nullLs2mason(BuiltinTbls.code_actions, install),
   develMason.nullLs2mason(BuiltinTbls.completions, install),
   develMason.nullLs2mason(BuiltinTbls.diagnostics, install),
   develMason.nullLs2mason(BuiltinTbls.formatting, install),
   develMason.nullLs2mason(BuiltinTbls.hover, install),
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
      vim.schedule(function()
         print 'ﮊ  mason-tool-installer has finished!'
      end)
   end,
})

return M
