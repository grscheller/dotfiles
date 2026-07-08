--[[ Plugin to integrate commandline formatters ]]

return {
   -- Lints what is saved to disk
   [1] = 'mfussenegger/nvim-lint',
   keys = {
      {
         [1] = '<leader>l',
         [2] = function()
            require('lint').try_lint()
         end,
         mode = 'n',
         desc = 'lint (nvim-lint)',
      },
   },
   config = function()
      require('lint').linters_by_ft = require('config.tooling').linters
   end
}
