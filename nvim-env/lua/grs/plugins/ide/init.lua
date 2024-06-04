--[[ Configure LSP, DAP, plugins to make Neovim into an IDE ]]

-- Plugins used for Neovim LSP Client configuration:
--
--   williamboman/mason.nvim (package manager)
--     - installs LSP servers
--     - installs tooling (formatters & linters)
--   williamboman/mason-lspconfig.nvim
--     - uses lspconfig to configure Neovim LSP client for
--       - LSP servers installed by mason
--       - uses the lspconfig names, not the mason names
--   neovim/nvim-lspconfig
--     - tool to configure Neovim's LSP client
--     - maintained by the Neovim core developers
--     - used to manually configure LSP client for select servers
--       - whether or not if installed by mason
--     - used by other plugins to configure Neovim's LSP client
--   simrat39/rust-tools.nvim
--     - for rust development
--     - currently archived, will replace with mrcjkb/rustaceanvim
--     - directly uses lspconfig
--   scalameta/nvim-metals
--     - directly configures Neovim's LSP client without lspconfig
--

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.cmp',
   require 'grs.plugins.ide.lsp',
   require 'grs.plugins.ide.rust',
   require 'grs.plugins.ide.scala',
   -- require 'grs.plugins.ide.dap',
}
