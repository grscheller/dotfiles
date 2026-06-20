--[[ Configure plugins related to software development/refactoring ]]

local flatten = require('lib.functional').flattenArray

return flatten {
   require 'plugins.coding.format',
   require 'plugins.coding.gitsigns',
   require 'plugins.coding.lint',
   require 'plugins.coding.textedit',
}
