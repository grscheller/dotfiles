--[[ Configure plugins making Neovim a full IDE ]]

local flatten = require('lib.functional').flattenArray

return flatten {
   require 'plugins.ide.completions',
   require 'plugins.ide.dap',
}
