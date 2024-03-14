--[[ Lint certain file types on write ]]

-- nvim-lint does not present itself as an LSP like null-ls did, instead it uses
-- the vim.diagnostic module to present diagnostics in the same way the language
-- client built into neovim does. nvim-lint is meant to fill the gaps for
-- languages where either no language server exists, or where standalone linters
-- provide better results than available language servers do.

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

return {

   {
      'mfussenegger/nvim-lint',
      ft = { 'md', 'lua', 'luau' },
      config = function()
         local lint = require 'lint'
         lint.linters_by_ft = {
            markdown = { 'markdownlint' }, -- Rubygems
            lua = { 'selene' }, -- Pacman
            luau = { 'selene' },
         }
         local grsLintGrp = autogrp('GrsLint', { clear = true })
         autocmd('BufWritePost', {
            callback = function()
               lint.try_lint()
            end,
            group = grsLintGrp,
            desc = 'Trigger linting on write',
         })
      end,
   },

}
