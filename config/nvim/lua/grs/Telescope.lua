--[[ Telescope - fuzzy finder over lists

       Module: grs
       File: ~/.config/nvim/lua/grs/Telescope.lua

  ]]

local ok_telescope, telescope = pcall(require, 'telescope')
if not ok_telescope then
  print('Problem loading telescope: ' .. telescope)
  return
end

telescope.setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {}
    }
  }
}
telescope.load_extension('ui-select')

--[[ Set Telescope key mappings/bindings ]]

local km = require('grs.KeyMappings')
local tb = require('telescope.builtin')

km.telescope_keybindings(tb)
