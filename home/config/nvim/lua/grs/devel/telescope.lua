--[[ Telescope - search, filter, find & pick items with Lua ]]

local msg = require('grs.lib.Vim').msg_hit_return_to_continue
local ok, telescope, tb

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

-- Telescope related keybindings

local keymaps = require('grs.conf.keybindings')
local wk = keymaps.wk
local kb = keymaps.kb

if wk then
   wk.register({ name = 'telescope' }, { prefix = ' t' })
end

-- Telescope built-ins
local tb_td = tb.grep_string
local tb_tf = tb.find_files
local tb_tg = tb.live_grep
local tb_th = tb.help_tags
local tb_tl = tb.buffers
local tb_tr = tb.oldfiles
local tb_tz = tb.current_buffer_fuzzy_find

kb('n', ' td', tb_td, { desc = 'grep files curr dir' })
kb('n', ' tf', tb_tf, { desc = 'find files' })
kb('n', ' tg', tb_tg, { desc = 'grep content files' })
kb('n', ' th', tb_th, { desc = 'help tags' })
kb('n', ' tl', tb_tl, { desc = 'list buffers' })
kb('n', ' tr', tb_tr, { desc = 'find recent files' })
kb('n', ' tz', tb_tz, { desc = 'fuzzy find curr buff' })

-- Telescope extensions
local filebrowser = telescope.extensions.file_browser.file_browser
local frecency = telescope.extensions.frecency.frecency
kb('n', ' tb', filebrowser, { desc = 'file browser' })
kb('n', ' tq', frecency, { desc = 'telescope frecency' })

-- Telescope commands
kb('n', ' tt', '<Cmd>Telescope<CR>', { desc = 'telescope command' })
