--[[ Hijack vim.notify - used by Noice ]]

return {
   'rcarriga/nvim-notify',
   priority = 900,
   dependencies = { 'nvim-treesitter/nvim-treesitter' },
   config = function()
      vim.notify = require 'notify'
   end,
}
