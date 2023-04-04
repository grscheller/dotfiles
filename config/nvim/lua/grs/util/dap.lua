--[[ DAP Debugging Infrastructure & Boilerplate ]]

local M = {}

M.setup = function()
   local dap = require 'dap'
   return dap, require 'dap.ui.widgets'
end

return M
