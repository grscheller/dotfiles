--[[ Telescope - fuzzy finder over lists ]]

local ok, ts, tb

ok, ts = pcall(require, 'telescope')
if ok then
   tb = require('telescope.builtin')
else
   return
end

ts.setup { extensions = {
   file_browser = {},
   frecency = {},
   fzf = {},
   ['ui-select'] = {
      require('telescope.themes').get_dropdown {}
   }
}}
ts.load_extension('ui-select')
ts.load_extension('file_browser')
ts.load_extension('frecency')
ts.load_extension('fzf')

-- Set Telescope key mappings/bindings
require('grs.util.keybindings').telescope_kb(ts, tb)
