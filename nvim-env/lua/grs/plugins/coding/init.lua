--[[ Configure plugins related to software development/refactoring ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.coding.gitsigns',
   require 'grs.plugins.coding.harpoon',
   require 'grs.plugins.coding.indent_line',
   require 'grs.plugins.coding.refactoring',
   require 'grs.plugins.coding.textedit',
}
