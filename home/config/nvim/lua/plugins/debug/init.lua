--[[ Plugins relating to debugging ]]

local flatten = require('lib.functional').flatten_array

return flatten {
   require 'plugins.debug.dap',
   require 'plugins.debug.adapters',
}
