--[[ Enable LSP configs and supporting infrastructure ]]

-- Add configurations to all clients
vim.lsp.config('*', {
   root_markers = { '.git' },
   capabilities = {
      workspace = {
         didChangeWatchedFiles = {
            dynamicRegistration = true,
         },
      },
      textDocument = {
         semanticTokens = {
            multilineTokenSupport = true,
         },
      },
   },
})

-- Enable Neovim's native LSP mechanism.
vim.lsp.enable(require('config.tooling').lsp_servers_nvim)

-- Setup LSP related keymaps
local km = vim.keymap.set

-- LSP keymaps
km('n', 'H', vim.lsp.buf.hover, { desc = 'hover document' })
km('n', 'K', vim.lsp.buf.signature_help, { desc = 'signature help' })
km('n', '<leader>F', vim.lsp.buf.format, { desc = 'format with LSP' })
km('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'code action' })
km(
   'n',
   '<leader>cl',
   function()
      vim.lsp.codelens.enable(true)
   end,
   { desc = 'code lens enable' }
)
km('n', '<leader>cr', vim.lsp.codelens.run, { desc = 'code lens run' })
km('n', 'gD', vim.lsp.buf.declaration, { desc = 'goto type decl' })
km('n', '<leader>r', vim.lsp.buf.rename, { desc = 'rename' })
km(
   'n',
   '<leader>wa',
   vim.lsp.buf.add_workspace_folder,
   { desc = 'add ws folder' }
)
km(
   'n',
   '<leader>wr',
   vim.lsp.buf.remove_workspace_folder,
   { desc = 'rm ws folder' }
)

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

-- LSP related user commands
local usercmd = vim.api.nvim_create_user_command

usercmd('LspInfo', function()
   local clients = vim.lsp.get_clients()
   if #clients == 0 then
      vim.notify 'No active LSP clients.'
      return
   end
   for _, client in ipairs(clients) do
      vim.notify(
         'Client ID: ' .. client.id .. ', Name: ' .. client.name
      )
   end
end, {})

-- LSP related auto commands
local autocmd = vim.api.nvim_create_autocmd

autocmd('User', {
   pattern = 'MasonToolsStartingInstall',
   callback = function()
      vim.schedule(function()
         vim.notify 'mason-tool-installer (starting)'
      end)
   end,
})

autocmd('User', {
   pattern = 'MasonToolsUpdateCompleted',
   callback = function(e)
      vim.schedule(function()
         vim.notify(
            'mason-tool-installer (finished): ' .. vim.inspect(e.data)
         )
      end)
   end,
})
