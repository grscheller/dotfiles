--[[ Enable LSP configs and supporting infrastructure ]]

local M = {}

M.lsp_servers = {
   'bashls',
   'lua_ls',
   'marksman',
   'pylsp',
   'ruff',
   'tombi',
   'zls',
}
vim.lsp.enable(M.lsp_servers)

M.debug_adapters = {
   'python',
   'codelldb',
}

M.linters = {
   css = { 'stylelint' },
   gitcommit = { 'gitlint' },
   haskell = { 'hlint' },
   html = { 'markuplint' },
   javascript = { 'eslint_d' },
   javascriptreact = { 'eslint_d' },
   json = { 'jsonlint' },
   lua = { 'selene' },
   luau = { 'selene' },
   markdown = { 'markdownlint-cli' },
   python = { 'sphinx-lint' },
   rst = { 'rstcheck', 'sphinx-lint' },
   sh = { 'shellcheck' },
   svelte = { 'eslint_d' },
   typescript = { 'eslint_d' },
   typescriptreact = { 'eslint_d' },
   vue = { 'eslint_d' },
}

M.formatters = {
   css = { 'prettierd' },
   haskell = { 'fourmolu' },
   html = { 'prettierd' },
   lua = { 'stylua' },
   luau = { 'stylua' },
   markdown = { 'mdformat', 'markdown-toc' },
   rust = { 'rustfmt' },
   sh = { 'shfmt' },
   json = { 'prettierd' },
   yaml = { 'prettierd' },
}

M.tools_to_install = {
   'clang-format',  -- C, C#, C++, JSON, Java, JavaScript - not yet configured
   'cljfmt',  -- Clojure, ClojureScript - not yet configured
   'fourmolu',  -- Haskell (less opinionated than ormolu)
   'markdown-toc',
   'mdformat',
   'prettierd',
   'rstcheck',
   'stylua',  -- lua, luau
   -- Linter-Formatters
}

return M
