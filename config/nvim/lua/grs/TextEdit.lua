--[[ Contains configurations for basic text editing
     and simple general purpose text editing plugins.

       Module: grs
       File: ~/.config/nvim/lua/grs/TextEdit.lua

  ]]

-- Configure justtinmk/vim-sneak plugin
vim.g['sneak#label'] = 1  -- minimalist alternative to EasyMotion

-- Set Telescope key mappings/bindings
local sk = vim.api.nvim_set_keymap
sk('', 'f', '<Plug>Sneak_f', { desc = 'f 1-character sneak' })
sk('', 'F', '<Plug>Sneak_F', { desc = 'F 1-character sneak' })
sk('', 't', '<Plug>Sneak_t', { desc = 't 1-character sneak' })
sk('', 'T', '<Plug>Sneak_T', { desc = 'T 1-character sneak' })
