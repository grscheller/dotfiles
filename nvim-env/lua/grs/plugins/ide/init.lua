--[[ Configure LSP, DAP, plugins to make Neovim into an IDE ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.cmp',
   require 'grs.plugins.ide.formatters',
   require 'grs.plugins.ide.linters',
   require 'grs.plugins.ide.lsp',
   -- require 'grs.plugins.ide.rust',
   -- require 'grs.plugins.ide.scala',
}
