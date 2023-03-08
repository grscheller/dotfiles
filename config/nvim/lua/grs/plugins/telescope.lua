--[[ Telescope - search, filter, find & pick items ]]

return {

   --[[ Telescope ]]

   {
      'nvim-telescope/telescope.nvim',
      version = false,
      dependencies = {
         'kyazdani42/nvim-web-devicons',
         'nvim-lua/plenary.nvim',
         'nvim-treesitter/nvim-treesitter',
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
         },
         'nvim-telescope/telescope-ui-select.nvim',
      },
      config = function()
         local telescope = require 'telescope'
         telescope.setup {
            extensions = {
               fzf = {
                  fuzzy = true,
                  override_generic_sorter = true,
                  override_file_sorter = true,
                  case_mode = 'respect_case',
               },
               ['ui-select'] = {
                  require('telescope.themes').get_dropdown {},
               },
            },
         }
         telescope.load_extension('fzf')
         telescope.load_extension('ui-select')
      end,
      keys = {
         {
            ' tb',
            function()
               require 'telescope'
               require('telescope.builtin').buffers()
            end,
            desc = 'list buffers',
         },
         {
            ' td',
            function()
               require 'telescope'
               require('telescope.builtin').grep_string()
            end,
            desc = 'grep files in dir',
         },
         {
            ' tf', function()
               require 'telescope'
               require('telescope.builtin').find_files()
            end,
            desc = 'find files',
         },
         {
            ' tg',
            function()
               require 'telescope'
               require('telescope.builtin').live_grep()
            end,
            desc = 'live grep',
         },
         {
            ' th',
            function()
               require 'telescope'
               require('telescope.builtin').help_tags()
            end,
            desc = 'help tags',
         },
         {
            ' tr',
            function()
               require 'telescope'
               require('telescope.builtin').oldfiles()
            end,
            desc = 'recent files',
         },
         {
            ' tz',
            function()
               require 'telescope'
               require('telescope.builtin').current_buffer_fuzzy_find()
            end,
            desc = 'fzy find buffer',
         },
      },
   },

   --[[ Telescope built-ins ]]

   {
      'nvim-telescope/telescope-file-browser.nvim',
      dependencies = {
         'nvim-telescope/telescope.nvim',
      },
      config = function()
         require('telescope').load_extension('file_browser')
      end,
      keys = {
         {
            ' tB',
            function()
               require('telescope').extensions.file_browser.file_browser {
                  theme = 'ivy',
                  hijack_netrw = true,
               }
            end,
            desc = 'file browser',
         },
      },
   },

   {
      'nvim-telescope/telescope-frecency.nvim',
      dependencies = {
         'nvim-telescope/telescope.nvim',
         'kkharji/sqlite.lua',
      },
      config = function()
         require('telescope').load_extension('frecency')
      end,
      keys = {
         { ' tq',
            function()
               require('telescope').extensions.frecency.frecency()
            end,
            desc = 'frecency',
         },
      },
   },

   --[[
      {
         'nvim-telescope/notify.nvim',
         dependencies = {
            'nvim-telescope/telescope.nvim',
            'rcarriga/nvim-notify',
         },
         config = function()
            local telescope = require 'telescope'
            telescope.extensions.notify.notify {}
            telescope.load_extension('notify')
         end,
      },
   --]]

}
