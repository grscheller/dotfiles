--[[ Configure Neovim LSP client thru the nvim/nvim-lspconfig plugin

     Either manually or using a "canned" mason-lspconfig configuration.

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

   --[[ Manual configurations of LSP servers not installed with mason ]]

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

   lspconf.ruff.setup {
      capabilities = capabilities,
      filetypes = { 'python' },
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
      config = lspconfig_configuration,
   },
}
