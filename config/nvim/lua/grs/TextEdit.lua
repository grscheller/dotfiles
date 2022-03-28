--[[ Contains configurations for basic text editting plugins

       Module: grs
       File: ~/.config/nvim/lua/grs/TextEdit.lua

     Text editing plugins installed via Packer:
       tpope/vim-commentary 
       tpope/vim-surround
       tpope/vim-repeat
       justtinmk/vim-sneak
  ]]

local wk = require('grs.WhichKey')

--[[ Vim-Sneak
       s<Char><Char>  -- like a 2 char f (but multiline)
       S<Char><Char>  -- like a 2 char F 
       f<Char>  -- Replace these with
       F<Char>  -- one char sneak,
       t<Char>  -- but without using
       T<Char>  -- label-mode (poor man's EasyMotion)   ]]
if wk then
  wk.setupSneakKB()
else
  print('Vim-Sneak keybindings setup failed')
end
