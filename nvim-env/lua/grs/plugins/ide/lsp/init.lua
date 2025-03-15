--[[ Neovim LSP Client configuration ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.lsp.lspconfig', -- using neovim/nvim-lspconfig
   require 'grs.plugins.ide.lsp.nvimlsp',   -- directly configuring the nvim LSP client
}
