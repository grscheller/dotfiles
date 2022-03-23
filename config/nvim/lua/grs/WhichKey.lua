--[[ Using Which-Key to manage keybindings ]]

local M = {}

-- Turn off some redundant keybindings & setup Leader keys
vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', { noremap = true })
vim.api.nvim_set_keymap('n', '-', '<Nop>', { noremap = true })
vim.api.nvim_set_keymap('n', '+', '<Nop>', { noremap = true })

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local ok, whichkey = pcall(require, 'which-key')
if not ok then
  print('Problem loading which-key.nvim.')
  return false
end

whichkey.setup {
  plugins = {
    spelling = {
      enabled = true,
      suggestions = 36
    }
  }
}

--[[ Define some general purpose keybindings ]]

-- Window navigation/position/size keybindings
local window_kb = {
  ['<C-H>'] = {'<C-W>h', 'Goto Window Left' },  -- Navigate between windows using CTRL+hjkl keys
  ['<C-J>'] = {'<C-W>j', 'Goto Window Down' },
  ['<C-K>'] = {'<C-W>k', 'Goto Window Up'   },
  ['<C-L>'] = {'<C-W>l', 'Goto Window Right'},

  ['<M-Left>']  = {'<C-W>H', 'Move Window LHS'},  -- Move windows around using Alt-arrow keys
  ['<M-Down>']  = {'<C-W>J', 'Move Window BOT'},
  ['<M-Up>']    = {'<C-W>K', 'Move Window TOP'},
  ['<M-Right>'] = {'<C-W>L', 'Move Window RHS'},

  ['<M-h>'] = {'2<C-W><', 'Make Window Narrower'},  -- Resize windows using ALT-hjkl for Linux
  ['<M-j>'] = {'2<C-W>-', 'Make Window Shorter' },
  ['<M-k>'] = {'2<C-W>+', 'Make Window Taller'  },
  ['<M-l>'] = {'2<C-W>>', 'Make Window Wider'   }
}

local window_opts = {
  mode = 'n',
  prefix = '',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
}

whichkey.register(window_kb, window_opts)

-- Visual mode keybindings
local visual_kb = {
  ['<'] = {'<gv', 'Shift Left & Reselect'},  -- Reselect visual region
  ['>'] = {'>gv', 'Shift Right & Reselect'}  -- upon indention of text.
}

local visual_opts = {
  mode = 'v',
  prefix = '',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
}

whichkey.register(visual_kb, visual_opts)

-- Normal mode Leader keybindings
local normal_leader_kb = {
  b = {'<Cmd>enew<CR>', 'New Unnamed Buffer'},
  h = {'<Cmd>TSBufToggle highlight<CR>', 'Treesitter Highlight Toggle'},
  k = {'<Cmd>dig<CR>a<C-K>', 'Pick & Enter Diagraph'},
  r = {'<Cmd>mode<CR>', 'Clear & Redraw Screen'},  -- Lost <C-L> for this above
  n = {'<Cmd>lua myLineNumberToggle()<CR>', 'Line Number Toggle'},
  f = {
    name = '+Fish Shell in Terminal',
    s = {'<Cmd>split<Bar>term fish<CR>i', 'Fish Shell in split'},
    v = {'<Cmd>vsplit<Bar>term fish<CR>i', 'Fish Shell in vsplit'} },
  s = {'<Cmd>set invspell<CR>', 'Toggle Spelling'},
  w = {'<Cmd>%s/\\s\\+$//<CR>', 'Trim Trailing Whitespace'},
  ['<Space>'] = {'<Cmd>nohlsearch<Bar>diffupdate<CR>', 'Clear hlsearch'}
}

local normal_leader_opts = {
  mode = 'n',
  prefix = '<Leader>',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
}

whichkey.register(normal_leader_kb, normal_leader_opts)

--[[ Setup telescope <Leader> keybindings ]]

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

local ts_opts = {
  mode = "n",
  prefix = "<Leader>",
  buffer = nil,  -- global mappings for now
  silent = true,
  noremap = true,
  nowait = true
}

M.setupTelescopeKB = function()
  whichkey.register(ts_mappings, ts_opts)
end

--[[ LSP related normal mode <LocalLeader> keymappings ]]
--
-- See: https://github.com/scalameta/nvim-metals/discussions/39
--      https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/lsp/handlers.lua
local lsp_mappings = {
  name = '+lsp',
  F = {'<Cmd>lua vim.lsp.buf.formatting()<CR>', 'Formatting'},
  g = {
    name = '+goto',
    d = {'<Cmd>lua vim.lsp.buf.definition()<CR>', 'Goto Definition'},
    D = {'<Cmd>lua vim.lsp.buf.declaration()<CR>', 'Goto Declaration'},
    i = {'<Cmd>lua vim.lsp.buf.implementation()<CR>', 'Goto Implementation'},
    r = {'<Cmd>lua vim.lsp.buf.references()<CR>', 'Goto References'} },
  h = {'<Cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help'},
  H = {'<Cmd>lua vim.lsp.buf.hover()<CR>', 'Hover'},
  K = {'<Cmd>lua vim.lsp.buf.worksheet_hover()<CR>', 'Worksheet Hover'},
  l = {'<Cmd>lua vim.diagnostic.setloclist()<CR>', 'Diagnostic Set Local list'},
  m = {"<Cmd>lua require('metals').open_all_diagnostics()<CR>", 'Metals Diagnostics'},
  r = {'<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename'},
  s = {
    name = '+symbol',
    d = {'<Cmd>lua vim.lsp.buf.document_symbol()<CR>', 'Document Symbol'},
    w = {'<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'Workspace Symbol'} },
  w = {
    name = '+workspace folder',
    a = {'<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add Workspace Folder'},
    r = {'<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove Workspace Folder'} }
}

local lsp_opts = {
  mode = 'n',
  prefix = '<LocalLeader>',
  buffer = nil,  -- gets swapped out for buffer number
  silent = true,
  noremap = true,
  nowait = true
}

M.lsp_on_attach = function(client, bufnr)
  local mappings = lsp_mappings
  local opts = lsp_opts
  opts['buffer'] = bufnr
  whichkey.register(mappings, opts)
end

return M
