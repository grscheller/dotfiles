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

--[[ Set Telescope key mappings/bindings ]]

local sk = vim.api.nvim_set_keymap

sk('n', 'tbl', "<leader><Cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true, desc = 'List Buffers' })
sk('n', 'tbz', "<leader><Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", { noremap = true, desc = 'Fuzzy Find Current Buffer' })
sk('n', 'tff', "<leader><Cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true, desc = 'Find File' })
sk('n', 'tfr', "<leader><Cmd>lua require('telescope.builtin').oldfiles()<CR>", { noremap = true, desc = 'Open Recent File' })
sk('n', 'tgl', "<leader><Cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, desc = 'Live Grep' })
sk('n', 'tgs', "<leader><Cmd>lua require('telescope.builtin').grep_string()<CR>", { noremap = true, desc = 'Grep String' })
sk('n', 'ttb', "<leader><Cmd>lua require('telescope.builtin').tags({only_current_buffer() = true })<CR>", { noremap = true, desc = 'List Tags Current Buffer' })
sk('n', 'tth', "<leader><Cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap = true, desc = 'Help Tags' })
sk('n', 'ttt', "<leader><Cmd>lua require('telescope.builtin').tags()<CR>", { noremap = true, desc = 'List Tags' })

-- Set up Whick-Key labels
local ts_mappings = {
  t = {
    name = '+Telescope',
    b = {
      name = '+Telescope Buffer'
    },
    f = {
      name = '+Telescope Files'
    },
    g = {
      name = '+Telescope Grep'
    },
    t = {
      name = '+Telescope Tags'
    }
  }
}

local kb = require('grs.KeyMappings')
if kb.wk then
  kb.wk.register(ts_mappings, { prefix = '<leader>' })
end
