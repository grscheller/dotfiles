--[[ Development tools
-
     - Git Signs
     - Linters
     - Formatters
]]

local gitsigns_on_attach = function(bufnr)
   local km = vim.keymap.set

   km('n', ']h', function()
      require('gitsigns').nav_hunk 'next'
   end, {
      desc = 'git next hunk',
      buffer = bufnr,
   })

   km('n', '[h', function()
      require('gitsigns').nav_hunk 'prev'
   end, {
      desc = 'git prev hunk',
      buffer = bufnr,
   })

   -- Actions
   km('n', '<m-g>b', function()
      require('gitsigns').blame_line()
   end, {
      desc = 'git blame line',
      buffer = bufnr,
   })

   km('n', '<m-g>B', function()
      require('gitsigns').toggle_current_line_blame()
   end, {
      desc = 'git toggle show blame',
      buffer = bufnr,
   })

   km('n', '<m-g>i', function()
      require('gitsigns').diffthis()
   end, {
      desc = 'git diff against index',
      buffer = bufnr,
   })

   km('n', '<m-g>d', function()
      require('gitsigns').diffthis '@'
   end, {
      desc = 'git diff against last commit',
      buffer = bufnr,
   })

   km('n', '<m-g>D', function()
      require('gitsigns').diffthis '~'
   end, {
      desc = 'git diff against commit before last commit',
      buffer = bufnr,
   })

   km('n', '<m-g>s', function()
      require('gitsigns').stage_hunk()
   end, {
      desc = 'git stage hunk',
      buffer = bufnr,
   })

   km('n', '<m-g>r', function()
      require('gitsigns').reset_hunk()
   end, {
      desc = 'git reset hunk',
      buffer = bufnr,
   })

   km('v', '<m-g>s', function()
      require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
   end, {
      desc = 'git stage hunk',
      buffer = bufnr,
   })

   km('v', '<m-g>r', function()
      require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
   end, {
      desc = 'git reset hunk',
      buffer = bufnr,
   })

   km('n', '<m-g>S', function()
      require('gitsigns').stage_buffer()
   end, {
      desc = 'git stage buffer',
      buffer = bufnr,
   })

   km('n', '<m-g>R', function()
      require('gitsigns').reset_buffer()
   end, {
      desc = 'git reset buffer',
      buffer = bufnr,
   })

   km('n', '<m-g>p', function()
      require('gitsigns').preview_hunk()
   end, {
      desc = 'git preview hunk',
      buffer = bufnr,
   })

   -- Text object
   km({ 'n', 'o', 'x' }, '<m-g>h', '<cmd>Gitsigns select_hunk<cr>', {
      desc = 'git inner hunk',
      buffer = bufnr,
   })
end

local gitsigns_opts = {
   signs = {
      add = { text = '+' },
      change = { text = '│' },
      delete = { text = '∨' },
      topdelete = { text = '∧' },
      changedelete = { text = '⊥' },
      untracked = { text = '┆' },
   },
   signs_staged = {
      add = { text = '+' },
      change = { text = '│' },
      delete = { text = '∨' },
      topdelete = { text = '∧' },
      changedelete = { text = '⊥' },
   },
   on_attach = gitsigns_on_attach,
}

---@type LazySpec
return {
   -- Provides GIT info in left gutter, git actions on portions of code.
   ---@type LazyPluginSpec
   {
      [1] = 'lewis6991/gitsigns.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      event = 'VeryLazy',
      opts = gitsigns_opts,
   },

   -- Lints based on what is saved to disk.
   ---@type LazyPluginSpec
   {
      [1] = 'mfussenegger/nvim-lint',
      keys = {
         {
            [1] = '<leader>l',
            [2] = function()
               require('lint').try_lint()
            end,
            mode = 'n',
            desc = 'lint (nvim-lint)',
         },
      },
      config = function()
         require('lint').linters_by_ft =
            require('config.tooling').linters
      end,
   },

   -- Enables range formatting for all formatters.
   ---@type LazyPluginSpec
   {
      [1] = 'stevearc/conform.nvim',
      keys = {
         {
            [1] = '<leader>f',
            [2] = function()
               require('conform').format {
                  async = false,
                  timeout_ms = 2000,
               }
            end,
            mode = 'n',
            desc = 'format (conform)',
         },
      },
      opts = {
         formatters_by_ft = require('config.tooling').formatters,
      },
   },
}
