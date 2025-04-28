--[[ Indirect Neovim LSP client with nvim/nvim-lspconfig thru another plugin ]]

local km = require 'grs.config.keymaps'

local typescript_tools_configuration = function()
   local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

   require('typescript-tools').setup {
      capabilities = capabilities,
      on_attach = km.set_lsp_keymaps,
      handlers = {},
      settings = {
         separate_diagnostic_server = true,
         publish_diagnostic_on = 'change', -- default is 'insert_leave'
         -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
         -- "remove_unused_imports"|"organize_imports") -- or string "all"
         -- to include all supported code actions
         -- specify commands exposed as code_actions
         expose_as_code_action = {},
           -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
         -- not exists then standard path resolution strategy is applied
         tsserver_path = nil,
         tsserver_plugins = {},
         tsserver_max_memory = 'auto',
         tsserver_format_options = {},
         tsserver_file_preferences = {},
         tsserver_locale = "en",
         complete_function_calls = false, -- set to mirror typescript.suggest.completeFunctionCalls
         include_completions_with_insert_text = true,
         code_lens = 'on', -- not default
         disable_member_code_lens = false, -- default is true
         jsx_close_tag = {
            enable = true, -- set false if using something like nvim-ts-autotag
            filetypes = { 'javascriptreact', 'typescriptreact' },
         },
      },
   }

end

return {
   {
      --[[ Plugin provides an LSP wrapper layer for tsserver.

           The TypeScript standalone server (tsserver) is a node executable that
           encapsulates the TypeScript compiler to provide language services. It
           exposes these services thru a JSON based protocol. Well suited for
           editors and IDE support, it is not itself an LSP.

           Note that tsserver is NOT typescript-language-server (ts-ls) formally
           and confusingly also called tsserver.

           Both tsserver and typescript need to be install manually via the
           npm command `"$ npm install -g typescript-language-server typescript"

           This plugin used lspconfig directly to configure itself as an LSP server
           leveraging tsserver. Hence it acts as a monkey-in-the-middle between the
           built in Neovim LSP client and the pre-LSP tsserver.
      --]]
      'pmizio/typescript-tools.nvim',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'neovim/nvim-lspconfig',
      },
      ft = {
         'javascript',
         'javascriptreact',
         'javascript.jsx',
         'typescript',
         'typescriptreact',
         'typescript.tsx',
      },
      config = typescript_tools_configuration,
   },
}
