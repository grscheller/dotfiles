--[[ Configure vim.diagnostics ]]

vim.diagnostic.config {
   virtual_lines = { current_line = true },
   virtual_text = false,
   underline = false,
   severity_sort = true,
   update_in_insert = false,
   signs = true,
}

vim.keymap.set('n', '<leader>vl', function()
   local current_vl = vim.diagnostic.config().virtual_lines
   if type(current_vl) == 'table' and current_vl.current_line then
      vim.diagnostic.config {
         virtual_lines = false,
         underline = true,
      }
   else
      vim.diagnostic.config {
         virtual_lines = { current_line = true },
         underline = false,
      }
   end
end)
