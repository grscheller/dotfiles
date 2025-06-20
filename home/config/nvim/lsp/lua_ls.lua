--[[ LSP Configuration Lua - lua-language-server ]]

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
               '${3rd}/luv/library',
            },
         },
      },
   },
}
