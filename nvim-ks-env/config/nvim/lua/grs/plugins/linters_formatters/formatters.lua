--[[ Lint certain file types on write ]]

-- formatter.nvim invokes command-line tools to perform formatting
-- operations. Formatters are all opt-in. These can be user configurable or
-- default configurations can be used. See lua/formatter/filetypes/ in the
-- plugin's directory for all the available default configurations. See the
-- README.md for how to set up a user defined configuration.

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

return {

   {
      'stevearc/conform.nvim',
      keys = {
         {
             '<leader>f',
            function()
               require('conform').format { async = true, lsp_fallback = true }
            end,
            mode = '',
            desc = 'format buffer',
         },
      },
      opts = {
         notify_on_error = false,
         formatters_by_ft = {
            lua = { 'stylua' },
            toml = { 'taplo' },

            -- run multiple formatters sequentially
            -- python = { "isort", "black" },

            -- run first formatter found.
            -- javascript = { { "prettierd", "prettier" } },
         },
      },
   },
}
