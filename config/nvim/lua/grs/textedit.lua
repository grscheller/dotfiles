--[[ Contains configurations for basic text editing
     and simple general purpose text editing plugins ]]

local ok, comment

local setKM = require('grs.util.keymappings').setKM

--[[ Configure justtinmk/vim-sneak plugin ]]
vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion

setKM('', 'f one char sneak', 'f', '<Plug>Sneak_f')
setKM('', 'F one char sneak', 'F', '<Plug>Sneak_F')
setKM('', 't one char sneak', 't', '<Plug>Sneak_t')
setKM('', 'T one char sneak', 'T', '<Plug>Sneak_T')

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
   print('Problem loading numToStr/Comment.nvim: ' .. comment)
end
