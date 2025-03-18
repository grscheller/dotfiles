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
      ---@module 'conform'
      ---@type conform.setupOpts
      opts = {
         formatters_by_ft = {
            css = { 'prettierd' },
            graphql = { 'prettierd' },
            haskell = { 'ormolu' },
            html = { 'prettierd' },
            lua = { 'stylua' },
            luau = { 'stylua' },
            python = { 'ruff_format' },
            markdown = { 'mdformat' },
            json = { 'prettierd' },
            javascript = { 'prettierd' },
            javascriptreact = { 'prettierd' },
            svelte = { 'prettierd' },
            toml = { 'taplo' },
            typescript = { 'prettierd' },
            typescriptreact = { 'prettierd' },
            yaml = { 'prettierd' },
         },
         default_format_opts = {
            lsp_format = 'fallback',
         },
         formatters = {},
      },
   },
}
