--[[ Plugin to enables range formatting for all formatters ]]

return {
   [1] = 'stevearc/conform.nvim',
   keys = {
      {
         [1] = '<leader>f',
         [2] = function()
            require('conform').format {
               async = false,
               timeout_ms = 2000,
            }
         end,
         mode = 'n',
         desc = 'format (conform)',
      },
   },
   opts = { formatters_by_ft = require('config.tooling').formatters },
}
