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
     S<Char><Char>  -- like a 2 char F (but multiline)

     Also, set up Sneak based single <char> versions
     of f, F, t, T motion commands.

     For operator pendding motions, use z & Z
     instead of s & S since vim-surround took them   ]]

if wk then
  wk.setupSneakKB()
else
  print('Vim-Sneak keybindings setup failed')
end
