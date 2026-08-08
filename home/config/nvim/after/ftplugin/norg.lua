-- after/ftplugin/norg.lua

vim.opt_local.concealcursor = 'nc'
vim.opt_local.conceallevel = 2

vim.keymap.set('n', '<M-,>', '<Plug>(neorg.promo.demote.range)',
   { buffer = true, remap = true, desc = 'neorg: demote range' })
vim.keymap.set('n', '<M-.>', '<Plug>(neorg.promo.promote.range)',
   { buffer = true, remap = true, desc = 'neorg: promote range' })
vim.keymap.set('n', '<CR>', '<Plug>(neorg.esupports.hop.hop-link)',
   { buffer = true, remap = true, desc = 'neorg: follow link' })
