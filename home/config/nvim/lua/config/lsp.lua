--[[ LSP keymaps, commands & autocmds -- required after `core.lazy`

     Split out from `core.lsp`, establishes client capabilities and
     must run before lazy.nvim. Everything here either depends on
     a plugin being present (telescope) or benefits from being
     defined last so it wins any keymap collision.

     The `;` prefix is the LSP prefix; which-key group labels for it
     are declared in `plugins/infrastructure.lua`.
]]

local km = vim.keymap.set

--[[ LSP keymaps ]]

km('n', ';h', vim.lsp.buf.hover, { desc = 'hover document' })
km('n', ';k', vim.lsp.buf.signature_help, { desc = 'signature help' })
km('n', ';f', vim.lsp.buf.format, { desc = 'format with LSP' })
km('n', ';r', vim.lsp.buf.rename, { desc = 'rename' })
km('n', ';ca', vim.lsp.buf.code_action, { desc = 'code action' })
km('n', ';cl', function()
   vim.lsp.codelens.enable(
      not vim.lsp.codelens.is_enabled(),
      { bufnr = 0 }
   )
end, { desc = 'toggle code lens' })
km('n', ';cr', vim.lsp.codelens.run, { desc = 'code lens run' })
km('n', ';gD', vim.lsp.buf.declaration, { desc = 'declaration' })
km('n', ';gT', vim.lsp.buf.type_definition, { desc = 'type definition' })
km('n', ';wa', vim.lsp.buf.add_workspace_folder, { desc = 'add ws folder' })
km('n', ';wr', vim.lsp.buf.remove_workspace_folder, { desc = 'rm ws folder' })

km('n', ';ih', function()
   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'toggle inlay hints' })

--[[ LSP keymaps with telescope integration ]]

km('n', ';gd', function()
   require('telescope.builtin').lsp_definitions()
end, { desc = 'definitions' })

km('n', ';gi', function()
   require('telescope.builtin').lsp_implementations()
end, { desc = 'implementations' })

km('n', ';gr', function()
   require('telescope.builtin').lsp_references()
end, { desc = 'references' })

km('n', ';sd', function()
   require('telescope.builtin').lsp_document_symbols()
end, { desc = 'document symbols' })

km('n', ';sw', function()
   require('telescope.builtin').lsp_dynamic_workspace_symbols()
end, { desc = 'workspace symbols' })

--[[ User commands ]]

-- Replaces the `:LspInfo` lost when nvim-lspconfig was dropped.
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
