--[[ Configure necessary plugins to make Neovim an IDE ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.cmp',
   require 'grs.plugins.ide.lspconfig',
   require 'grs.plugins.ide.nullLS',
   require 'grs.plugins.ide.rust',
   require 'grs.plugins.ide.scala',
}
