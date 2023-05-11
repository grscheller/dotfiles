--[[ Configure lspconfig ]]

-- Following LazyVim setup except decoupling from Mason

local km = require 'grs.config.keymaps'
local LspServers = require('grs.plugins.ide.utils').getLspServers()

-- table of functions returning LSP server configurations
local LspconfigServerOpts = {
   -- Lua Configuration
   lua_ls = function(capabilities)
      return {
         capabilities = capabilities,
         filetypes = { 'lua' },
         on_attach = function(_, bufnr)
            km.lsp(bufnr)
         end,
         setting = {
            Lua = { completion = { callSnippet = 'Replace' } },
         },
      }
   end,
   -- Haskell Configuration
   hls = function(capabilities)
      return {
         capabilities = capabilities,
         filetypes = { 'haskell', 'lhaskell', 'cabal' },
         on_attach = function(_, bufnr)
            km.lsp(bufnr)
            km.haskell(bufnr)
         end,
      }
   end,
}

-- If a config is not explicitly defined, return a function
-- to create a default LSP server configuration.
local LspconfigServerOptsMT = {}
LspconfigServerOptsMT.__index = function()
   return function(capabilities)
      return {
         capabilities = capabilities,
         on_attach = function(_, bufnr)
            km.lsp(bufnr)
         end,
      }
   end
end

setmetatable(LspconfigServerOpts, LspconfigServerOptsMT)

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
      config = function()
         local lspconfig = require 'lspconfig'
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         for _, lspServer in ipairs(LspServers) do
            lspconfig[lspServer].setup(LspconfigServerOpts[lspServer](capabilities))
         end
      end,
   },

}
