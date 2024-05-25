--[[ Lint certain file types on write ]]

-- formatter.nvim invokes command-line tools to perform formatting
-- operations. Formatters are all opt-in. These can be user configurable or
-- default configurations can be used. See lua/formatter/filetypes/ in the
-- plugin's directory for all the available default configurations. See the
-- README.md for how to set up a user defined configuration.

local formatters_by_filetype = require('grs.config.ensure_install').formatters

return {
   {
      'stevearc/conform.nvim',
      keys = {
         {
            '<leader>fF',
            function()
               require('conform').format { async = true, lsp_fallback = false }
            end,
            mode = '',
            desc = 'format buffer',
         },
      },
      opts = {
         notify_on_error = false,
         formatters_by_ft = formatters_by_filetype,
      },
   },
}
