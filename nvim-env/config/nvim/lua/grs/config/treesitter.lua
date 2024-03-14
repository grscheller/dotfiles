--[[ Configure parsers for treesitter to install ]]

local M = {}

-- Treesitter parsers to ensure installed
M.ensure_installed = {
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
}

return M
