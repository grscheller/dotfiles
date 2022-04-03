--[[ Contains configurations for basic text editing
     and simple general purpose plugins.

       Module: grs
       File: ~/.config/nvim/lua/grs/TextEdit.lua

  ]]

local wk = require('grs.WhichKey')

-- Configure justtinmk/vim-sneak plugin
if wk then
  wk.sneakKB()
else
  print('Vim-Sneak key binding setup failed')
end
