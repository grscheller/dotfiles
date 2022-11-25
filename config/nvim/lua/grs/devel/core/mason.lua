--[[ Mason Core Infrastructure & Boilerplate ]]

local M = {}

local grsDevel = require('grs.devel.core')
local grsUtils = require('grs.utilities.grsUtils')

local msg = grsUtils.msg_hit_return_to_continue

M.setup = function(lspServerTbl, dapServerTbl, nullLsBuitinTbl)

   --[[ Mason package manager infrastructer used to install/upgrade
        3rd party tools like LSP & DAP servers, linters and formatters. ]]
   local ok, mason, mason_tool_installer
   ok, mason = pcall(require, "mason")
   if not ok then
      msg('Problem setting up Mason: grs.devel.core.mason')
      return
   end

   ok, mason_tool_installer = pcall(require, "mason-tool-installer")
   if not ok then
      msg('Problem setting up Mason Tool Installer: grs.devel.core.mason')
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

   -- Mason-tool-installer used to automate Mason tool installation.
   mason_tool_installer.setup {
      ensure_installed = grsDevel.lsp2mason(lspServerTbl),
      auto_update = false,
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
