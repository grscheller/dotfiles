--[[ Lint certain file types on BufWritePost and InsertLeave ]]

-- Nvim-lint does not present itself as an LSP like null-ls did. Instead it uses
-- the vim.diagnostic module to present diagnostics in the same way the language
-- client built into neovim does. Nvim-lint is meant to fill the gaps for
-- languages where either no language server exists, or where standalone linters
-- provide better results than available language servers do.

local getKeys = require('grs.lib.functional').getKeys

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

local linters_by_filetype = require('grs.config.ensure_install').linters
local filetypes = getKeys(linters_by_filetype)

return {

   {
      -- TODO: move linters_by_ft to config/ and generate ft from it
      'mfussenegger/nvim-lint',
      ft = filetypes,
      config = function()
         local lint = require 'lint'
         lint.linters_by_ft = linters_by_filetype

         local list_linters = function()
            local msg
            local linters = lint.linters_by_ft[vim.bo.filetype] or {}

            if #linters == 0 then
               msg = '󰦕 '
            else
               msg = '󱉶 ' .. table.concat(linters, ', ')
            end
            vim.api.nvim_notify(msg, vim.log.levels.INFO, {})
         end

         usercmd('GL', list_linters, {})

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
