--[[ Git Signs ]]

return {
   {
      'lewis6991/gitsigns.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      opts = {
         signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
         },
         on_attach = function(bufnr)
            local gitsigns = require 'gitsigns'

            local function map(mode, l, r, opts)
               opts = opts or {}
               opts.buffer = bufnr
               vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
               if vim.wo.diff then
                  vim.cmd.normal { ']c', bang = true }
               else
                  gitsigns.nav_hunk 'next'
               end
            end, { desc = 'Jump to next git [c]hange' })

            map('n', '[c', function()
               if vim.wo.diff then
                  vim.cmd.normal { '[c', bang = true }
               else
                  gitsigns.nav_hunk 'prev'
               end
            end, { desc = 'Jump to previous git [c]hange' })

            -- Actions
            -- visual mode
            map('x', '<leader>Gs', function()
               gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
            end, { desc = 'stage git hunk' })
            map('x', '<leader>Gr', function()
               gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
            end, { desc = 'reset git hunk' })
            -- normal mode
            map('n', '<leader>Gs', gitsigns.stage_hunk, { desc = 'git stage hunk' })
            map('n', '<leader>Gr', gitsigns.reset_hunk, { desc = 'git reset hunk' })
            map('n', '<leader>GS', gitsigns.stage_buffer, { desc = 'git stage buffer' })
            map('n', '<leader>Gu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
            map('n', '<leader>GR', gitsigns.reset_buffer, { desc = 'git reset buffer' })
            map('n', '<leader>Gp', gitsigns.preview_hunk, { desc = 'git preview hunk' })
            map('n', '<leader>Gb', gitsigns.blame_line, { desc = 'git blame line' })
            map('n', '<leader>Gd', gitsigns.diffthis, { desc = 'git diff against index' })
            map('n', '<leader>GD', function()
               gitsigns.diffthis '@'
            end, { desc = 'git diff against last commit' })
            -- Toggles
            map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'toggle git show blame line' })
            map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = 'toggle git show deleted' })
         end,
      },
   },
}
