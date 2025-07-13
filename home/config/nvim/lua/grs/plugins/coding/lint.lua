--[[ Plugin to integrate commandline formatters ]]

local lint_config = function()
   local lint = require 'lint'

   lint.linters_by_ft = {
      gitcommit = { 'gitlint' },
      haskell = { 'hlint' },
      html = { 'markuplint' },
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      json = { 'jsonlint' },
      lua = { 'selene' },
      luau = { 'selene' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      markdown = { 'markdownlint-cli' },
      python = { 'sphinx-lint' },
      rst = { 'sphinx-lint' },
      sh = { 'shellcheck' },
      svelte = { 'eslint_d' },
      vue = { 'eslint_d' },
   }
end

return {
   {
      -- Lints what is saved to disk
      'mfussenegger/nvim-lint',
      keys = {
         {
            '<leader>l',
            function()
               require('lint').try_lint()
            end,
            mode = 'n',
            desc = 'Lint',
         },
      },
      config = lint_config,
   },
}
