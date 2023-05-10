--[[ Plugins for general Text editing Related taske ]]

vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion


return {

   -- Comment/uncomment blocks of code
   {
      'numToStr/Comment.nvim',
      event = 'BufReadPost',
      opts = {
         ignore = '^$',
         mappings = {
            basic = true,
            extra = true,
         },
      },
   },

   -- Quickly jump around window - like easy-motion
   {
      'justinmk/vim-sneak',
      keys = {
         { 's', '<plug>Sneak_s', mode = { 'n', 'x' }, desc = 'sneak forward' },
         { 'z', '<plug>Sneak_s', mode = { 'o' },      desc = 'sneak forward' },
         { 'S', '<plug>Sneak_S', mode = { 'n' },      desc = 'sneak backward' },
         { 'Z', '<plug>Sneak_S', mode = { 'x', 'o' }, desc = 'sneak backward' },
         { 'f', '<plug>Sneak_f', mode = { 'n', 'x', 'o' }, desc = 'move to next char' },
         { 't', '<plug>Sneak_t', mode = { 'n', 'x', 'o' }, desc = 'move before next char' },
         { 'F', '<plug>Sneak_F', mode = { 'n', 'x', 'o' }, desc = 'move to prev char' },
         { 'T', '<plug>Sneak_T', mode = { 'n', 'x', 'o' }, desc = 'move before prev char' },
      },
   },

   -- Surround text objects with matching symbols
   {
      'tpope/vim-surround',
      event = 'BufReadPost',
   },

   -- Repeat commands from supported plugins
   {
      'tpope/vim-repeat',
      event = 'BufReadPost',
   },

   -- Folke Zen Mode
   {
      'folke/zen-mode.nvim',
      dependencies = {
         'folke/twilight.nvim',
      },
      opts = {
         window = {
            backdrop = 1.0, -- shade backdrop, 1 to keep normal
            width = 0.85, -- abs num of cells when > 1, % of width when <= 1
            height = 1, -- abs num of cells when > 1, % of height when <= 1
            options = {
               number = false,
               relativenumber = false,
               colorcolumn = '',
            },
         },
         plugins = {
            options = {},
            twilight = { enable = true },
         },
         on_open = function(win)
            vim.api.nvim_win_set_option(win, 'scrolloff', 10)
            vim.api.nvim_win_set_option(win, 'sidescrolloff', 8)
         end,
         on_close = function() end,
      },
      keys = {
         { 'zZ', '<cmd>ZenMode<cr>', desc = 'zen-mode toggle' },
      },
   },

}
