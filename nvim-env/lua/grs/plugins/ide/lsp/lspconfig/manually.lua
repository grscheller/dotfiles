--[[ Configure Neovim LSP client via nvim/nvim-lspconfig plugin

     For matching nvim-lspconfig names with mason names, see the mappings
     file located here at lua/mason-lspconfig/mappings/server.lua in the
     williamboman/mason-lspconfig.nvim GitHub repo.

--]]

local km = require('grs.config.keymaps')

local lspconfig_configuration = function()
   require('mason').setup {
      ui = {
         icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
         }
      },
      PATH = 'append',
   }

   local capabilities = vim.tbl_deep_extend('force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities())

   --[[ Manual configurations of LSP servers not installed with mason ]]

   local lspconf = require('lspconfig')

   -- Bash & POSIX Shells - bash-language-server
   lspconf.bashls.setup {
      capabilities = capabilities,
      on_attach = km.set_lsp_keymaps,
   }

   -- Cascading Style Sheets - css-lsp
   lspconf.cssls.setup {
      capabilities = capabilities,
      on_attach = km.set_lsp_keymaps,
   }

   -- Haskell - haskell-language-server
   lspconf.hls.setup {
      capabilities = capabilities,
      filetypes = { 'haskell', 'lhaskell', 'cabal' },
      on_attach = function(_, bufnr)
         if km.set_lsp_keymaps(bufnr) then
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

   -- HTMX - htmx-lsp
-- lspconf.htmx.setup {
--    capabilities = capabilities,
--    on_attach = km.set_lsp_keymaps,
-- }

   -- Lua - lua-language-server
   lspconf.lua_ls.setup {
      capabilities = capabilities,
      filetypes = { 'lua' },
      on_attach = km.set_lsp_keymaps,
      settings = {
         Lua = {
            completion = {
               callSnippet = 'Replace',
            },
            diagnostics = {
               globals = { 'vim' },
               disable = { 'missing-fields' },
            },
            hint = { enable = true },
         },
      },
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

   -- Python Language Servers - installed into venv by pip
   lspconf.pylsp.setup {
      capabilities = capabilities,
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
      -- LSP Configuration manually or thru mason-lspconfig.nvim.
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      cmd = 'Mason',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'williamboman/mason.nvim',
         {
            "folke/lazydev.nvim",
            ft = 'lua', -- only load on lua files
            opts = {
               library = {
                  "lazy.nvim",
                  { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                  "LazyVim",
               },
            },
         },
      },
      config = lspconfig_configuration,
   },
}
