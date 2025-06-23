--[[ Config neovim built-in treesitter & install language modules to it ]]

local opts = {
   ensure_installed = {
      'awk',
      'bash',
      'c',
      'clojure',
      'cmake',
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
      'ocaml',
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
      'vimdoc',
      'yaml',
      'zig',
   },
   auto_install = true,
   ignore_install = {},
   sync_install = false,
   highlight = { enable = true },
}

local config_treesitter = function()
   require('nvim-treesitter.install').prefer_git = true
   require('nvim-treesitter.configs').setup(opts)
   -- Check out these nvim-treesitter modules:
   -- - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
   -- - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
   -- - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
end

return {
   {
      -- Nvim interface to the tree-sitter parser generator tool and an incremental parsing library.
      -- Primarily used for syntax highlighting.
      'nvim-treesitter/nvim-treesitter',
      config = config_treesitter,
      build = ':TSUpdate',
   },
}
