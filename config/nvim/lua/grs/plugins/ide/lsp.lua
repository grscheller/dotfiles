--[[ LSP Configuration ]]

local km = require 'grs.config.keymaps'
local tooling = require 'grs.config.tooling'
local masonUtils = require 'grs.utils.masonUtils'
local nullLsUtils= require('grs.utils.nullLsUtils')

local lspServers = masonUtils.serverList(tooling.LspTbl, true)  -- TODO: redo like next line
local nullLsBuiltins = nullLsUtils.getNullLsBuiltins()

return {
   -- standalone UI for nvim-lsp progress
   {
      'j-hui/fidget.nvim',
      config = function()
         require('fidget').setup()
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

   -- auto/manual configure lsp servers and null-ls builtins
   {
      'neovim/nvim-lspconfig',
      version = false,
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         'folke/neoconf.nvim',
         'folke/neodev.nvim',
         'j-hui/fidget.nvim',
         'hrsh7th/nvim-cmp',
         'jose-elias-alvarez/null-ls.nvim',
         'williamboman/mason.nvim',
      },
      config = function()  -- Initialize LSP servers & Null-ls builtins
         local lspconf = require 'lspconfig'
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         -- Add LSP serves we are letting lspconfig automatically configure
         for _, lspServer in ipairs(lspServers) do
            lspconf[lspServer].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
            }
         end

         -- Setup Null-ls builtins
         local null_ls = require 'null-ls'

         local nullLsSources = {}
         for key, list in pairs(nullLsBuiltins) do
            for _, builtin in ipairs(list) do
               table.insert(nullLsSources, null_ls.builtins[key][builtin])
            end
         end

         null_ls.setup { sources = nullLsSources }

         --[[ "Manually" configure these for now, until I figure out how best to
               handle these opts tables being passed to setup functions ]]

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
