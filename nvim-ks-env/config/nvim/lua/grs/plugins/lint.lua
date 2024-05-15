return {

   { -- Linting
      'mfussenegger/nvim-lint',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
         local lint = require 'lint'
         lint.linters_by_ft = {
            ccs = { 'stylelint' },
            clojure = nil,
            dockerfile = nil,
            inko = { "inko" },
            janet = { "janet" },
            json = { "jsonlint" },
            markdown = { 'markdownlint' },
            rst = nil,
            ruby = { "ruby" },
            sh = { 'shellcheck' },
            terraform = { "tflint" },
            text = { "vale" },
         }

         local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
         vim.api.nvim_create_autocmd({
            'BufEnter',
            'BufWritePost',
            'InsertLeave',
         }, {
            group = lint_augroup,
            callback = function()
               require('lint').try_lint()
            end,
         })
      end,
   },
}
