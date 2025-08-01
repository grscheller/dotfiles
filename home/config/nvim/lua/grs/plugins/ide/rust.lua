--[[ Rust Configuration with rustaceanvim

     Integrates with rust-analyzer for an enhanced Rust LSP experience.
     Configures rest-analyzer independently of nvim-lspconfig
     so DO NOT CONFIGURE rust-analyzer either manually or indirectly
     through mason-lspconfig. The required tooling needed by this plugin
     can be installed with rustup.

--]]

return {
   {
      -- Configured with a global table in config/globals.lua
      'mrcjkb/rustaceanvim',
      version = '^5', -- Recommended
   },
}
