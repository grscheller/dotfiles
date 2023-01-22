--[[ Install Language Modules for Neovim's built-in Treesitter ]]

return {

   {
      'nvim-treesitter/nvim-treesitter',
      version = false,
      build = ':TSUpdateSync',
      event = 'BufReadPost',
      config = function()
         require('nvim-treesitter.configs').setup {
            highlight = { enable = true },
            indent = { enable = true },
            context_commentstring = {
               enable = true,
               enable_autocmd = false,
            },
            ensure_installed = {
               'awk',
               'bash',
               'c',
               'clojure',
               'cmake',
               --'comment', -- slows TS bigtime, as per Folke dot repo
               'cpp',
               'css',
               'diff',
               'fish',
               'fortran',
               'git_rebase',
               'gitattributes',
               'gitcommit',
               'gitignore',
               'go',
               'haskell',
               'help',
               'html',
               'java',
               'javascript',
               'json',
               'jsonc',
               'julia',
               'kotlin',
               'latex',
               'llvm',
               'lua',
               'make',
               'markdown',
               'markdown_inline',
               'norg',
               'python',
               'query',
               'r',
               'racket',
               'regex',
               'rust',
               'scala',
               'toml',
               'tsx',
               'typescript',
               'vim',
               'yaml',
               'zig',
            },
         }
      end,
   },

}
