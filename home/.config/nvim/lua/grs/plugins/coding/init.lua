--[[ Configure plugins related to software development/refactoring ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.coding.format',
   require 'grs.plugins.coding.gitsigns',
   require 'grs.plugins.coding.lint',
   require 'grs.plugins.coding.textedit',
}
