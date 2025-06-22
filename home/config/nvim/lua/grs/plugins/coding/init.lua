--[[ Configure plugins related to software development/refactoring ]]

local flatten = require('grs.lib.functional').flattenArray

return flatten {
   require 'grs.plugins.coding.format',
   require 'grs.plugins.coding.gitsigns',
   require 'grs.plugins.coding.lint',
   require 'grs.plugins.coding.textedit',
}
