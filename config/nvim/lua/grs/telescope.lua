--[[ Telescope - fuzzy finder over lists ]]

local ok, telescope

ok, telescope = pcall(require, 'telescope')
if not ok then
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

-- Set Telescope key mappings/bindings
require('grs.util.keymappings').telescope_keybindings()
