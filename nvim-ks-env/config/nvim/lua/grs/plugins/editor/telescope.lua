--[[ Telescope - search, filter, find & pick items ]]

return {

   {
      'nvim-telescope/telescope.nvim',
      event = 'VeryLazy',
      dependencies = {
         'nvim-telescope/telescope-ui-select.nvim',
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
         },
      },
      opts = {
         defaults = {
            prompt_prefix = ' ',
            selection_caret = ' ',
         },
      },
      config = function()
         local telescope = require 'telescope'
         telescope.setup {
            extensions = {
               -- hijack netrw with something better
               file_browser = {
                  theme = 'ivy',
                  hijack_netrw = true,
               },

               -- replaces Python fzf with one written in C
               fzf = {
                  fuzzy = true,
                  override_generic_sorter = true,
                  override_file_sorter = true,
                  case_mode = 'respect_case',
               },

               -- info on plugins installed via lazy.nvim
               lazy = {
                  theme = 'ivy',
                  show_icon = true,
                  mappings = {
                     open_in_browser = "<C-o>",
                     open_in_file_browser = "<M-b>",
                     open_in_find_files = "<C-f>",
                     open_in_live_grep = "<C-g>",
                     open_plugins_picker = "<C-b>",  -- works only after another action
                     open_lazy_root_find_files = "<C-r>f",
                     open_lazy_root_live_grep = "<C-r>g",
                  },
               },

               -- set vim.ui.select to telescope
               ['ui-select'] = {
                  require('telescope.themes').get_dropdown {
                     -- no idea how to configure this thing yet
                  },
               },
            },
         }
         telescope.load_extension 'fzf'
         telescope.load_extension 'ui-select'
      end,
      cmd = 'Telescope',
      keys = {
         {
            '<leader>tb',
            function()
               require 'telescope'
               require('telescope.builtin').buffers()
            end,
            desc = 'list buffers',
         },
         {
            '<leader>td',
            function()
               require 'telescope'
               require('telescope.builtin').grep_string()
            end,
            desc = 'grep files in dir',
         },
         {
            '<leader>tf', function()
               require 'telescope'
               require('telescope.builtin').find_files()
            end,
            desc = 'find files',
         },
         {
            '<leader>tg',
            function()
               require 'telescope'
               require('telescope.builtin').live_grep()
            end,
            desc = 'live grep',
         },
         {
            '<leader>th',
            function()
               require 'telescope'
               require('telescope.builtin').help_tags()
            end,
            desc = 'help tags',
         },
         {
            '<leader>tr',
            function()
               require 'telescope'
               require('telescope.builtin').oldfiles()
            end,
            desc = 'recent files',
         },
         {
            '<leader>tz',
            function()
               require 'telescope'
               require('telescope.builtin').current_buffer_fuzzy_find()
            end,
            desc = 'fzf current buffer',
         },
      },
   },

   {
      'nvim-telescope/telescope-file-browser.nvim',
      keys = {
         {
            '<leader>tB',
            function()
               local telescope = require('telescope')
               telescope.load_extension 'file_browser'
               telescope.extensions.file_browser.file_browser()
            end,
            desc = 'file browser',
         },
      },
   },

   {
      'tsakirist/telescope-lazy.nvim',
      dependencies = {
         'nvim-telescope/telescope.nvim',
      },
      keys = {
         {
            '<leader>tl',
            function()
               local telescope = require('telescope')
               telescope.load_extension 'lazy'
               telescope.extensions.lazy.lazy()
            end,
            desc = 'telescope-lazy',
         },
      },
   },

}
