--[[ Indirect Neovim LSP client with nvim/nvim-lspconfig thru another plugin ]]

local km = require('grs.config.keymaps')

return {
   {
      -- Plugin provides an LSP wrapper layer for tsserver.
      --
      -- The TypeScript standalone server (tsserver) is a node executable that
      -- encapsulates the TypeScript compiler providing language services. It
      -- exposes these services thru a JSON based protocol. Well suited for
      -- editors and IDE support, it is not itself an LSP.
      --
      -- Note that tsserver is NOT typescript-language-server (ts-ls) formally
      -- and confusingly also called tsserver.
      --
      -- Both tsserver and typescript need to be install manually via the
      -- npm command `"$ npm install -g typescript-language-server typescript"
      --
      -- I believe this plugin used lspconfig directly to configure itself
      -- as an LSP server leveraging tsserver, hence its inclusion here.
      --
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
      opts = {},
   }
}
