--[[ Needed by multiple plugins or important to infrastructure ]]

return {
   {
      -- Makes keymaps discoverable.
      [1] = 'folke/which-key.nvim',
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
         return {
            -- which-key keymaps
            {
               '<leader>?',
               function()
                  require('which-key').show { global = false }
               end,
               desc = 'Buffer Local Keymaps (which-key)',
            },

            -- lazy.nvim keymaps
            { '<leader>L', '<cmd>Lazy<cr>', desc = 'Lazy gui' },

            -- LSP keymaps
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
               function()
                  require('telescope.builtin').lsp_definitions()
               end,
               desc = 'definitions',
            },
            {
               'gD',
               vim.lsp.buf.declaration,
               desc = 'goto type decl',
            },
            {
               'gi',
               function()
                  require('telescope.builtin').lsp_implementations()
               end,
               desc = 'implementations',
            },
            {
               'gr',
               function()
                  require('telescope.builtin').lsp_references()
               end,
               desc = 'references',
            },
            {
               '<leader>r',
               vim.lsp.buf.rename,
               desc = 'rename',
            },
            {
               '<leader>ds',
               function()
                  require('telescope.builtin').lsp_document_symbols()
               end,
               desc = 'document symbols',
            },
            {
               '<leader>ws',
               function()
                  require('telescope.builtin').lsp_dynamic_workspace_symbols()
               end,
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
         }
      end,
   },
}
