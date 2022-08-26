--[[ Contains configurations for basic text editing
     and simple general purpose text editing plugins ]]

local ok, comment

--[[ Configure justtinmk/vim-sneak plugin ]]
vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion

vim.keymap.set({'n', 'v'}, 'f', '<Plug>Sneak_f', {desc = 'f one char sneak'})
vim.keymap.set({'n', 'v'}, 'F', '<Plug>Sneak_F', {desc = 'F one char sneak'})
vim.keymap.set({'n', 'v'}, 't', '<Plug>Sneak_t', {desc = 't one char sneak'})
vim.keymap.set({'n', 'v'}, 'T', '<Plug>Sneak_T', {desc = 'T one char sneak'})

--[[ Configure numToStr/Comment.nvim ]]
ok, comment = pcall(require, 'Comment')
if ok then
   comment.setup {
      ignore = '^$',
      mappings = {
         basic = true,
         extra = true,
         extended = true
      }
   }
else
   print('Problem loading numToStr/Comment.nvim: %s', comment)
end
