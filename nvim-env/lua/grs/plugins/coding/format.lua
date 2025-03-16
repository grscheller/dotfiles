--[[ Plugin to integrate commandline formatters ]]

return {
   {
      -- Enables range formatting for all formatters
      'stevearc/conform.nvim',
      cmd = { 'ConformInfo' },
      keys = {
         {
            -- Customize or remove this keymap to your liking
            '<leader>f',
            function()
               require('conform').format { async = true }
            end,
            mode = '',
            desc = 'Format buffer',
         },
      },
      config = function()
         local conform = require('conform')

         conform.setup {
            formatters_by_ft = {
               lua = { 'stylua' },
               python = { 'ruff_format' },
               fish = { 'fish_indent' },
               markdown = { 'mdformat' },
               css = { 'prettierd' },
               json = { 'prettierd' },
               yaml = { 'prettierd' },
               javascript = { 'prettierd' },
               typescript = { 'prettierd' },
               javascriptreact = { 'prettierd' },
               typescriptreact = { 'prettierd' },
               svelte = { 'prettierd' },
            },
         }
      end,
   },
}
