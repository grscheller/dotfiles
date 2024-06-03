--[[ Git Signs ]]

return {
   {
      'lewis6991/gitsigns.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      opts = {
         signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '∨'},
            topdelete = { text = '∧' },
            changedelete = { text = '⊤' },
            untracked    = { text = '┆' },
         },
         on_attach = function(bufnr)
            local gitsigns = require 'gitsigns'

            local function map(mode, l, r, opts)
               opts = opts or {}
               opts.buffer = bufnr
               vim.keymap.set(mode, l, r, opts)
            end

            --[[ Navigation ]]

            map('n', ']c', function()
               if vim.wo.diff then
                  -- fall back to nvim when in diff mode
                  vim.cmd.normal { ']c', bang = true }
               else
                  gitsigns.nav_hunk 'next'
               end
            end, { desc = 'next change' })

            map('n', '[c', function()
               if vim.wo.diff then
                  -- fall back to nvim when in diff mode
                  vim.cmd.normal { '[c', bang = true }
               else
                  gitsigns.nav_hunk 'prev'
               end
            end, { desc = 'previous change' })

            --[[ Actions ]]

            -- visual mode
            map('v', '<m-g>s', function()
               gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
            end, { desc = 'stage git hunk' })
            map('v', '<m-g>r', function()
               gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
            end, { desc = 'reset git hunk' })

            -- normal mode
            map('n', '<m-g>s', gitsigns.stage_hunk, { desc = 'git stage hunk' })
            map('n', '<m-g>r', gitsigns.reset_hunk, { desc = 'git reset hunk' })
            map('n', '<m-g>S', gitsigns.stage_buffer, { desc = 'git stage buffer' })
            map('n', '<m-g>u', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
            map('n', '<m-g>R', gitsigns.reset_buffer, { desc = 'git reset buffer' })
            map('n', '<m-g>p', gitsigns.preview_hunk, { desc = 'git preview hunk' })
            map('n', '<m-g>b', gitsigns.blame_line, { desc = 'git blame line' })
            map('n', '<m-g>d', gitsigns.diffthis, { desc = 'git diff against index' })
            map('n', '<m-g>D', function() gitsigns.diffthis '@' end, { desc = 'git diff against last commit' })

            -- Toggles
            map('n', '<m-g>tb', gitsigns.toggle_current_line_blame, { desc = 'toggle git show blame line' })
            map('n', '<m-g>tD', gitsigns.toggle_deleted, { desc = 'toggle git show deleted' })
         end,
      },
   },
}
