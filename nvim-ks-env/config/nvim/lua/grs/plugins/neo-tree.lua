--[[ Neo-tree is a Neovim plugin to browse the file system ]]
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
   'nvim-neo-tree/neo-tree.nvim',
   version = '*',
   dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
   },
   cmd = 'Neotree',
   keys = {
      { '<c-enter>', '<cmd>Neotree reveal<cr>', { desc = 'NeoTree reveal' } },
   },
   opts = {
      filesystem = {
         window = {
            mappings = {
               ['<c-enter>'] = 'close_window',
            },
         },
      },
   },
}
