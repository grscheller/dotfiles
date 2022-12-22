--[[ Telescope - search, filter, find & pick items with Lua ]]

local ok, telescope, tb
local msg = require('grs.lib.Vim').msg_hit_return_to_continue

ok, telescope = pcall(require, 'telescope')
if ok then
   tb = require 'telescope.builtin'
else
   msg 'Problem in telescope.lua: telescope failed to load'
   return
end

telescope.setup {
   extensions = {
      file_browser = {},
      frecency = {},
      fzf = {},
      ['ui-select'] = {
         require('telescope.themes').get_dropdown {},
      },
   },
}
telescope.load_extension 'file_browser'
telescope.load_extension 'frecency'
telescope.load_extension 'fzf'
telescope.load_extension 'ui-select'

-- Set Telescope key mappings/bindings
require('grs.conf.keybindings').telescope_kb(telescope, tb)
