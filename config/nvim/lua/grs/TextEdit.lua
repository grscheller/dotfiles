--[[ Contains configurations for basic text editing
     and simple general purpose text editing plugins.

       Module: grs
       File: ~/.config/nvim/lua/grs/TextEdit.lua

  ]]

local setKM = require('grs.KeyMappings').setKM

--[[ Configure justtinmk/vim-sneak plugin ]]
vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion

setKM('', 'f 1-char sneak', 'f', '<Plug>Sneak_f')
setKM('', 'F 1-char sneak', 'F', '<Plug>Sneak_F')
setKM('', 't 1-char sneak', 't', '<Plug>Sneak_t')
setKM('', 'T 1-char sneak', 'T', '<Plug>Sneak_T')

--[[ Configure numToStr/Comment.nvim ]]
local ok_comment, comment = pcall(require, 'Comment')
if ok_comment then
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
