--[[ Telescope - search, filter, find & pick items with Lua ]]

return {

   -- Telescope built-ins
   {
      'nvim-telescope/telescope.nvim',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'nvim-telescope/telescope-file-browser.nvim',
         'nvim-telescope/telescope-frecency.nvim',
         {
            'nvim-telescope/telescope-frecency.nvim',
            dependencies = {
               'kkharji/sqlite.lua',
            },
         },
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
         },
         'nvim-telescope/telescope-ui-select.nvim',
         'rcarriga/nvim-notify',
      },
      config = function()
         ts = require 'telescope'
         tb = require 'telescope.builtin'
         te = ts.extensions
         km = vim.keymap.set

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

         ts.load_extension 'frecency'
         ts.load_extension 'fzf'
         ts.load_extension 'notify'
         ts.load_extension 'ui-select'

         km('n', ' tb', tb.buffers, { desc = 'list buffers' })
         km('n', ' td', tb.grep_string, { desc = 'grep files in dir' })
         km('n', ' tf', tb.find_files, { desc = 'find files' })
         km('n', ' tg', tb.live_grep, { desc = 'live grep' })
         km('n', ' th', tb.help_tags, { desc = 'help tags' })
         km('n', ' tr', tb.oldfiles, { desc = 'recent files' })
         km('n', ' tz', tb.current_buffer_fuzzy_find, { desc = 'fuzzy find buffer' })
         km('n', ' tq', te.frecency.frecency, { desc = 'frecency' })
         km('n', ' tB', te.file_browser.file_browser, { desc = 'file browser' })
      end,
      event = 'VeryLazy',
   },

}
