-- press q to quit :help window
vim.keymap.set('n', 'q', '<cmd>q<cr>', {
   buffer = 0,
   desc = 'Type q to quit :help',
})
-- support highlighted code examples
vim.treesitter.start()
