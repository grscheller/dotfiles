--[[ Using Which-Key to manage keymappings

       Module: grs
       File: ~/.config/nvim/lua/grs/WhichKey.lua

     The only things this config file should do
     is setup Which-Key and define keymappings.

  ]]

local M = {}

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local ok, whichkey = pcall(require, 'which-key')
if not ok then
  print('Problem loading which-key.nvim: ' .. whichkey)
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

--[[ Immediately define some general purpose keymappings ]]

-- Window management- modeled somewhat after Sway on Linux
local window_mappings = {
  -- Navigating between windows
  ['<M-h>'] = {'<C-W>h', 'Goto Window Left'},
  ['<M-j>'] = {'<C-W>j', 'Goto Window Down'},
  ['<M-k>'] = {'<C-W>k', 'Goto Window Up'},
  ['<M-l>'] = {'<C-W>l', 'Goto Window Right'},
  ['<M-p>'] = {'<C-W>p', 'Goto Previous Window'},
  ['<M-t>'] = {'<Cmd>tabnew<CR>', 'Open New Tab'},

  -- Moving, creating, removing windows
  ['<M-S-h>'] = {'<C-W>H', 'Move Window LHS of Screen'},
  ['<M-S-j>'] = {'<C-W>J', 'Move Window BOT of Screen'},
  ['<M-S-k>'] = {'<C-W>K', 'Move Window TOP of Screen'},
  ['<M-S-l>'] = {'<C-W>L', 'Move Window RHS of Screen'},
  ['<M-S-x>'] = {'<C-W>x', 'Exchange Windows Inner Split'},
  ['<M-S-r>'] = {'<C-W>r', 'Rotate Windows Inner Split'},
  ['<M-S-q>'] = {'<C-W>q', 'Quit Current Window'},
  ['<M-S-c>'] = {'<C-W>c', 'Close Current Windows'},
  ['<M-S-o>'] = {'<C-W>o', 'Close All other Windows in Tab'},
  ['<M-S-e>'] = {'<C-W>=', 'Equalize Heights/Widths Windows'},
  ['<M-S-t>'] = {'<C-W>T', 'Break Window Out New Tab'},

  -- Resizing windows
  ['<M-->'] = {'2<C-W><', 'Make Window Narrower'},  -- Think Alt+"-"
  ['<M-=>'] = {'2<C-W>>', 'Make Window Wider'},     -- Think Alt+"+"
  ['<M-_>'] = {'2<C-W>-', 'Make Window Shorter'},   -- Think Alt+Shift+"-"
  ['<M-+>'] = {'2<C-W>+', 'Make Window Taller'},    -- Think Alt+Shift+"+"

  -- Move view in window, only move cursor to keep on screen
  ['<C-H>'] = {'z4h', 'Move View Left 4 Columns'  },
  ['<C-J>'] = {'3<C-E>', 'Move View Down 3 Lines' },
  ['<C-K>'] = {'3<C-Y>', 'Move View Up 3 Lines'   },
  ['<C-L>'] = {'z4l', 'Move View Right 4 Colunms' }
}

local opts = {
  mode = 'n', prefix = '', buffer = nil,
  silent = true, noremap = true, nowait = true
}

whichkey.register(window_mappings, opts)

-- Visual mode keymappings
local visual_mappings = {
  ['<'] = {'<gv', 'Shift Left & Reselect'},  -- Reselect visual region
  ['>'] = {'>gv', 'Shift Right & Reselect'}  -- upon indention of text.
}

local visual_opts = {
  mode = 'v', prefix = '', buffer = nil,
  silent = true, noremap = true, nowait = true
}

whichkey.register(visual_mappings, visual_opts)

-- Normal mode leader keymappings
local nl_mappings = {
  b = {'<Cmd>enew<CR>', 'New Unnamed Buffer'},
  h = {'<Cmd>TSBufToggle highlight<CR>', 'Treesitter Highlight Toggle'},
  k = {'<Cmd>dig<CR>a<C-K>', 'Pick & Enter Diagraph'},
  r = {'<Cmd>mode<CR>', 'Clear & Redraw Screen'},
  n = {'<Cmd>lua myLineNumberToggle()<CR>', 'Line Number Toggle'},
  f = {
    name = '+Fish Shell in Terminal',
    s = {'<Cmd>split<Bar>term fish<CR>i', 'Fish Shell in split'},
    v = {'<Cmd>vsplit<Bar>term fish<CR>i', 'Fish Shell in vsplit'} },
  s = {'<Cmd>set invspell<CR>', 'Toggle Spelling'},
  w = {'<Cmd>%s/\\s\\+$//<CR><C-O>', 'Trim Trailing Whitespace'},
  ['<Space>'] = {'<Cmd>nohlsearch<Bar>diffupdate<CR>', 'Clear hlsearch'}
}

