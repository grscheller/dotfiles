--[[ Enable LSP configs and supporting infrastructure ]]

-- Enable Neovim's native LSP mechanism.
vim.lsp.enable(require('config.tooling').lsp_servers)

-- Setup LSP related keymaps
local km = vim.keymap.set

-- LSP keymaps
km('n', 'H', vim.lsp.buf.hover, { desc = 'hover document' })
km('n', 'K', vim.lsp.buf.signature_help, { desc = 'signature help' })
km('n', '<leader>F', vim.lsp.buf.format, { desc = 'format with LSP' })
km('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'code action' })
km('n', '<leader>cl', vim.lsp.codelens.refresh, { desc = 'code lens refresh' })
km('n', '<leader>cr', vim.lsp.codelens.run, { desc = 'code lens run' })
km('n', 'gD', vim.lsp.buf.declaration, { desc = 'goto type decl' })
km('n', '<leader>r', vim.lsp.buf.rename, { desc = 'rename' })
km('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'add ws folder' })
km('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'rm ws folder' })

km('n', 'gd', function()
   require('telescope.builtin').lsp_definitions()
end, { desc = 'definitions' })

km('n', 'gi', function()
   require('telescope.builtin').lsp_implementations()
end, { desc = 'implementations' })

km('n', 'gr', function()
   require('telescope.builtin').lsp_references()
end, { desc = 'references' })

km('n', '<leader>ds', function()
   require('telescope.builtin').lsp_document_symbols()
end, { desc = 'document symbols' })

km('n', '<leader>ws', function()
   require('telescope.builtin').lsp_dynamic_workspace_symbols()
end, { desc = 'workspace symbols' })

km('n', '<leader>i', function()
   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'toggle inlay hints' })
