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
         local tele = require 'telescope'

         tele.setup {
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

         tele.load_extension 'frecency'
         tele.load_extension 'fzf'
         tele.load_extension 'notify'
         tele.load_extension 'ui-select'
      end,
      keys = {
         { ' tb', function()
               require 'telescope'
               require('telescope.builtin').buffers()
            end, desc = 'list buffers' },
         { ' td', function()
               require 'telescope'
               require('telescope.builtin').grep_string()
            end, desc = 'grep files in dir' },
         { ' tf', function()
               require 'telescope'
               require('telescope.builtin').find_files()
            end, desc = 'find files' },
         { ' tg', function()
               require 'telescope'
               require('telescope.builtin').live_grep()
            end, desc = 'live grep' },
         { ' th', function()
               require 'telescope'
               require('telescope.builtin').help_tags()
            end, desc = 'help tags' },
         { ' tr', function()
               require 'telescope'
               require('telescope.builtin').oldfiles()
            end, desc = 'recent files' },
         { ' tz', function()
               require 'telescope'
               require('telescope.builtin').current_buffer_fuzzy_find()
            end, desc = 'fzy find buffer' },
         { ' tq', function()
               require('telescope').extensions.frecency.frecency()
            end, desc = 'frecency' },
         { ' tB', function()
               require('telescope').extensions.file_browser.file_browser()
            end, desc = 'file browser' },
      }
   },

}
