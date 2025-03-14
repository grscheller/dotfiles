--[[ Configure Neovim LSP client thru nvim/nvim-lspconfig plugin ]]

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
            'rust_analyzer',  -- provided by rustup, configured thru another plugin
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

   local lspconf = require('lspconfig')

   -- Haskell language server

   lspconf.hls.setup {
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

   lspconf.ruff.setup {
      capabilities = capabilities,
      filetypes = { 'python' },
      on_attach = km.set_lsp_keymaps,
   }

   vim.diagnostic.config {
      virtual_text = false,  -- virtual text gets in the way
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
      -- LSP Configuration manually or thru mason-lspconfig.nvim.
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      cmd = 'Mason',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'williamboman/mason.nvim',
         'williamboman/mason-lspconfig.nvim',
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
      config = config_lspconfig,
   },

   {
      -- Integrates with rust-analyzer for an enhanced Rust LSP experience.
      -- Uses nvim-lspconfig directly itself to configure rest-analyzer,
      -- so DO NOT CONFIGURE rust-analyzer either manually or indirectly
      -- through mason-lspconfig. The required tooling needed by this plugin
      -- can be installed with rustup.
      --
      'mrcjkb/rustaceanvim',
      version = '^5', -- Recommended
      lazy = false,   -- This plugin is already lazy
   },

   {
      -- Plugin provides an LSP wrapper layer for tsserver.
      --
      -- The TypeScript standalone server (tsserver) is a node executable that
      -- encapsulates the TypeScript compiler providing language services. It
      -- exposes these services thru a JSON based protocol. Well suited for
      -- editors and IDE support, it is not itself an LSP.
      --
      -- Note that tsserver is NOT typescript-language-server (ts-ls) formally
      -- and confusingly also called tsserver.
      --
      -- Both tsserver and typescript need to be install manually via the
      -- npm command `"$ npm install -g typescript-language-server typescript"
      --
      -- I believe this plugin used lspconfig directly to configure itself
      -- as an LSP server leveraging tsserver, hence its inclusion here.
      --
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
