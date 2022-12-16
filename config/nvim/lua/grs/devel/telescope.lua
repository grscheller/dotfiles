--[[ Telescope - search, filter, find & pick items with Lua ]]

local ok, ts, tb
local msg = require('grs.lib.Vim').msg_hit_return_to_continue

ok, ts = pcall(require, 'telescope')
if ok then
   tb = require 'telescope.builtin'
else
   msg 'Problem in telescope.lua: telescope failed to load'
   return
end

ts.setup {
   extensions = {
      file_browser = {},
      frecency = {},
      fzf = {},
      ['ui-select'] = {
         require('telescope.themes').get_dropdown {},
      },
   },
}
ts.load_extension 'file_browser'
ts.load_extension 'frecency'
ts.load_extension 'fzf'
ts.load_extension 'ui-select'

-- Set Telescope key mappings/bindings
require('grs.conf.keybindings').telescope_kb(ts, tb)
