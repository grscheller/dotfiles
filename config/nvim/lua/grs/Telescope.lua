--[[ Telescope - fuzzy finder over lists

       Module: grs
       File: ~/.config/nvim/lua/grs/Telescope.lua

  ]]

local ok_telescope, telescope = pcall(require, 'telescope')
if not ok_telescope then
  print('Problem loading telescope.')
  return
end

telescope.setup {
  ['ui-select'] = { require('telescope.themes').get_dropdown {} }
}
telescope.load_extension('ui-select')

-- Setup telescope keybindings
local wk = require('grs.WhichKey')
if wk then
  wk.telescopeKB()
else
  print('Telescope keybindings setup failed')
end
