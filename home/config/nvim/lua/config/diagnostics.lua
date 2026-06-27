--[[ Configure vim.diagnostics ]]

local km = vim.keymap.set

vim.diagnostic.config {
   virtual_lines = { current_line = true },
   virtual_text = false,
   underline = true,
   severity_sort = true,
   update_in_insert = false,
   signs = true,
}

km('n', '<bslash>q', vim.diagnostic.setloclist, { desc = 'open qf' })
km('n', '<bslash>c', vim.cmd.lclose, { desc = 'close qf' })
km('n', '<bslash>h', vim.diagnostic.hide, { desc = 'hide diagnostics' })
km('n', '<bslash>s', vim.diagnostic.show, { desc = 'show diagnostics' })

km('n', '<bslash>[', function()
   vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'prev diagnostic' })

km('n', '<bslash>]', function()
   vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'next diagnostic' })

km('n', '<bslash>v', function()
   local current_vl = vim.diagnostic.config().virtual_lines
   if type(current_vl) == 'table' and current_vl.current_line then
      vim.diagnostic.config {
         virtual_lines = false,
      }
   else
      vim.diagnostic.config {
         virtual_lines = { current_line = true }
      }
   end
end, { desc ='toggle diagnostics virtual_lines' })
