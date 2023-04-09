-- open :help in vertical window
vim.api.nvim_cmd({ cmd = 'wincmd', args = { 'L' } }, {})
-- press q to quit :help window
vim.keymap.set('n', 'q', '<cmd>q<cr>', {
   buffer = 0,
   desc = 'Type q to quit :help',
})
