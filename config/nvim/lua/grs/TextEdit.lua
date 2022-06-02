--[[ Contains configurations for basic text editing
     and simple general purpose text editing plugins.

       Module: grs
       File: ~/.config/nvim/lua/grs/TextEdit.lua

  ]]

-- Using folke/which-key.nvim eo manage key mappings
local whichkey, wk
whichkey = require('grs.WhichKey')
if whichkey then
  wk = whichkey.wk
end

-- Configure justtinmk/vim-sneak plugin
--
vim.g['sneak#label'] = 1  -- minimalist alternative to EasyMotion

if whichkey then
  local sneak_mappings = {
    f = { '<Plug>Sneak_f', 'f 1-char sneak' },
    F = { '<Plug>Sneak_F', 'F 1-char sneak' },
    t = { '<Plug>Sneak_t', 't 1-char sneak' },
    T = { '<Plug>Sneak_T', 'T 1-char sneak' }
  }
  wk.register(sneak_mappings, { })
  wk.register(sneak_mappings, { mode = 'x' })
  wk.register(sneak_mappings, { mode = 'o' })
else
  print('Vim-Sneak "fFtT" key bindings setup failed')
end
