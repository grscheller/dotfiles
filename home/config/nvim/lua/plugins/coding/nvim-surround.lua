--[[ Surround text objects and motions with matching symbols ]]

return {
   'kylechui/nvim-surround',
   event = 'VeryLazy',
   config = function()
      require('nvim-surround').setup {}
   end,
}
