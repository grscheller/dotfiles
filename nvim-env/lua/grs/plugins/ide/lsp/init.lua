--[[ Neovim LSP Client configuration ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.lsp.lspconfig', -- uses neovim/nvim-lspconfig manually or indirectly
   require 'grs.plugins.ide.lsp.nvimlsp', -- directly configures the nvim LSP client
}
