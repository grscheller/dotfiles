--[[ Configure plugins making Neovim a full IDE ]]

local flatten = require('grs.lib.functional').flattenArray

return flatten {
   require 'grs.plugins.ide.dap',
   require 'grs.plugins.ide.ide',
}
