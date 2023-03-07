--[[ Icons - just a collection, not yet used ]]

-- Not sure how to use these to change LSP diagnostics and Info displays.
-- There a plugin called Lspsaga that might do this for me?

local M = {}

M.icons = {
   diagnostics = {
      Error = ' ',
      Warn = ' ',
      Hint = ' ',
      Info = ' ',
   },
   kinds = {
      Class = 'ﴯ ',
      Color = ' ',
      Constant = ' ',
      Constructor = '🛠',
      Enum = ' ',
      EnumMember = ' ',
      Event = ' ',
      Field = ' ',
      File = ' ',
      Folder = ' ',
      Function = ' ',
      Interface = ' ',
      Keyword = ' ',
      Method = ' ',
      Module = ' ',
      Operator = ' ',
      Property = 'ﰠ ',
      Reference = ' ',
      Snippet = ' ',
      Struct = 'פּ ',
      Text = ' ',
      TypeParameter = 'ﰮ ',
      Unit = '塞',
      Value = ' ',
      Variable = ' ',
   },
   misc = {
      cmd = '⌘',
      config = ' ',
      event = '📅',
      ft = '📂',
      init = '⚙ ',
      keys = '🗝',
      lazy = '󰒲 ',
      plugin = '🔌',
      runtime = '💻',
      source = '📄',
      start = ' ',
      task = '📌',
   },
}

return M
