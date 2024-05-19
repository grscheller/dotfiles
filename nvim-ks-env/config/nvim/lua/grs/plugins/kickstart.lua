--[[ Originally in init.lua ]]

return {
   {
      'folke/which-key.nvim',
      event = 'VimEnter',
      config = function()
         local wk = require 'which-key'
         local keymaps = require 'grs.config.keymaps'
         wk.setup()
         keymaps.wk_prefixes(wk)
         require('which-key').register({
            ['<leader>c'] = { 'code' },
            ['<leader>d'] = { 'document' },
            ['<leader>r'] = { 'rename' },
            ['<leader>s'] = { 'search' },
            ['<leader>w'] = { 'workspace' },
            ['<leader>t'] = { 'toggle' },
         }, { mode = 'n' })

         require('which-key').register({
            ['<leader>h'] = { 'git hunk' },
         }, { mode = { 'n', 'v' } })
      end,
   },

   {
      -- TODO: Make extensions lazier
      -- Open window showing keymaps for current picker,
         -- Insert mode: <c-/>
         -- Normal mode: ?
      'nvim-telescope/telescope.nvim',
      event = 'VeryLazy',
      dependencies = {
         { 'nvim-lua/plenary.nvim' },
         {
            'nvim-telescope/telescope-file-browser.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' },
         },
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
               return vim.fn.executable 'make' == 1
            end,
         },
         {
            'nvim-telescope/telescope-ui-select.nvim',
            dependencies = {
               {
                  'nvim-tree/nvim-web-devicons',
                  enabled = vim.g.have_nerd_font,
               },
            }
         },
         { "tsakirist/telescope-lazy.nvim" },
      },
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
         telescope.load_extension "file_browser"
         telescope.load_extension 'fzf'
         telescope.load_extension 'lazy'
         telescope.load_extension 'ui-select'

         vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'search help' })
         vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'search kymaps' })
         vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'search files' })
         vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'search select telescope' })
         vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'search current word' })
         vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'search by grep' })
         vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'search diagnostics' })
         vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'search resume' })
         vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'search recent files ("." for repeat)' })
         vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Find existing buffers' })
         vim.keymap.set(
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
         vim.keymap.set(
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

   { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      opts = {
         ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
         -- Autoinstall languages that are not installed
         auto_install = true,
         highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { 'ruby' },
         },
         indent = { enable = true, disable = { 'ruby' } },
      },
      config = function(_, opts)
         -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

         -- Prefer git instead of curl in order to improve connectivity in some environments
         require('nvim-treesitter.install').prefer_git = true
         ---@diagnostic disable-next-line: missing-fields
         require('nvim-treesitter.configs').setup(opts)

         -- There are additional nvim-treesitter modules that you can use to interact
         -- with nvim-treesitter. You should go explore a few and see what interests you:
         --
         --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
         --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
         --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      end,
   },
}
