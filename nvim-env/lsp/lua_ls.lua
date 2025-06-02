--[[ LSP Configuration - lua_ls ]]

local km = require 'grs.config.keymaps.late'

local capabilities = vim.tbl_deep_extend('force',
   vim.lsp.protocol.make_client_capabilities(),
   require('cmp_nvim_lsp').default_capabilities()
)

-- Lua - lua-language-server
return {
   cmd = { 'lua-language-server' },
   filetypes = { 'lua' },
   root_markers = {
      'stylua.toml',
      'selene.toml',
      '.git',
   },
--   capabilities = capabilities,
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
         runtime = {
            version = 'LuaJIT',
            -- configure lsp_ls to find Lua modules the same way as Neovim does
            path = {
               'lua/?.lua',
               'lua/?/init.lua',
            },
         },
         workspace = {
            checkThirdParty = false,
            library = {
               vim.env.VIMRUNTIME,
            },
         },
      }.
   },
   single_file_support = true,
   log_level = vim.lsp.protocol.MessageType.Warning,
}
