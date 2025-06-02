vim.lsp.enable {
   'bashls',
   'html',
   'lua_ls',
}

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
