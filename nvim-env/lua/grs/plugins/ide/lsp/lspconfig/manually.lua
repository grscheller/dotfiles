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

   -- HTML - html-lsp
   lspconf.html.setup {
      capabilities = capabilities,
      on_attach = km.set_lsp_keymaps,
   }

   -- Luau - luau-lsp [[ Verify! Just copied from lua_ls ]]
   lspconf.luau_lsp.setup {
      capabilities = capabilities,
      filetypes = { 'luau' },
      on_attach = km.set_lsp_keymaps,
      settings = {
         Lua = {
            completion = {
               callSnippet = 'Replace',
            },
            diagnostics = {
               disable = { 'missing-fields' },
            },
            hint = { enable = true },
         },
      },
   }

   -- Markdown
   lspconf.marksman.setup {
      capabilities = capabilities,
      filetypes = { 'md' },
      on_attach = km.set_lsp_keymaps,
      setting = {},
   }

   -- Python Language Servers - installed into venv by pip
   lspconf.pylsp.setup {
      capabilities = vim.tbl_deep_extend('force',
         capabilities,
         {
            -- to force same encoding as ruff
            offsetEncoding = { 'utf-16' },
            general = { positionEncodings = { 'utf-16' } },
         }),
      filetypes = { 'python' },
      on_attach = km.set_lsp_keymaps,
      flags = { debounce_text_changes = 200 },
      settings = {
         pylsp = {
            plugins = {
               -- type checker
               pylsp_mypy = {
                  enabled = true,
               },
               -- linting and formatting
               ruff = { enabled = false },
               -- refactoring
               rope = { enable = true },
               pylsp_inlay_hints = { enable = true },
            },
         },
      },
   }

   -- TOML - taplo
   lspconf.taplo.setup {
      capabilities = capabilities,
      filetypes = { 'toml' },
      on_attach = km.set_lsp_keymaps,
   }

   -- Python LSP for linting/formatting - ruff
   lspconf.ruff.setup {
      capabilities = capabilities,
      filetypes = { 'python' },
      on_attach = km.set_lsp_keymaps,
   }

   -- Zig - zls
   lspconf.zls.setup {
      capabilities = capabilities,
      filetypes = { 'zig' },
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
