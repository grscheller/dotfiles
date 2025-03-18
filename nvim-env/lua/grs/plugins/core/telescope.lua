--[[ Telescope - search, filter, find & pick items ]]

local config_telescope = function()
   local telescope = require 'telescope'
   local builtin = require 'telescope.builtin'
   local themes = require 'telescope.themes'
   local wk = require 'which-key'

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

   wk.add {
      { '<leader>sh', builtin.help_tags, desc = 'search help' },
      { '<leader>sk', builtin.keymaps, desc = 'search kymaps' },
      { '<leader>sf', builtin.find_files, desc = 'search files' },
      { '<leader>ss', builtin.builtin, desc = 'search select telescope' },
      { '<leader>sw', builtin.grep_string, desc = 'search current word' },
      { '<leader>sg', builtin.live_grep, desc = 'search by grep' },
      { '<leader>sd', builtin.diagnostics, desc = 'search diagnostics' },
      { '<leader>sr', builtin.resume, desc = 'search resume' },
      { '<leader>s.', builtin.oldfiles, desc = 'search recent files' },
      {
         '<leader>/',
         function()
            builtin.current_buffer_fuzzy_find(themes.get_dropdown {
               winblend = 50,
               previewer = false,
            })
         end,
         desc = 'fuzzily search in current buffer',
      },
      {
         '<leader>so',
         function()
            builtin.live_grep {
               grep_open_files = true,
               prompt_title = 'Live Grep in Open Files',
            }
         end,
         desc = 'search open files',
      },
   }
end

return {

   {
      -- To open window showing keymaps for current picker,
      --   Insert mode: <c-/>
      --   Normal mode: ?
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
      config = config_telescope,
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
               local telescope = require 'telescope'
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
               local telescope = require 'telescope'
               telescope.load_extension 'lazy'
               telescope.extensions.lazy.lazy()
            end,
            desc = 'telescope lazy',
         },
      },
   },
}
