--[[ Ensure Installation ]]

local M = {}

-- Not used yet?
M.linters = {
   ccs = { 'stylelint' },
   gitcommit ={ 'gitlint' },
   haskell ={ 'hlint' },
   html = { 'htmlhint' },
   javascript = { 'eslint_d' },
   javascriptreact = { 'eslint_d' },
   json = { 'jsonlint' },
   lua = { 'selene' },
   luau = { 'selene' },
   markdown = { 'markdownlint-cli2' },
   sh = { 'shellcheck' },
   svelte = { 'eslint_d' },
   typescript = { 'eslint_d' },
   vue = { 'eslint_d' },
}

-- Not used yet?
M.formatters = {
   css = { 'prettierd' },
   graphql = { 'prettierd' },
   haskell ={ 'ormolu' },
   html = { 'prettierd' },
   javascript = { 'prettierd' },
   javascriptreact = { 'prettierd' },
   json = { 'prettierd' },
   lua = { 'stylua' },
   markdown = { 'markdownlint-cli2' },
   svelte = { 'prettierd' },
   toml = { 'taplo' },
   typescript = { 'prettierd' },
   typescriptreact = { 'prettierd' },
   yaml = { 'prettierd' },
   -- css = { { "prettierd", "prettier" } }, -- run first formatter found
   -- python = { "isort", "black" }, -- run multiple linters
}

-- Treesitter parsers to ensure installed
M.treesitter_parsers = {
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
