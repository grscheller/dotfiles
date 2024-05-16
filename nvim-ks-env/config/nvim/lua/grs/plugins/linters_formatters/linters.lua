--[[ Lint certain file types on BufWritePost and InsertLeave ]]

-- Nvim-lint does not present itself as an LSP like null-ls did. Instead it uses
-- the vim.diagnostic module to present diagnostics in the same way the language
-- client built into neovim does. Nvim-lint is meant to fill the gaps for
-- languages where either no language server exists, or where standalone linters
-- provide better results than available language servers do.

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

return {

   {
      'mfussenegger/nvim-lint',
      ft = {
         'ccs',
         'javascript',
         'json',
         'lua',
         'luau',
         'md',
         'sh',
         'typescript',
      },
      config = function()
         local lint = require 'lint'
         lint.linters_by_ft = {
            ccs = { 'stylelint' },
            javascript = { 'eslint' },
            -- javascriptreact = { 'eslint' },
            json = { 'jsonlint' },
            lua = { 'selene' },
            luau = { 'selene' },
            markdown = { 'markdownlint' },
            sh = { 'shellcheck' },
            typescript = { 'eslint' },
            -- vue = { 'eslint' },
            -- svelte = { 'eslint' },
         }

         local grsLintGrp = autogrp('GrsLint', { clear = true })
         autocmd({ 'BufWritePost' }, {
            callback = function()
               lint.try_lint()
            end,
            group = grsLintGrp,
            desc = 'Trigger linting on write or leaving insert mode',
         })
      end,
   },
}
