--[[ Plugins which directly configure Neovim's LSP client ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.lsp.nvimlsp.rust',
   require 'grs.plugins.ide.lsp.nvimlsp.scala',
}
