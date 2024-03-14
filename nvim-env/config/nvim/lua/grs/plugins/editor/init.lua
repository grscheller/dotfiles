--[[ Configure plugins to make Neovim a better text editor ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.editor.colorscheme',
   require 'grs.plugins.editor.noice',
   require 'grs.plugins.editor.telescope',
   require 'grs.plugins.editor.textedit',
   require 'grs.plugins.editor.whichkey',
}
