--[[ Git Signs ]]

local gitsigns_on_attach = function(bufnr)
   local gitsigns = require 'gitsigns'
   local wk = require 'which-key'

   --[[ Navigation ]]

   wk.add {
      {
         [1] = ']c',
         [2] = function()
            if vim.wo.diff then
               -- fall back to nvim when in diff mode
               vim.cmd.normal { ']c', bang = true }
            else
               gitsigns.nav_hunk 'next'
            end
         end,
         desc = 'next git/diff change',
         buffer = bufnr,
      },
      {
         [1] = '[c',
         [2] = function()
            if vim.wo.diff then
               -- fall back to nvim when in diff mode
               vim.cmd.normal { '[c', bang = true }
            else
               gitsigns.nav_hunk 'prev'
            end
         end,
         desc = 'prev git/diff change',
         buffer = bufnr,
      },
   }

   --[[ Actions ]]

   wk.add {
      { '<m-g>', group = 'gitsigns', buffer = bufnr },
      {
         [1] = '<m-g>b',
         [2] = gitsigns.blame_line,
         desc = 'git blame line',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>B',
         [2] = gitsigns.toggle_current_line_blame,
         desc = 'toggle git show blame line',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>i',
         [2] = gitsigns.diffthis,
         desc = 'git diff against index',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>d',
         [2] = function()
            gitsigns.diffthis '@'
         end,
         desc = 'git diff against last commit',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>D',
         [2] = function()
            gitsigns.diffthis '~'
         end,
         desc = 'git diff against commit before last commit',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>s',
         [2] = gitsigns.stage_hunk,
         desc = 'git stage hunk',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>r',
         [2] = gitsigns.reset_hunk,
         desc = 'git reset hunk',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>s',
         [2] = function()
            gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
         end,
         desc = 'git stage hunk',
         mode = { 'v' },
         buffer = bufnr,
      },
      {
         [1] = '<m-g>r',
         [2] = function()
            gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
         end,
         desc = 'git reset hunk',
         mode = { 'v' },
         buffer = bufnr,
      },
      {
         [1] = '<m-g>S',
         [2] = gitsigns.stage_buffer,
         desc = 'git stage buffer',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>R',
         [2] = gitsigns.reset_buffer,
         desc = 'git reset buffer',
         buffer = bufnr,
      },
      {
         [1] = '<m-g>p',
         [2] = gitsigns.preview_hunk,
         desc = 'git preview hunk',
         buffer = bufnr,
      },
   }

   --[[ Text object ]]

   wk.add {
      {
         [1] = '<m-g>h',
         [2] = '<cmd>Gitsigns select_hunk<cr>',
         desc = 'inner hunk',
         mode = { 'n', 'o', 'x' },
         buffer = bufnr,
      },
   }
end

return {
   -- Enables range formatting for all formatters.
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
         formatters_by_ft = require('config.tooling').formatters
      },
   },

   -- Provides GIT info in left gutter, git actions on portions of code.
   {
      [1] = 'lewis6991/gitsigns.nvim',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'folke/which-key.nvim',
      },
      event = 'VeryLazy',
      opts = {
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
      },
   },

   -- Show line indentations when editing code.
   {
      [1] = 'lukas-reineke/indent-blankline.nvim',
      event = 'InsertEnter',
      main = 'ibl',
      opts = {
         indent = { char = '│' },
      },
   },

   -- Quickly jump around window.
   {
      url = 'https://codeberg.org/andyg/leap.nvim',
      event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' }
   },
   {
      -- Colorize color names, hexcodes, and other color formats.
      [1] = 'norcalli/nvim-colorizer.lua',
      keys = {
         {
            [1] = '<leader>C',
            [2] = '<cmd>ColorizerToggle<cr>',
            desc = 'toggle colorizer',
         },
      },
      opts = {
         [1] = '*',
         RRGGBBAA = true,
         rgb_fn = true,
         hsb_fn = true,
         css = { names = false },
         html = { names = false },
         mode = 'background',
      },
   },

   -- On reedit return to last location (configured via config.globals).
   {
      [1] = 'mrcjkb/nvim-lastplace',
      event = 'BufReadPre',
   },

   -- Manipulate matching pairs of symbols.
   {
      [1] = 'kylechui/nvim-surround',
      event = { 'BufReadPre', 'BufNewFile' }
   },

   -- Lints based on what is saved to disk.
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
         require('lint').linters_by_ft = require('config.tooling').linters
      end
   },
}
