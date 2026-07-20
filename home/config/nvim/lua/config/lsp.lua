--[[ Enable LSP configs and supporting infrastructure ]]

-- Add configurations to all clients
vim.lsp.config('*', {
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
km('n', ';h', vim.lsp.buf.hover, { desc = 'hover document' })
km('n', ';k', vim.lsp.buf.signature_help, { desc = 'signature help' })
km('n', ';f', vim.lsp.buf.format, { desc = 'format with LSP' })
km('n', ';ca', vim.lsp.buf.code_action, { desc = 'code action' })
km('n', ';cl', function()
   vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled(), { bufnr = 0 })
end, { desc = 'toggle code lens' })
km('n', ';cr', vim.lsp.codelens.run, { desc = 'code lens run' })
km('n', ';gD', vim.lsp.buf.declaration, { desc = 'goto declaration' })
km('n', ';gT', vim.lsp.buf.type_definition, { desc = 'goto type definition' })
km('n', ';r', vim.lsp.buf.rename, { desc = 'rename' })
km('n', ';wa', vim.lsp.buf.add_workspace_folder, { desc = 'add ws folder' })
km('n', ';wr', vim.lsp.buf.remove_workspace_folder, { desc = 'rm ws folder' })

-- LSP Keymaps with telescope integration
km('n', ';gd', function()
   require('telescope.builtin').lsp_definitions()
end, { desc = 'definitions' })

km('n', ';gi', function()
   require('telescope.builtin').lsp_implementations()
end, { desc = 'implementations' })

km('n', ';gr', function()
   require('telescope.builtin').lsp_references()
end, { desc = 'references' })

km('n', ';ds', function()
   require('telescope.builtin').lsp_document_symbols()
end, { desc = 'document symbols' })

km('n', ';ws', function()
   require('telescope.builtin').lsp_dynamic_workspace_symbols()
end, { desc = 'workspace symbols' })

km('n', ';ih', function()
   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'toggle inlay hints' })

-- LSP user command to replace one lost from nvim-lspconfig
vim.api.nvim_create_user_command('LspInfo', function()
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

-- Auto-refresh code lens when a capable server attaches
vim.api.nvim_create_autocmd('LspAttach', {
   group = vim.api.nvim_create_augroup('lsp-codelens', { clear = true }),
   callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client:supports_method 'textDocument/codeLens' then
         vim.lsp.codelens.enable(true, { bufnr = args.buf })
      end
   end,
})
