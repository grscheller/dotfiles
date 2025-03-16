--[[ LSP configurations leveraging neovim/nvim-lspconfig ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.lsp.lspconfig.indirectly',
   require 'grs.plugins.ide.lsp.lspconfig.manually',
}
