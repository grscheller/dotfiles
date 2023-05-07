--[[ LSP Configuration ]]

local km = require 'grs.config.keymaps'
local lspUtils = require 'grs.utils.lspUtils'
local getNullLsSources = require('grs.utils.lspUtils').getNullLsSources

return {
   -- Configure LSP client and Null-ls builtins
   {
      'neovim/nvim-lspconfig',
      version = false,
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         'folke/neoconf.nvim',                -- see below
         'folke/neodev.nvim',                 -- see below
         'j-hui/fidget.nvim',                 -- see below
         'hrsh7th/nvim-cmp',
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

   -- Configure Null-ls builtins
   {
      'jose-elias-alvarez/null-ls.nvim',
      version = false,
      config = function()
         local null_ls = require 'null-ls'
         null_ls.setup { sources = getNullLsSources(null_ls) }
      end,
   },

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

}
