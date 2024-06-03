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

            wk.register({
               c = {
                  function()
                     if vim.wo.diff then
                        -- fall back to nvim when in diff mode
                        vim.cmd.normal { ']c', bang = true }
                     else
                        gitsigns.nav_hunk 'next'
                     end
                  end,
                  'next git/diff change',
               },
            }, { prefix = ']', bufnr = bufnr })

            wk.register({
               c = {
                  function()
                     if vim.wo.diff then
                        -- fall back to nvim when in diff mode
                        vim.cmd.normal { '[c', bang = true }
                     else
                        gitsigns.nav_hunk 'prev'
                     end
                  end,
                  'next git/diff change' },
            }, { prefix = '[', bufnr = bufnr })

            --[[ Actions ]]

            wk.register({
               ['<m-g>']   = { name = 'gitsigns' },
               ['<m-g>t']  = { name = 'gitsigns toggle' },
               ['<m-g>tb'] = { gitsigns.toggle_current_line_blame, 'toggle git show blame line' },
               ['<m-g>tD'] = { gitsigns.toggle_deleted, 'toggle git show deleted' },
               ['<m-g>s']  = { gitsigns.stage_hunk, 'git stage hunk' },
               ['<m-g>r']  = { gitsigns.reset_hunk, 'git reset hunk' },
               ['<m-g>S']  = { gitsigns.stage_buffer, 'git stage buffer' },
               ['<m-g>u']  = { gitsigns.undo_stage_hunk, 'git undo stage hunk' },
               ['<m-g>R']  = { gitsigns.reset_buffer, 'git reset buffer' },
               ['<m-g>p']  = { gitsigns.preview_hunk, 'git preview hunk' },
               ['<m-g>b']  = { gitsigns.blame_line, 'git blame line' },
               ['<m-g>d']  = { gitsigns.diffthis, 'git diff against index' },
               ['<m-g>D']  = {
                  function()
                     gitsigns.diffthis '@'
                  end,
                  'git diff against last commit',
               },
            }, { bufnr = bufnr })

            wk.register({
               ['<m-g>']  = { name = 'gitsigns' },
               ['<m-g>s'] = {
                  function()
                     gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                  end, 'git stage hunk',
               },
               ['<m-g>r'] = {
                  function()
                     gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                  end, 'git reset hunk',
               },
            }, { bufnr = bufnr, mode = 'v' })

            --[[ Text object ]]

            wk.register({
               h  = { '<cmd>Gitsigns select_hunk<cr>', 'inner hunk' },
            }, { prefix = 'i', bufnr = bufnr, mode = 'o' })

            wk.register({
               h  = { '<cmd>Gitsigns select_hunk<cr>', 'inner hunk' },
            }, { prefix = 'i', bufnr = bufnr, mode = 'x' })

         end,
      },
   },
}
