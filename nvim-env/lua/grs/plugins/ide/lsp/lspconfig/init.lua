--[[ LSP configurations leveraging neovim/nvim-lspconfig ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.lsp.lspconfig.mason_or_manually',
   require 'grs.plugins.ide.lsp.lspconfig.indirectly_by_other_plugin',
}
