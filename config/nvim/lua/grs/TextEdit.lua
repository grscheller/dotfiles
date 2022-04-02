--[[ Contains configurations for basic text editing plugins

       Module: grs
       File: ~/.config/nvim/lua/grs/TextEdit.lua

     Text editing plugins installed via Packer:
       tpope/vim-commentary 
       justtinmk/vim-sneak
       tpope/vim-surround
       tpope/vim-repeat     ]]

local wk = require('grs.WhichKey')

--[[ Vim Sneak - 2 chaacter, multiline version of f & t

     s<Char><Char>  -- like a 2 char f (but multiline)
     S<Char><Char>  -- like a 2 char F (but multiline)

     Also, set up Sneak based single <char> versions
     of f, F, t, T motion commands.

     For operator pendding motions, use z & Z
     instead of s & S since vim-surround took them   ]]

if wk then
  wk.sneakKB()
else
  print('Vim-Sneak key binding setup failed')
end

--[[ Vim Surround - manipulate matching surrounding symbols

     I. In normal mode,

       ds"  -- "foo bar" -> foo bar
       ds(  -- foo({ foo = bar, num = 42 }) -> foo{ foo = bar, num = 42 }
       dst  -- delete surrounding HTML tags
       cs'[ -- 'hello 42' -> [ hello 42 ]
       cs'] -- 'hello 42' -> [hello 42]

     In an html filetype:
       cst<p> -- <title>My homepage</title> -> <p>My homepage</p>

     Cursor is on the 'r'
       ysiw) -- Hello world -> Hello (world)

     Can act on ebtire line after initial whitespace - 
       yss{ -- printf("Hello World\n") -> { printf("Hello World\n") }
       ySS{ -- printf("Hello World\n") -> {
                                            printf("Hello World\n")
                                          }
     II, In insert mode, where | means cursor,

       foo = bar<C-S>( -> foo = bar( | )
       foo<C-G>s( -> foo( | )
       do <C-G>S{ -> do {
                       |
                     }

     III, In visual mode, 

       S"  -- wrap visual selection in "
       gS{ -- wrap selection across multiple lines in {
  ]]

--[[ Vim Repeat - allows opted in plugins to repeat actions via . ]]

