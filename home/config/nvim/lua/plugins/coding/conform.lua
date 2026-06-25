--[[ Plugin to enables range formatting for all formatters ]]

local opts = {
   formatters_by_ft = {
      css = { 'prettierd' },
      haskell = { 'ormolu' },
      html = { 'prettierd' },
      lua = { 'stylua' },
      luau = { 'stylua' },
      markdown = { 'mdformat' },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      json = { 'prettierd' },
      yaml = { 'prettierd' },
   },
}

return {
   'stevearc/conform.nvim',
   dependencies = {
      'folke/which-key.nvim',
   },
   config = function()
      local wk = require 'which-key'
      local conform = require 'conform'
      conform.setup(opts)
      wk.add {
         '<leader>f',
         function()
            conform.format {
               async = false,
               timeout_ms = 2000,
            }
         end,
         desc = 'conform format',
      }
   end,
}
