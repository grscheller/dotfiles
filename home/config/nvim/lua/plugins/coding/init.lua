--[[ Configure plugins related to software development/refactoring ]]

local flatten = require('lib.functional').flatten_array

return flatten {
   require 'plugins.coding.conform',
   require 'plugins.coding.gitsigns',
   require 'plugins.coding.nvim_lint',
   require 'plugins.coding.textedit',
}
