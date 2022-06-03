--[[ Contains configurations for basic text editing
     and simple general purpose text editing plugins.

       Module: grs
       File: ~/.config/nvim/lua/grs/TextEdit.lua

  ]]

local kb = require('grs.KeyMappings')

--[[ Configure justtinmk/vim-sneak plugin ]]

vim.g['sneak#label'] = 1  -- minimalist alternative to EasyMotion

if kb then
  local sneak_mappings = {
    f = { '<Plug>Sneak_f', 'f 1-char sneak' },
    F = { '<Plug>Sneak_F', 'F 1-char sneak' },
    t = { '<Plug>Sneak_t', 't 1-char sneak' },
    T = { '<Plug>Sneak_T', 'T 1-char sneak' }
  }
  kb.wk.register(sneak_mappings, { })
  kb.wk.register(sneak_mappings, { mode = 'x' })
  kb.wk.register(sneak_mappings, { mode = 'o' })
else
  print('Vim-Sneak "fFtT" key bindings setup failed')
end
