--[[ Plugin to enables range formatting for all formatters ]]

return {
   'stevearc/conform.nvim',
   keys = {
      {
         '<leader>f',
         function()
            conform.format {
               async = false,
               timeout_ms = 2000,
            }
         end,
         mode = 'n',
         desc = 'format (conform)',
      },
   },
   config = function()
      local tools = require 'config.tools'
      local conform = require 'conform'

      conform.setup { formatters_by_ft = tools.formatters }
   end,
}
