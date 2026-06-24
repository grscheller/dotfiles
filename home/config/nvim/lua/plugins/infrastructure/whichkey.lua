--[[ Needed by multiple plugins or important to infrastructure ]]

return {
   {
      -- Makes keymaps discoverable.
      'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = {
         plugins = {
            spelling = {
               enabled = true,
               suggestions = 36,
            },
         },
      },
      keys = function()
         local tb = require 'telescope.builtin'

         return {

            --[[ Which Key related ]]

            {
               '<leader>?',
               function()
                  require('which-key').show { global = false }
               end,
               desc = 'Buffer Local Keymaps (which-key)',
            },

            --[[ LSP keymaps ]]

            {
               'H',
               vim.lsp.buf.hover,
               desc = 'hover document',
            },
            {
               'K',
               vim.lsp.buf.signature_help,
               desc = 'signature help',
            },
            {
               '<leader>F',
               vim.lsp.buf.format,
               desc = 'format with LSP',
            },
            {
               '<leader>ca',
               vim.lsp.buf.code_action,
               desc = 'code action',
            },
            {
               '<leader>cl',
               vim.lsp.codelens.refresh,
               desc = 'code lens refresh',
            },
            {
               '<leader>cr',
               vim.lsp.codelens.run,
               desc = 'code lens run',
            },
            {
               'gd',
               tb.lsp_definitions,
               desc = 'definitions',
            },
            {
               'gD',
               vim.lsp.buf.declaration,
               desc = 'goto type decl',
            },
            {
               'gi',
               tb.lsp_implementations,
               desc = 'implementations',
            },
            {
               'gr',
               tb.lsp_references,
               desc = 'references',
            },
            {
               '<leader>r',
               vim.lsp.buf.rename,
               desc = 'rename',
            },
            {
               '<leader>ds',
               tb.lsp_document_symbols,
               desc = 'document symbols',
            },
            {
               '<leader>ws',
               tb.lsp_dynamic_workspace_symbols,
               desc = 'workspace symbols',
            },
            {
               '<leader>wa',
               vim.lsp.buf.add_workspace_folder,
               desc = 'add ws folder',
            },
            {
               '<leader>wr',
               vim.lsp.buf.remove_workspace_folder,
               desc = 'rm ws folder',
            },
            {
               '<leader>i',
               function()
                  vim.lsp.inlay_hint.enable(
                     not vim.lsp.inlay_hint.is_enabled()
                  )
               end,
               desc = 'toggle inlay hints',
            },

            --[[ Plugin keymaps ]]

            {
               'yp',
               '<Plug>(nvim-surround-normal)',
               desc = 'Add surrounding pair around a motion',
            },
            {
               'ypp',
               '<Plug>(nvim-surround-normal-cur)',
               desc = 'Add surrounding pair around current line',
            },
            {
               'yP',
               '<Plug>(nvim-surround-normal-line)',
               desc = 'Add surrounding pair around a motion, on new lines',
            },
            {
               'yPP',
               '<Plug>(nvim-surround-normal-cur-line)',
               desc = 'Add surrounding pair around the current line, on new lines',
            },
            {
               'dp',
               '<Plug>(nvim-surround-delete)',
               desc = 'Delete surrounding pair',
            },
            {
               'cp',
               '<Plug>(nvim-surround-change)',
               desc = 'Change surrounding pair',
            },
            {
               'cP',
               '<Plug>(nvim-surround-change-line)',
               desc = 'Change surrounding pair, putting replacements on new lines',
            },
            {
               'P',
               '<Plug>(nvim-surround-visual)',
               mode = 'x',
               desc = 'Add surrounding pair around a visual selection',
            },
            {
               'gP',
               '<Plug>(nvim-surround-visual-line)',
               mode = 'x',
               desc = 'Add surrounding pair around a visual selection, on new lines',
            },

            --[[ Plugin command keymaps ]]

            { '<leader>L', '<cmd>Lazy<cr>', desc = 'Lazy gui' },
            { '<leader>M', '<cmd>Mason<cr>', desc = 'Mason gui' },

            --[[ DAP & Diagnostic related ]]
         }
      end,
   },
}
