--[[ Enable LSP configs and supporting infrastructure ]]

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local GrsLspGrp = autogrp('GrsLsp', { clear = true })

-- Enable Neovim built in completions - Why just for LSP? Not an nvim-cmp replacement.
autocmd('LspAttach', {
   callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client:supports_method('textDocument/completion') then
         vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
   end,
   group = GrsLspGrp,
   desc = 'Keep ftplugins from overriding my formatoptions',
})

-- Configure diagnostics
vim.diagnostic.config {
   virtual_text = true, -- virtual text sometimes gets in the way
   underline = false,  -- set to true if virtual text is false
   update_in_insert = false,
   severity_sort = true,
   float = {
      border = "rounded",
      source = true,
   },
   signs = true,
}

-- Enable these LSP servers configured in ~/.config/nvim/lsp
vim.lsp.enable {
   'bashls',
   'html',
   'lua_ls',
}
