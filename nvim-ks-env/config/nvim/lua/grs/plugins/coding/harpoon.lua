--[[ Harpoon - quickly jump to certain file or terminals ]]
--
-- Harpoon marks serve a similar purpose to vim global marks, but differ in
-- a few key ways:
--
--   1. they auto update their position within the file
--   2. they juggle both files and nvim terminals
--   3. they are saved on a per "project" basis
--   4. they can be set on a per branch basis in a git repo (I don't do)
--

return {

   {
      'ThePrimeagen/harpoon',
      keys = {
         {
            '<leader>hh',
            function()
               require('harpoon.ui').toggle_quick_menu()
            end,
            desc = 'show marks',
         },
         {
            '<leader>ha',
            function()
               require('harpoon.mark').add_file()
            end,
            desc = 'add mark',
         },
         {
            '<leader>hn',
            function()
               require('harpoon.ui').nav_next()
            end,
            desc = 'nav next mark',
         },
         {
            '<leader>hp',
            function()
               require('harpoon.ui').nav_prev()
            end,
            desc = 'nav prev mark',
         },
         {
            '<leader>h1',
            function()
               require('harpoon.term').gotoTerminal(1)
            end,
            desc = 'harpoon term 1',
         },
         {
            '<leader>h2',
            function()
               require('harpoon.term').gotoTerminal(2)
            end,
            desc = 'harpoon term 2',
         },
         {
            '<leader>h3',
            function()
               require('harpoon.term').gotoTerminal(3)
            end,
            desc = 'harpoon term 3',
         },
      },
      opts = {
         menu = {
            width = vim.api.nvim_win_get_width(0) - 4,
         },
      },
   },

}
