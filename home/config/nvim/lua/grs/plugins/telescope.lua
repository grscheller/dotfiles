--[[ Telescope - search, filter, find & pick items with Lua ]]

return {
   -- Telescope - highly extendable fuzzy finder over lists
   {
      'nvim-telescope/telescope.nvim',
      event = 'VeryLazy',
      config = function()
         ts = require 'telescope'
         ts.setup {
            extensions = {
               file_browser = {},
               frecency = {},
               fzf = {},
               notify = {},
               ['ui-select'] = {
                  require('telescope.themes').get_dropdown {},
               },
            },
         }

         -- Load Telescope extensions
         ts.load_extension 'file_browser'
         ts.load_extension 'frecency'
         ts.load_extension 'fzf'
         ts.load_extension 'notify'
         ts.load_extension 'ui-select'

         -- Telescope built-ins
         local tb = require 'telescope.builtin'

         local tb_td = tb.grep_string
         local tb_tf = tb.find_files
         local tb_tg = tb.live_grep
         local tb_th = tb.help_tags
         local tb_tl = tb.buffers
         local tb_tr = tb.oldfiles
         local tb_tz = tb.current_buffer_fuzzy_find

         -- Hack in keymappings for now
         -- TODO: do with keys???
         kmap = vim.keymap.set

         -- Telescope builtins
         kmap('n', ' td', tb_td, { desc = 'grep files curr dir' })
         kmap('n', ' tf', tb_tf, { desc = 'find files' })
         kmap('n', ' tg', tb_tg, { desc = 'grep content files' })
         kmap('n', ' th', tb_th, { desc = 'help tags' })
         kmap('n', ' tl', tb_tl, { desc = 'list buffers' })
         kmap('n', ' tr', tb_tr, { desc = 'find recent files' })
         kmap('n', ' tz', tb_tz, { desc = 'fuzzy find curr buff' })

         -- Telescope extensions
         local filebrowser = ts.extensions.file_browser.file_browser
         local frecency = ts.extensions.frecency.frecency
         kmap('n', ' tb', filebrowser, { desc = 'file browser' })
         kmap('n', ' tq', frecency, { desc = 'telescope frecency' })

         -- Telescope commands
         kmap('n', ' tt', '<Cmd>Telescope<CR>', { desc = 'telescope command' })
      end,
      dependencies = {
         'nvim-lua/plenary.nvim',
         'nvim-telescope/telescope-file-browser.nvim',
         { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', },
         'nvim-telescope/telescope-frecency.nvim',
         'nvim-telescope/telescope-ui-select.nvim',
         'rcarriga/nvim-notify',
         'kkharji/sqlite.lua',
      },
   },
}
