--[[ Config Neovim LSP client leveraging the Mason toolchain ]]
local km = require('grs.config.keymaps')

local config_lspconfig = function()
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

   require('mason-lspconfig').setup {
      ensure_installed = {
         'bashls',
         'cssls',
         'html',
         'lua_ls',
         'taplo',
         'zls',
      },
      automatic_installation = {
         exclude = {
            'hls',     -- too closely ABI coupled to ghc
            'pylsp',   -- don't want Mason messing with my Python venvs
            'ruff',    -- don't want Mason messing with my Python venvs
            'rust_analyzer',  -- provide by rust toolchain
         },
      },
      handlers = {
         -- default handler
         function(server_name) -- default handler
            require('lspconfig')[server_name].setup {
               capabilities = capabilities,
               on_attach = km.set_lsp_keymaps,
            }
         end,

         -- Lua language server
         ['lua_ls'] = function()
            require('lspconfig').lua_ls.setup {
               capabilities = capabilities,
               filetypes = { 'lua', 'luau' },
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
         end,
      },
   }

   --[nvim-lspconfig configuration of plugins not installed with mason]

   local lsp = require('lspconfig')

   -- Haskell language server

   lsp.hls.setup {
      capabilities = capabilities,
      filetypes = {
         'haskell',
         'lhaskell',
         'cabal',
      },
      on_attach = function (_, bufnr)
         if km.set_lsp_keymaps(bufnr) then
            km.set_hls_keymaps(bufnr)
         end
      end,
      settings = {
         hls = {},
      },
   }

   -- Configure Python Language Servers - installed by pip, not mason

   lsp.pylsp.setup {
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

   lsp.ruff.setup {
      capabilities = capabilities,
      filetypes = { 'python' },
      on_attach = km.set_lsp_keymaps,
   }

   -- virtual text gets in the way

   vim.diagnostic.config {
      virtual_text = false,
      signs = true,
      underline = true,
      severity_sort = true,
   }
end

return {

   {
      -- Give user feedback on LSP activity
      'j-hui/fidget.nvim',
      event = 'LspAttach',
      opts = {},
   },

   {
      -- LSP Configuration manually and with nvim-lspconfig
      -- Auto install selected tooling with mason.
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      cmd = 'Mason',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'williamboman/mason.nvim',
         'williamboman/mason-lspconfig.nvim',
         {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
               library = {
                  "lazy.nvim",
                  { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                  "LazyVim",
               },
            },
         },
      },
      config = config_lspconfig,
   },

   {
      -- integrates with rust-analyzer for an enhanced Rust LSP experience
      'mrcjkb/rustaceanvim',
      version = '^5', -- Recommended
      lazy = false,   -- This plugin is already lazy
   },

   {
      -- Plugin provides an LSP wrapper layer for tsserver.
      -- Note: tsserver is NOT typescript-language-server (ts-ls) formally also called tsserver
      -- Note: tsserver, and typescript, must be install manually via npm
      --       $ npm install -g typescript-language-server typescript
      'pmizio/typescript-tools.nvim',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'neovim/nvim-lspconfig',
      },
      ft = {
         'javascript',
         'javascriptreact',
         'javascript.jsx',
         'typescript',
         'typescriptreact',
         'typescript.tsx',
      },
      opts = {},
   }

}
