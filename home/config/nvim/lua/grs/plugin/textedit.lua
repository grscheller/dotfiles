--[[ Plugins for general Text editing Related taske ]]

vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion

return {

   -- Comment/uncomment blocks of code
   {
      'numToStr/Comment.nvim',
      event = 'VeryLazy',
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
         { 'f', '<Plug>Sneak_f', mode = { 'n', 'x' }, desc = 'move to next char' },
         { 'F', '<Plug>Sneak_F', mode = { 'n', 'x' }, desc = 'move to prev char' },
         { 't', '<Plug>Sneak_t', mode = { 'n', 'x' }, desc = 'move before next char' },
         { 'T', '<Plug>Sneak_T', mode = { 'n', 'x' }, desc = 'move before prev char' },
      },
   },

   -- Surround text objects with matching symbols
   'tpope/vim-surround',

   -- Repeat commands from supported plugins
   'tpope/vim-repeat',

   -- Colorize color names, hexcodes, and other color formats
   {
      'norcalli/nvim-colorizer.lua',
      opts = {
         '*',
         '!vim',
         css = { rgb_fn = true },
         html = { names = false },
      },
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
            twilght = { enable = true },
         },
         on_open = function(win)
            vim.api.nvim_win_set_option(win, 'scrolloff', 10)
            vim.api.nvim_win_set_option(win, 'sidescrolloff', 8)
         end,
         on_close = function() end,
      },
      keys = {
         { 'zZ', '<Cmd>ZenMode<CR>', desc = 'zen-mode toggle' },
      },
   },

}
