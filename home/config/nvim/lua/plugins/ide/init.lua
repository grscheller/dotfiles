--[[ Configure plugins making Neovim a full IDE ]]

local flatten = require('lib.functional').flatten_array

return flatten {
   require 'plugins.ide.completions',
   require 'plugins.ide.dap',
}
