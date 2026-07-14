--[[ Infrastructure

     - LazyDev ()
     - Telescope (search, filter, find & pick items)
     - Whichkey (make keymaps discoverable)
     - Nvim lastplace (return to last place file was edited)
]]

---@type LazySpec
return {
   -- LazyDev — on-demand lua-language-server enhancement for Neovim dev.
   ---@type LazyPluginSpec
   {
      [1] = 'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
         library = {
            -- libuv bindings, only when the buffer actually references them.
            {
               path = '${3rd}/luv/library',
               words = { 'vim%.uv', 'vim%.loop', 'uv%.' },
            },
            -- lazy.nvim meta types: LazySpec, LazyPluginSpec, LazyKeysSpec, ...
            -- `%u` (uppercase) after `Lazy` avoids matching the lowercase
            -- 'lazydev'/'lazy.nvim' substrings in plugin URLs.
            {
               path = 'lazy.nvim',
               words = { 'Lazy%u%w+' },
            },
         },
      },
   },

   -- When re-editing a file, return to last cursor location line.
   ---@type LazyPluginSpec
   {
      -- Configured via `config/globals.lua`.
      'mrcjkb/nvim-lastplace',
   },

   -- optional blink completion source for require statements and module annotations
   ---@type LazyPluginSpec
   {
      [1] = "saghen/blink.cmp",
      opts = {
         sources = {
            -- add lazydev to your completion providers
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.integrations.blink",
                  -- make lazydev completions top priority (see `:h blink.cmp`)
                  score_offset = 100,
               },
            },
         },
      },
   },

   -- Provides nerd-font eye-candy
   ---@type LazyPluginSpec
   {
      [1] = 'nvim-tree/nvim-web-devicons',
      lazy = true,
      opts = {
         color_icons = true,
         default = true,
         strict = true,
      },
   },


   -- Highly extendable fuzzy finder over lists.
   --   To open window showing keymaps for current picker,
   --     Insert mode: <c-/>
   --     Normal mode: ?
   ---@type LazyPluginSpec
   {
      [1] = 'nvim-telescope/telescope.nvim',
      dependencies = {
         { 'nvim-lua/plenary.nvim' },
         { 'nvim-tree/nvim-web-devicons' },
         { 'nvim-telescope/telescope-ui-select.nvim' },
         {
            [1] = 'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
               return vim.fn.executable 'make' == 1
            end,
         },
      },
      keys = {
         { '<leader>gl', function() require('telescope.builtin').live_grep() end,   desc = 'search by grep' },
         {
            '<leader>go',
            function()
               require('telescope.builtin').live_grep {
                  grep_open_files = true,
                  prompt_title = 'Live Grep in Open Files',
               }
            end,
            desc = 'grep open files',
         },
         {
            '<leader>s/',
            function()
               require('telescope.builtin').current_buffer_fuzzy_find(
                  require('telescope.themes').get_dropdown {
                     winblend = 50,
                     previewer = false,
                  }
               )
            end,
            desc = 'fuzzily search in current buffer',
         },
         { '<leader>s.', function() require('telescope.builtin').oldfiles() end,    desc = 'search recent files' },
         { '<leader>sb', function() require('telescope.builtin').builtin() end,     desc = 'search builtins' },
         { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = 'search diagnostics' },
         { '<leader>sf', function() require('telescope.builtin').find_files() end,  desc = 'search files' },
         { '<leader>sh', function() require('telescope.builtin').help_tags() end,   desc = 'search help' },
         { '<leader>sk', function() require('telescope.builtin').keymaps() end,     desc = 'search keymaps' },
         { '<leader>sr', function() require('telescope.builtin').resume() end,      desc = 'search resume' },
         { '<leader>sw', function() require('telescope.builtin').grep_string() end, desc = 'search current word' },
      },
      config = function()
         local telescope = require 'telescope'
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
               notify = {},
               ['ui-select'] = {
                  themes.get_dropdown {},
               },
            },
            pickers = {},
         }

         telescope.load_extension 'file_browser'
         telescope.load_extension 'fzf'
         telescope.load_extension 'lazy'
         telescope.load_extension 'notify'
         telescope.load_extension 'ui-select'
      end,
   },

   -- File browser extension for telescope. Supports synchronized creation,
   -- deletion, renaming, and moving of files and folders, with LSP integration.
   ---@type LazyPluginSpec
   {
      [1] = 'nvim-telescope/telescope-file-browser.nvim',
      dependencies = { 'nvim-telescope/telescope.nvim' },
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

   -- Telescope extension providing info about lazy.nvim managed plugins.
   ---@type LazyPluginSpec
   {
      [1] = 'tsakirist/telescope-lazy.nvim',
      dependencies = { 'nvim-telescope/telescope.nvim' },
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

   -- Configure builtin treesitter
   ---@type LazyPluginSpec
   {
      [1] = 'nvim-treesitter/nvim-treesitter',
      branch = 'main',
      event = 'VeryLazy',
      config = function()
         -- Install parsers (asynchronous, idempotent)
         require('nvim-treesitter').install(require('config.treesitter').ensure_installed)

         -- Enable treesitter features per-buffer
         vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('_treesitter', {}),
            callback = function(args)
               if pcall(vim.treesitter.start, args.buf) then
                  vim.wo[0][0].foldmethod = 'expr'
                  vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                  vim.bo[args.buf].indentexpr =
                  "v:lua.require'nvim-treesitter'.indentexpr()"
               end
            end,
         })
      end,
   },

   -- Make keymaps discoverable
   ---@type LazyPluginSpec
   {
      [1] = 'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = {
         plugins = {
            spelling = {
               enabled = true,
               suggestions = 36,
            },
         },
         spec = {
            { '<leader>b',  group = 'blackhole' },
            { '<leader>c',  group = 'system clipboard' },
            { '<m-g>',      group = 'gitsigns' },
            { '<leader>m',  group = 'mason' },
            { '<leader>mr', group = 'mason remove' },
            { '<leader>s',  group = 'search' },
            { '<leader>w',  group = 'workspace' },
         },
      },
      keys = function()
         return {
            -- which-key keymap
            {
               '<leader><tab>',
               function()
                  require('which-key').show { global = false }
               end,
               desc = 'Buffer Local Keymaps',
            },

            -- lazy.nvim keymap
            { '<leader>L', '<cmd>Lazy<cr>', desc = 'Lazy gui' },
         }
      end,
   },
}
