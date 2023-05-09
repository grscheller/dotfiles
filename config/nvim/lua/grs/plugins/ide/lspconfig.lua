--[[ Configure lspconfig ]]

local km = require 'grs.config.keymaps'
local lspUtils = require 'grs.utils.lspUtils'

return {
   -- Configure the LSP client with lspconfig
   {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         -- Neovim plugin to manage global & project-local settings
         {
            'folke/neoconf.nvim',
            cmd = 'Neoconf',
            config = true,
         },
         -- Setup for Neovim init.lua and plugin development with full
         -- signature help, docs and completion for the nvim lua API.
         {
            'folke/neodev.nvim',
            opts = {
               experimental = { pathStrict = true },
            },
         },
         -- standalone UI for nvim-lsp progress
         {
            'j-hui/fidget.nvim',
            config = true,
         },
         'jose-elias-alvarez/null-ls.nvim',
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

         --[[ Manually configure the following for now, until I figure out how
              to best handle customized opts tables passed to setup functions ]]

         local tooling = require 'grs.config.tooling'

         -- Lua Configuration
         if tooling.LspTbl.system.lua_ls == false then
            lspconf['lua_ls'].setup {
               capabilities = capabilities,
               filetypes = { 'lua' },
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
               settings = {
                  Lua = { completion = { callSnippet = 'Replace' } },
               },
            }
         end

         -- Haskell Configuration
         if tooling.LspTbl.system.hls == false then
            lspconf['hls'].setup {
               capabilities = capabilities,
               filetypes = { 'haskell', 'lhaskell', 'cabal' },
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
                  km.haskell(bufnr)
               end,
            }
         end

      end,
   },

}
