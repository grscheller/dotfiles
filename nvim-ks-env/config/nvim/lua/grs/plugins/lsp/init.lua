--[[ Configure LSP, DAP, plugins to make Neovim into an IDE ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.lsp.cmp',
   require 'grs.plugins.lsp.lsp',
   --   require 'grs.plugins.lsp.rust',
   --   require 'grs.plugins.lsp.scala',
}
