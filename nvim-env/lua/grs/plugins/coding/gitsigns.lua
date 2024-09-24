--[[ Git Signs ]]

return {
   {
      'lewis6991/gitsigns.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      event = 'BufReadPre',
      opts = {
         signs = {
            add = { text = '+' },
            change = { text = '│' },
            delete = { text = '∨'},
            topdelete = { text = '∧' },
            changedelete = { text = '⊥' },
            untracked    = { text = '?' },
         },
         on_attach = function(bufnr)
            local gitsigns = require 'gitsigns'
            local wk = require 'which-key'

            --[[ Navigation ]]

            wk.add {
               { ']c',
                  function()
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
               { '[c',
                  function()
                     if vim.wo.diff then
                        -- fall back to nvim when in diff mode
                        vim.cmd.normal { '[c', bang = true }
                     else
                        gitsigns.nav_hunk 'prev'
                     end
                  end,
                  desc = 'next git/diff change',
                  buffer = bufnr
               },
            }

            --[[ Actions ]]

            wk.add {
               { '<m-g>', group = 'gitsigns', buffer = bufnr },
               { '<m-g>b', gitsigns.blame_line, desc = 'git blame line', buffer = bufnr },
               { '<m-g>d', gitsigns.diffthis, desc = 'git diff against index', buffer = bufnr },
               { '<m-g>p', gitsigns.preview_hunk, desc = 'git preview hunk', buffer = bufnr },
               { '<m-g>r', gitsigns.reset_hunk, desc = 'git reset hunk', buffer = bufnr },
               { '<m-g>R', gitsigns.reset_buffer, desc = 'git reset buffer', buffer = bufnr },
               { '<m-g>s', gitsigns.stage_hunk, desc = 'git stage hunk', buffer = bufnr },
               { '<m-g>S', gitsigns.stage_buffer, desc = 'git stage buffer', buffer = bufnr },
               { '<m-g>t', group= 'gitsigns toggle', buffer = bufnr },
               { '<m-g>tb', gitsigns.toggle_current_line_blame, desc = 'toggle git show blame line', buffer = bufnr},
               { '<m-g>tD', gitsigns.toggle_deleted, desc = 'toggle git show deleted', buffer = bufnr },
               { '<m-g>u', gitsigns.undo_stage_hunk, desc = 'git undo stage hunk', buffer = bufnr },
               {
                  '<m-g>D',
                  function()
                     gitsigns.diffthis '@'
                  end,
                  desc = 'git diff against last commit',
                  buffer = bufnr,
               },
               {
                  '<m-g>s',
                  function()
                     gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                  end,
                  desc = 'git stage hunk',
                  mode = {'v'},
                  buffer = bufnr,
               },
               {
                  '<m-g>r',
                  function()
                     gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                  end,
                  desc = 'git reset hunk',
                  mode = {'v'},
                  buffer = bufnr,
               },
            }

            --[[ Text object ]]

            wk.add {
               {
                  '<m-g>h',
                  '<cmd>Gitsigns select_hunk<cr>',
                  desc = 'inner hunk',
                  mode = {'n', 'o', 'x'},
                  buffer = bufnr,
               },
            }
         end,
      },
   },
}
