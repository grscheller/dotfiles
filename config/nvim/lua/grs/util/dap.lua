--[[ DAP Debugging Infrastructure & Boilerplate ]]

local M = {}

local libVim = require 'grs.lib.Vim'
local confMason = require 'grs.conf.mason'

local LspTbl = confMason.LspSrvTbl
local msg = libVim.msg_hit_return_to_continue

M.setup = function()
   local ok, dap = pcall(require, 'dap')
   if not ok then
      msg 'Error: Problem DAP setup, PUNTING!!!'
      return
   end
   return dap, require 'dap.ui.widgets'
end

return M
