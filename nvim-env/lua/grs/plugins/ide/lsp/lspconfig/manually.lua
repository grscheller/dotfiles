--[[ Configure Neovim LSP client via nvim/nvim-lspconfig plugin

     For matching nvim-lspconfig names with mason names, see the mappings
     file located here at lua/mason-lspconfig/mappings/server.lua in the
     williamboman/mason-lspconfig.nvim GitHub repo.

--]]

local km = require 'grs.config.keymaps'

local lspconfig_configuration = function()
   require('mason').setup {
      ui = {
         icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
         },
      },
      PATH = 'append',
   }

   local capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
   )

   vim.lsp.config('*', {
      capabilities = vim.tbl_deep_extend('force',
         vim.lsp.protocol.make_client_capabilities(),
         require('cmp_nvim_lsp').default_capabilities()),
      on_attach = km.set_lsp_keymaps,
      root_markers = { '.git' },
   })

   -- Lua - lua-language-server
   vim.lsp.config(
      'lua_ls', {
         cmd = { 'lua-language-server' },
         filetypes = { 'lua' },
         root_markers = {
            '.luarc.json',
            '.luarc.jsonc',
            '.luacheckrc',
            '.stylua.toml',
            'stylua.toml',
            'selene.toml',
            'selene.yml',
         },
         on_init = function(client)
            if client.workspace_folders then
               local path = client.workspace_folders[1].name
               if
                  path ~= vim.fn.stdpath('config')
                  and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
               then
                  return
               end
            end
            client.config.settings.Lua = vim.tbl_deep_extend(
               'force',
               client.config.settings.Lua,
               {
                  runtime = {
                     version = 'LuaJIT',
                     -- configure lsp_ls to find Lua modules the same way as Neovim does
                     path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                     },
                  },
                  -- make lsp_ls server aware of Neovim runtime files
                  workspace = {
                     checkThirdParty = false,
                     library = {
                        vim.env.VIMRUNTIME
                     }
                  }
               }
            )
         end,
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
   )
   
   --[[ Deprecated: using lspconfig directly ]]

   local lspconf = require 'lspconfig'

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

   -- HTMX - htmx-lsp
   -- lspconf.htmx.setup {
   --    capabilities = capabilities,{
   --    on_attach = km.set_lsp_keymaps,
   -- }


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
      capabilities = capabilities,
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
      --[[ Deprecated: Using lspconfig directly like this ]]
      -- LSP Configuration manually.
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      cmd = 'Mason',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'williamboman/mason.nvim',
      },
      config = lspconfig_configuration,
   },
}
