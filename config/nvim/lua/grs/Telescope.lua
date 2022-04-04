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

-- Using folke/which-key.nvim eo manage telescope key mappings
local whichkey, wk
whichkey = require('grs.WhichKey')
if whichkey then
  wk = whichkey.wk

  local ts_mappings = {
    t = {
      name = '+Telescope',
      b = {
        name = '+Telescope Buffer',
        l = {"<Cmd>lua require('telescope.builtin').buffers()<CR>", 'List Buffers'},
        z = {"<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", 'Fuzzy Find Current Buffer'} },
      f = {
        name = '+Telescope Files',
        f = {"<Cmd>lua require('telescope.builtin').find_files()<CR>", 'Find File'},
        r = {"<Cmd>lua require('telescope.builtin').oldfiles()<CR>", 'Open Recent File'} },
      g = {
        name = '+Telescope Grep',
        l = {"<Cmd>lua require('telescope.builtin').live_grep()<CR>", 'Live Grep'},
        s = {"<Cmd>lua require('telescope.builtin').grep_string()<CR>", 'Grep String'} },
      t = {
        name = '+Telescope Tags',
        b = {"<Cmd>lua require('telescope.builtin').tags({ only_current_buffer() = true })<CR>", 'List Tags Current Buffer'},
        h = {"<Cmd>lua require('telescope.builtin').help_tags()<CR>", 'Help Tags'},
        t = {"<Cmd>lua require('telescope.builtin').tags()<CR>", 'List Tags'} }
    }
  }

  wk.register(ts_mappings, { prefix = '<leader>' })
else
  print('Telescope keybindings setup failed')
end
