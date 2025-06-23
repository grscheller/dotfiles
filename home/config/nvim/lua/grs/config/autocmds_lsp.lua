--[[ Text related Autocmds & Usercmds ]]

-- local autogrp = vim.api.nvim_create_augroup
-- local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

--[[ User commands ]]

-- Replacement for nvim-lspconfig version
usercmd('LspInfo', function()
   local clients = vim.lsp.get_clients()
   if #clients == 0 then
      print 'No active LSP clients.'
      return
   end

   for _, client in ipairs(clients) do
      print('Client ID: ' .. client.id .. ', Name: ' .. client.name)
      print('Capabilities: ' .. vim.inspect(client.server_capabilities))
   end
end, {})

--[[ Auto commands related to nvim itself - bow dne by blink.cmp ]]

-- local GrsLspGrp = autogrp('GrsLsp', { clear = true })

-- Builtin autocompletion
-- autocmd('LspAttach', {
--    callback = function(ev)
--       local client = vim.lsp.get_client_by_id(ev.data.client_id)
--       if client:supports_method('textDocument/completion') then
--          vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--       end
--    end,
--    group = GrsLspGrp,
--    desc = 'Use builtin lsp completions',
-- })
