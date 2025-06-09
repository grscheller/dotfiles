--[[ Configure Neovim LSP client via nvim/nvim-lspconfig plugin

     For matching nvim-lspconfig names with mason names, see the mappings
     file located here at lua/mason-lspconfig/mappings/server.lua in the
     williamboman/mason-lspconfig.nvim GitHub repo.

--]]

local km = require 'grs.config.keymaps_whichkey'

local lspconfig_configuration = function()

   --[[ Deprecated: using lspconfig directly ]]

   local lspconf = require 'lspconfig'

   local capabilities = vim.tbl_deep_extend('force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
   )

   -- Cascading Style Sheets - css-lsp
   lspconf.cssls.setup {
      capabilities = capabilities,
      on_attach = km.set_lsp_keymaps,
   }

   -- Go - gopls [[See https://cs.opensource.google/go/x/tools/+/refs/tags/gopls/v0.18.1:gopls/doc/vim.md#vimlsp]]
   lspconf.gopls.setup {
      capabilities = capabilities,
      on_attach = km.set_lsp_keymaps,
      settings = {
         gopls = {
            analyses = {
               unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
         },
      },
   }

   -- Haskell - haskell-language-server
   lspconf.hls.setup {
      capabilities = capabilities,
      filetypes = { 'haskell', 'lhaskell', 'cabal' },
      on_attach = function(_, bufnr)
         if km.set_lsp_keymaps(nil, bufnr) then
            km.set_hls_keymaps(bufnr)
         end
      end,
      settings = {
         hls = {},
      },
   }

   -- Markdown
   lspconf.marksman.setup {
      capabilities = capabilities,
      filetypes = { 'md' },
      on_attach = km.set_lsp_keymaps,
      setting = {},
   }

   -- TOML - taplo
   lspconf.taplo.setup {
      capabilities = capabilities,
      filetypes = { 'toml' },
      on_attach = km.set_lsp_keymaps,
   }
end

return {
   {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      config = lspconfig_configuration,
   },
}
