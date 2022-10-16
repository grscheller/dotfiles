--[[ Telescope - fuzzy finder over lists ]]

local ok, telescope = pcall(require, 'telescope')
if not ok then
   return
end

telescope.setup { extensions = {
   file_browser = {},
   frecency = {},
   fzf = {},
   ['ui-select'] = {
      require('telescope.themes').get_dropdown {}
   }
}}
telescope.load_extension('ui-select')
telescope.load_extension('file_browser')
telescope.load_extension('frecency')
telescope.load_extension('fzf')

-- Set Telescope key mappings/bindings
require('grs.util.keybindings').telescope_kb()
