--[[ Telescope - search, filter, find & pick items ]]

local km = vim.keymap.set

return {

   {
      -- Open window showing keymaps for current picker,
         -- Insert mode: <c-/>
         -- Normal mode: ?
     'nvim-telescope/telescope.nvim',
      dependencies = {
         { 'nvim-lua/plenary.nvim' },
         { 'nvim-tree/nvim-web-devicons' },
         { 'nvim-telescope/telescope-ui-select.nvim' },
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
               return vim.fn.executable 'make' == 1
            end,
         },
      },
      event = 'VeryLazy',
      config = function()
         local telescope = require 'telescope'
         local builtin = require 'telescope.builtin'
         local themes = require 'telescope.themes'

         telescope.setup {
            defaults = {
               -- mappings while in telescope
               mappings = {
                  i = { ['<c-enter>'] = 'to_fuzzy_refine' },
               },
               prompt_prefix = ' ',
               selection_caret = ' ',
            },
            extensions = {
               file_browser = {
                  theme = 'ivy',
                  hijack_netrw = true,
               },
               fzf = {
                  fuzzy = true,
                  override_generic_sorter = true,
                  override_file_sorter = true,
                  case_mode = 'respect_case',
               },
               lazy = {
                  theme = 'ivy',
               },
               ['ui-select'] = {
                  themes.get_dropdown {},
               },
            },
            pickers = {},
         }

         telescope.load_extension 'ui-select'
         telescope.load_extension 'fzf'

         km('n', '<leader>sh', builtin.help_tags, { desc = 'search help' })
         km('n', '<leader>sk', builtin.keymaps, { desc = 'search kymaps' })
         km('n', '<leader>sf', builtin.find_files, { desc = 'search files' })
         km('n', '<leader>ss', builtin.builtin, { desc = 'search select telescope' })
         km('n', '<leader>sw', builtin.grep_string, { desc = 'search current word' })
         km('n', '<leader>sg', builtin.live_grep, { desc = 'search by grep' })
         km('n', '<leader>sd', builtin.diagnostics, { desc = 'search diagnostics' })
         km('n', '<leader>sr', builtin.resume, { desc = 'search resume' })
         km('n', '<leader>s.', builtin.oldfiles, { desc = 'search recent files ("." for repeat)' })
         km(
            'n',
            '<leader>/',
            function()
               builtin.current_buffer_fuzzy_find(require(themes).get_dropdown {
                  winblend = 10,
                  previewer = false,
               })
            end,
            { desc = 'fuzzily search in current buffer' }
         )
         km(
            'n',
            '<leader>so',
            function()
               builtin.live_grep {
                  grep_open_files = true,
                  prompt_title = 'Live Grep in Open Files',
               }
            end,
            { desc = 'search open files' }
         )
      end,
   },

   {
      'nvim-telescope/telescope-file-browser.nvim',
      dependencies = {
         'nvim-telescope/telescope.nvim',
         'nvim-lua/plenary.nvim',
      },
      keys = {
         {
            '<leader>sF',
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
            '<leader>sl',
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