local nl_opts = {
  mode = 'n', prefix = '<leader>', buffer = nil,
  silent = true, noremap = true, nowait = true
}

whichkey.register(nl_mappings, nl_opts)

-- Setup Plugin justinmk/vim-sneak
M.setupSneakKB = function()

  local sneak_mappings = {
    f = {'<Plug>Sneak_f', 'f 1-char sneak'},
    F = {'<Plug>Sneak_F', 'F 1-char sneak'},
    t = {'<Plug>Sneak_t', 't 1-char sneak'},
    T = {'<Plug>Sneak_T', 'T 1-char sneak'}
  }

  local sneak_opts = {
    mode = 'n', prefix = '', buffer = nil,
    silent = true, noremap = false, nowait = true
  }

  whichkey.register(sneak_mappings, sneak_opts)

  sneak_opts['mode'] = 'x'
  whichkey.register(sneak_mappings, sneak_opts)

  sneak_opts['mode'] = 'o'
  whichkey.register(sneak_mappings, sneak_opts)

end

-- Setup telescope <leader> keymappings
M.setupTelescopeKB = function()

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
    mode = 'n', prefix = '<leader>', buffer = nil,
    silent = true, noremap = true, nowait = true
  }

  whichkey.register(ts_mappings, ts_opts)

end

-- LSP related normal mode localleader keymappings
M.lsp_on_attach = function(client, bufnr)

  local lsp_g_mappings = {
    name = '+lsp',
    g = {
      -- name = '+goto',
      d = {'<Cmd>lua vim.lsp.buf.definition()<CR>', 'Goto Definition'},
      D = {'<Cmd>lua vim.lsp.buf.declaration()<CR>', 'Goto Declaration'},
      I = {'<Cmd>lua vim.lsp.buf.implementation()<CR>', 'Goto Implementation'},
      r = {'<Cmd>lua vim.lsp.buf.references()<CR>', 'Goto References'},
      s = {
        name = '+goto symbol',
        d = {'<Cmd>lua vim.lsp.buf.document_symbol()<CR>', 'Document Symbol'},
        w = {'<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'Workspace Symbol'} } }
  }

  local lsp_ll_mappings = {
    ca = {'<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action'},
    d = {'<Cmd>lua vim.diagnostic.setloclist()<CR>', 'Diagnostic Set Local list'},
    F = {'<Cmd>lua vim.lsp.buf.formatting()<CR>', 'Formatting'},
    h = {'<Cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help'},
    H = {'<Cmd>lua vim.lsp.buf.hover()<CR>', 'Hover'},
    K = {'<Cmd>lua vim.lsp.buf.worksheet_hover()<CR>', 'Worksheet Hover'},
    r = {'<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename'},
    s = {
      name = '+symbol',
      d = {'<Cmd>lua vim.lsp.buf.document_symbol()<CR>', 'Document Symbol'},
      w = {'<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'Workspace Symbol'} },
    w = {
      name = '+workspace folder',
      a = {'<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add Workspace Folder'},
      r = {'<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove Workspace Folder'} },
    ['['] = {'<Cmd>lua vim.diagnostic.goto_prev {wrap = false}<CR>', 'Diag Prev'},
    [']'] = {'<Cmd>lua vim.diagnostic.goto_next {wrap = false}<CR>', 'Diag Next'}
    -- To add nvim-dap debugging, see example for Scala here
    -- https://github.com/scalameta/nvim-metals/discussions/39
  }

  local lsp_opts = {
    mode = 'n', prefix = '', buffer = bufnr,
    silent = true, noremap = true, nowait = true
  }

  whichkey.register(lsp_g_mappings, lsp_opts)

  lsp_opts['prefix'] = '<localleader>'
  whichkey.register(lsp_ll_mappings, lsp_opts)

end

return M
