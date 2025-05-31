--[[ LSP Configuration ]]

local km = require 'grs.config.keymaps.late'

require('mason').setup {
   ui = {
      icons = {
         package_installed = '✓',
         package_pending = '➜',
         package_uninstalled = '✗',
      },
   },
   PATH = 'append',
}

vim.lsp.config('*', {
   capabilities = vim.tbl_deep_extend('force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()),
   on_attach = km.set_lsp_keymaps,
   root_markers = { '.git' },
})

-- Lua - lua-language-server
vim.lsp.config('lua_ls', {
   cmd = { 'lua-language-server' },
   filetypes = { 'lua' },
   root_markers = {
      '.luarc.json',
      '.luarc.jsonc',
      '.luacheckrc',
      '.stylua.toml',
      'stylua.toml',
      'selene.toml',
      'selene.yml',
   },
   on_init = function(client)
      if client.workspace_folders then
         local path = client.workspace_folders[1].name
         if
            path ~= vim.fn.stdpath('config')
            and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
         then
            return
         end
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force',
         client.config.settings.Lua,
         {
            runtime = {
               version = 'LuaJIT',
               -- configure lsp_ls to find Lua modules the same way as Neovim does
               path = {
                  'lua/?.lua',
                  'lua/?/init.lua',
               },
            },
            -- make lsp_ls server aware of Neovim runtime files
            workspace = {
               checkThirdParty = false,
               library = {
                  vim.env.VIMRUNTIME
               }
            }
         }
      )
   end,
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
      },
   },
})
