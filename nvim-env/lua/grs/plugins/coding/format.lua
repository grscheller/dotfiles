--[[ Plugin to integrate cmdline formatters ]]

local conform_opts = {
   formatters_by_ft = {
      css = { 'prettierd' },
      graphql = { 'prettierd' },
      haskell = { 'ormolu' },
      html = { 'prettierd' },
      lua = { 'stylua' },
      luau = { 'stylua' },
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
}

return {
   {
      -- Enables range formatting for all formatters
      'stevearc/conform.nvim',
      cmd = { 'ConformInfo' },
      keys = {
         {
            '<leader>f',
            function()
               require('conform').format { async = true }
            end,
            mode = '',
            desc = 'Format',
         },
      },
      opts = conform_opts,
   },
}
