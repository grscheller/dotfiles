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
   end
end, {})
