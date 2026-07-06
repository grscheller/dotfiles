--[[ Hijack vim.notify - used by Noice ]]

return {
   [1] = 'rcarriga/nvim-notify',
   dependencies = { 'nvim-treesitter/nvim-treesitter' },
   event = 'VeryLazy',
   config = function()
      vim.notify = require 'notify'
   end,
}
