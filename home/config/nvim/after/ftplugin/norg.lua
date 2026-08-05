vim.api.nvim_create_autocmd('FileType', {
   pattern = 'norg',
   group = vim.api.nvim_create_augroup('_neorg', {}),
   callback = function(args)
      vim.keymap.set('n', '<leader><leader><cr>', '<Plug>(???)',
         { buffer = args.buf, desc = 'neorg: follow link' })
      vim.keymap.set('n', '<leader><leader><', '<Plug>(neorg.promo.demote.range)',
         { buffer = args.buf, desc = 'neorg: demote range' })
      vim.keymap.set('n', '<leader><leader>>', '<Plug>(neorg.promo.promote.range)',
         { buffer = args.buf, desc = 'neorg: promote range' })
   end,
})
