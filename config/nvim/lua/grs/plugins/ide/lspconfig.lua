--[[ Configure lspconfig ]]

-- Do like LazyVim but decouple mason and lspconfig

local km = require 'grs.config.keymaps'
local lspUtils = require 'grs.utils.lspUtils'

return {

   -- Configure the LSP client with lspconfig
   {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         -- Manage global & project-local settings
         {
            'folke/neoconf.nvim',
            cmd = 'Neoconf',
            config = true,
         },
         -- Neovim config & plugin development (nvim lua API)
         {
            'folke/neodev.nvim',
            opts = {
               experimental = { pathStrict = true },
            },
         },
         -- Give nvim-lsp progress feedback (standalone UI)
         {
            'j-hui/fidget.nvim',
            config = true,
         },
      },
      config = function()
         local lspconf = require 'lspconfig'
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         for _, lspServer in ipairs(lspUtils.getLspServers()) do
            lspconf[lspServer].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
            }
         end

         -- Lua Configuration
         lspconf.lua_ls.setup {
            capabilities = capabilities,
            filetypes = { 'lua' },
            on_attach = function(_, bufnr)
               km.lsp(bufnr)
            end,
            settings = {
               Lua = { completion = { callSnippet = 'Replace' } },
            },
         }

         -- Haskell Configuration
         lspconf.hls.setup {
            capabilities = capabilities,
            filetypes = { 'haskell', 'lhaskell', 'cabal' },
            on_attach = function(_, bufnr)
               km.lsp(bufnr)
               km.haskell(bufnr)
            end,
         }

      end,
   },

}
