--[[ Directly configures Neovim's LSP client without lspconfig ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.lsp.nvimlsp.rust',
   require 'grs.plugins.ide.lsp.nvimlsp.scala',
}
