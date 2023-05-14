--[[ Configure lspconfig ]]

-- Following LazyVim setup except decoupling from Mason

local ideUtils = require 'grs.plugins.ide.utils'
local LspServers = ideUtils.getLspServers()
local LspServerOpts = ideUtils.getLspServerOpts()

return {

   -- Configure the LSP client with lspconfig
   {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
         { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } },
         { 'j-hui/fidget.nvim', config = true },
      },
      -- config = function()
      config = function()
         local lspconfig = require 'lspconfig'
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         for _, lspServer in ipairs(LspServers) do
            lspconfig[lspServer].setup(LspServerOpts[lspServer](capabilities))
         end
      end,
   },

}
