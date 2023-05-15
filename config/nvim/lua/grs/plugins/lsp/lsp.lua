--[[ Configure lspconfig ]]

-- Following LazyVim except decouple from mason

local ideUtils = require 'grs.plugins.lsp.utils'
local LspServers = ideUtils.getLspServers()
local LspServerOpts = ideUtils.getLspServerOpts()
local getNullLsBuiltins = ideUtils.getNullLsBuiltins

return {

   { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },

   { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } },

   { 'j-hui/fidget.nvim', config = true },

   {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         'folke/neoconf.nvim',
         'folke/neodev.nvim',
         'j-hui/fidget.nvim',
      },

      config = function()
         local lspconfig = require 'lspconfig'
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         -- needs to run before configuring any LSP servers via lspconfig
         require('neoconf').setup {
            experimental = { pathStrict = true },
         }

         -- config lsp client for each lsp server individually
         for _, lspServer in ipairs(LspServers) do
            lspconfig[lspServer].setup(LspServerOpts[lspServer](capabilities))
         end
      end,
   },

   {
      'jose-elias-alvarez/null-ls.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         'j-hui/fidget.nvim',
      },
      config = function()
         local null_ls = require 'null-ls'

         -- setup null-ls for all builtins at once
         null_ls.setup {
            sources = getNullLsBuiltins(null_ls),
         }
      end,
   },

}
