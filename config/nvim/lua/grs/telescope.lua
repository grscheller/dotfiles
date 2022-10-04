--[[ Telescope - fuzzy finder over lists ]]

local ok, telescope = pcall(require, 'telescope')
if not ok then
   print('Problem loading telescope: %s', telescope)
   return
end

telescope.setup {
   extensions = {
      ['ui-select'] = {
         require('telescope.themes').get_dropdown {}
      },
      file_browser = {},
      frecency = {},
      fzf = {}
   }
}
telescope.load_extension('ui-select')
telescope.load_extension('file_browser')
telescope.load_extension('frecency')
telescope.load_extension('fzf')

-- Set Telescope key mappings/bindings
require('grs.util.keybindings').telescope_kb()
