--[[ DAP Core Debugging Infrastructure & Boilerplate ]]

local M = {}

local grsUtils = require('grs.utilities.grsUtils')
local msg = grsUtils.msg_hit_return_to_continue

M.setup = function(DapServerTbl)

   local ok, dap = pcall(require, 'dap')
   if not ok then
      msg('Problem DAP setup, PUNTING!!!')
      if not DapServerTbl then
         msg('never print this - hack to gag')
      end
      return
   end

   -- TODO: Configure generic DapServers?

   return dap, require('dap.ui.widgets')

end

return M
