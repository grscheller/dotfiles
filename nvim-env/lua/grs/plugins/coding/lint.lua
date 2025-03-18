--[[ Plugin to integrate commandline formatters ]]

return {
   {
      -- Enables range formatting for all formatters
      'mfussenegger/nvim-lint',
      keys = {
         {
            -- Customize or remove this keymap to your liking
            '<leader>l',
            function()
               require('lint').try_lint()
            end,
            mode = 'n',
            desc = 'Lint buffer',
         },
      },
      config = function()
         local lint = require('lint')

         lint.linters_by_ft = {
            haskell = { 'hlint'},
            html = { 'markuplint'},
            javascript = { 'eslint_d' },
            javascriptreact = { 'eslint_d' },
            lua = {'selene'},
            typescript = { 'eslint_d' },
            typescriptreact = { 'eslint_d' },
            markdown = { 'markdownlint-cli2' },
            svelte = { 'eslint_d' },
            python = { 'pylint' },
         }
      end,
   },
}
