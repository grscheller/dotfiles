--[[ Plugin to integrate commandline formatters ]]

return {
   -- Lints what is saved to disk
   'mfussenegger/nvim-lint',
   keys = {
      {
         '<leader>l',
         function()
            require('lint').try_lint()
         end,
         mode = 'n',
         desc = 'lint (nvim-lint)',
      },
   },
   config = function()
      local lint = require 'lint'
      local tooling = require 'config.tooling'

      lint.linters_by_ft = tooling.linters
   end
}
