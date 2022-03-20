--[[ Telescope - fuzzy finder over lists ]]

local ok, telescope, wk

ok, telescope = pcall(require, 'telescope')
if not ok then
  print('Problem loading telescope.')
  return
end

telescope.setup {
  ['ui-select'] = { require('telescope.themes').get_dropdown {} }
}
telescope.load_extension('ui-select')

-- Eetup telescope <leader> keybindings
ok, wk = pcall(require, 'which-key')
if not ok then return end

local mappings = {
  t = {
    name = '+Telescope',
    b = {
      name = '+Telescope Buffer',
      l = {":lua require('telescope.builtin').buffers()<CR>", 'List Buffers'},
      z = {":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", 'Fuzzy Find Current Buffer'} },
    f = {
      name = '+Telescope Files',
      f = {":lua require('telescope.builtin').find_files()<CR>", 'Find File'},
      r = {":lua require('telescope.builtin').oldfiles()<CR>", 'Open Recent File'} },
    g = {
      name = '+Telescope Grep',
      l = {":lua require('telescope.builtin').live_grep()<CR>", 'Live Grep'},
      s = {":lua require('telescope.builtin').grep_string()<CR>", 'Grep String'} },
    t = {
      name = '+Telescope Tags',
      b = {":lua require('telescope.builtin').tags({ only_current_buffer() = true })<CR>", 'List Tags Current Buffer'},
      h = {":lua require('telescope.builtin').help_tags()<CR>", 'Help Tags'},
      t = {":lua require('telescope.builtin').tags()<CR>", 'List Tags'} }
  }
}

local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,  -- global mappings for now
  silent = true,
  noremap = true,
  nowait = true
}

wk.register(mappings, opts)
