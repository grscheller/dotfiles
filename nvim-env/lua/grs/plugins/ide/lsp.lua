--[[ Config Neovim LSP client leveraging the Mason toolchain ]]

local km = require('grs.config.keymaps')

local config_lspconfig = function ()
   require('mason').setup {
      ui = {
         icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
         }
      }
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
         'rust_analyzer',
         'taplo',
      },
      automatic_installation = {
         exclude = {
            'hls',
            'pylsp',
         }
      },
      handlers = {
         -- default handler
         function (server_name) -- default handler (optional)
            require('lspconfig')[server_name].setup {
               capabilities = capabilities,
               on_attach = km.set_lsp_keymaps,
            }
         end,

         -- Lua language server
         ['lua_ls'] = function ()
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

   local lsp = require('lspconfig')

   -- Configure Python Language Server - installed by pip, not mason
   lsp.pylsp.setup {
      capabilities = capabilities,
      filetypes = { 'python' },
      on_attach = km.set_lsp_keymaps,
      flags = { debounce_text_changes = 200 },
      settings = {
         pylsp = {
            plugins = {
               -- formatter options
               black = { enabled = false },
               autopep8 = { enabled = false },
               yapf = { enabled = false },
               -- linter options
               pylint = { enabled = false },
               ruff = { enabled = true },
               pyflakes = { enabled = false },
               pycodestyle = { enabled = false },
               -- type checker
               pylsp_mypy = {
                  enabled = true,
               },
               -- refactoring
               rope = { enable = true },
               pylsp_inlay_hints = { enable = true },
            },
         },
      },
   }

   -- Configure Haskell Language Server
   lsp.hls.setup {
      capabilities = capabilities,
      filetypes = {
         'haskell',
         'lhaskell',
         'cabal',
      },
      on_attach = function (client, bufnr)
         if km.set_lsp_keymaps(client, bufnr) then
            km.set_hls_keymaps(bufnr)
         end
      end,
      settings = {
         hls = {},
      },
   }

   vim.diagnostic.config {
      virtual_text = false,
      signs = true,
      underline = true,
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
      -- LSP Configuration
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

}
