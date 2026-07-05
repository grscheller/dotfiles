--[[ Enable LSP configs and supporting infrastructure ]]

local functional = require 'lib.functional'

local flatten = functional.flatten_array
local values = functional.get_table_values
local sort = functional.sort_array_uniq
local concat = functional.concat_arrays

local M = {}

local mason_lsp_servers = {
   'bashls',
   'lua_ls',
   'marksman',
   'ruff',
   'tombi',
   'zls',
}

local venv_lsp_servers = {
   'zuban',
}

M.mason_lsp_servers = mason_lsp_servers
M.lsp_servers = concat(mason_lsp_servers, venv_lsp_servers)

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
   markdown = { 'markdownlint-cli2' },
   python = { 'sphinx-lint' },
   rst = { 'rstcheck', 'sphinx-lint' },
   sh = { 'shellcheck' },
   svelte = { 'eslint_d' },
   typescript = { 'eslint_d' },
   typescriptreact = { 'eslint_d' },
   vue = { 'eslint_d' },
}

M.formatters = {
   c = { 'clang-format' },
   clojure = { 'cljfmt' },
   cpp = { 'clang-format' },
   css = { 'prettierd' },
   haskell = { 'fourmolu' },
   html = { 'prettierd' },
   java = { 'clang-format' },
   js = { 'clang-format' },
   lua = { 'stylua' },
   luau = { 'stylua' },
   markdown = { 'mdformat', 'markdown-toc' },
   sh = { 'shfmt' },
   json = { 'clang-format' },
   yaml = { 'prettierd' },
}

M.linters_and_formatters = sort(concat(flatten(values(M.linters)), flatten(values(M.formatters))))

return M
