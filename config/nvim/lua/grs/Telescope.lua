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
local tb = require('telescope.builtin')

sk('n', '<Leader>tbl', '', { noremap = true, callback = tb.buffers, desc = 'List Buffers' })
sk('n', '<Leader>tbz', '', { noremap = true, callback = tb.current_buffer_fuzzy_find, desc = 'Fuzzy Find Current Buffer' })
sk('n', '<Leader>tff', '', { noremap = true, callback = tb.find_files, desc = 'Find File' })
sk('n', '<Leader>tfr', '', { noremap = true, callback = tb.oldfiles, desc = 'Open Recent File' })
sk('n', '<Leader>tgl', '', { noremap = true, callback = tb.live_grep, desc = 'Live Grep' })
sk('n', '<Leader>tgs', '', { noremap = true, callback = tb.grep_string, desc = 'Grep String' })
sk('n', '<Leader>ttb', '', { noremap = true, callback = function () tb.tags { only_current_buffer = true } end, desc = 'List Tags Current Buffer' })
sk('n', '<Leader>tth', '', { noremap = true, callback = tb.help_tags, desc = 'Help Tags' })
sk('n', '<Leader>ttl', '', { noremap = true, callback = tb.tags, desc = 'List Tags' })

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
if kb then
  kb.wk.register(ts_mappings, { prefix = '<leader>' })
end
