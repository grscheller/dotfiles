--[[ LSP Configuration ]]

local km = require 'grs.config.keymaps'
local tooling = require 'grs.config.tooling'
local masonUtils = require 'grs.utils.masonUtils'

local LspTbl = tooling.LspTbl
local m = tooling.MasonEnum

return {
   -- let LSP servers know about nvim.cmp completion capabilities
   {
      'hrsh7th/cmp-nvim-lsp',
      dependencies = {
         'hrsh7th/nvim-cmp',
      },
      event = { 'LspAttach' },
   },

   -- standalone UI for nvim-lsp progress
   {
      'j-hui/fidget.nvim',
      config = function()
         require('fidget').setup()
      end,
   },

   -- nvim-cmp source for neovim Lua API
   {
      'hrsh7th/cmp-nvim-lua',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
      },
      ft = { 'lua' },
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
         for _, lspServer in ipairs(masonUtils.serverList(LspTbl, m.auto)) do
            lspconf[lspServer].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
            }
         end

         -- Initialize Null-ls builtins
         require('grs.utils.nullLsUtils').setup()

         -- Manual LSP, DAP, and Null-ls configurations as well as
         -- other development environment configurations.

         --[[ Lua Configuration - affected by neodev.nvim ]]
         if LspTbl.system.lua_ls == m.man or LspTbl.mason.lua_ls == m.man then
            lspconf['lua_ls'].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
               settings = {
                  Lua = { completion = { callSnippet = 'Replace' } },
               },
            }
         end

         --[[ Haskell Configuration ]]
         if LspTbl.system.hls == m.man or LspTbl.mason.hls == m.man then
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
