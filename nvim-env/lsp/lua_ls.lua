--[[ LSP Configuration Lua - lua-language-server ]]

local km = require 'grs.config.keymaps_whichkey'

return {
   cmd = { 'lua-language-server' },
   filetypes = { 'lua' },
   root_markers = { 'stylua.toml', 'selene.toml', '.git' },
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
               '${3rd}/luv/library',
            },
         },
      },
   },
   on_attach = km.set_lsp_keymaps,
   single_file_support = true,
   log_level = vim.lsp.protocol.MessageType.Warning,
}
