--[[ Originally in init.lua ]]

local comment_overrides = {
   opleader = {
      line = 'gc ',
      block = 'gb ',
   },
   extra = {
      above = 'gcO',
      below = 'gco',
      eol = 'gcA',
   },
}

return {
   { 'numToStr/Comment.nvim', opts = comment_overrides },
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
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
         { 'nvim-lua/plenary.nvim' },
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
               return vim.fn.executable 'make' == 1
            end,
         },
         { 'nvim-telescope/telescope-ui-select.nvim' },
         { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
         -- Two important keymaps to use while in Telescope are:
         --    - Insert mode: <c-/>
         --    - Normal mode: ?
         -- This opens a window showing all the keymaps for the current picker.
         require('telescope').setup {
            defaults = {
               mappings = {
                  i = { ['<c-enter>'] = 'to_fuzzy_refine' },
               },
            },
            pickers = {},
            extensions = {
               ['ui-select'] = {
                  require('telescope.themes').get_dropdown(),
               },
            },
         }
         pcall(require('telescope').load_extension, 'fzf')
         pcall(require('telescope').load_extension, 'ui-select')

         -- See `:help telescope.builtin`
         local builtin = require 'telescope.builtin'
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

         -- Slightly advanced example of overriding default behavior and theme
         vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
               winblend = 10,
               previewer = false,
            })
         end, { desc = '[/] Fuzzily search in current buffer' })

         -- It's also possible to pass additional configuration options.
         vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
               grep_open_files = true,
               prompt_title = 'Live Grep in Open Files',
            }
         end, { desc = 'search / in Open Files' })
      end,
   },

   { -- Colorscheme
      'rebelot/kanagawa.nvim',
      lazy = false,
      priority = 1000,
      opts = {
         compile = true,
         undercurl = true,
         colors = {
            theme = {
               dragon = {
                  ui = {
                     bg_dim = '#282727', -- dragonBlack4
                     bg_gutter = '#12120f', -- dragonBlack1
                     bg = '#12120f', -- dragonBlack1
                  },
               },
            },
         },
         overrides = function(colors) -- add/modify highlights
            return {
               ColorColumn = { bg = colors.palette.dragonBlack3 },
            }
         end,
      },
      config = function(_, opts)
         local kanagawa = require 'kanagawa'
         kanagawa.setup(opts)
         kanagawa.compile()
         kanagawa.load 'dragon'
      end,
   },

   { -- Collection of various small independent plugins/modules
      'echasnovski/mini.nvim',
      config = function()
         -- Better Around/Inside textobjects
         --
         -- Examples:
         --  - va)  - [V]isually select [A]round [)]paren
         --  - yinq - [Y]ank [I]nside [N]ext [']quote
         --  - ci'  - [C]hange [I]nside [']quote
         require('mini.ai').setup { n_lines = 500 }
         -- Add/delete/replace surroundings (brackets, quotes, etc.)
         --
         -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
         -- - sd'   - [S]urround [D]elete [']quotes
         -- - sr)'  - [S]urround [R]eplace [)] [']
         require('mini.surround').setup()

         -- Simple and easy statusline.
         --  You could remove this setup call if you don't like it,
         --  and try some other statusline plugin
         local statusline = require 'mini.statusline'
         -- set use_icons to true if you have a Nerd Font
         statusline.setup { use_icons = vim.g.have_nerd_font }

         -- You can configure sections in the statusline by overriding their
         -- default behavior. For example, here we set the section for
         -- cursor location to LINE:COLUMN
         ---@diagnostic disable-next-line: duplicate-set-field
         statusline.section_location = function()
            return '%2l:%-2v'
         end

         -- ... and there is more!
         --  Check out: https://github.com/echasnovski/mini.nvim
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
