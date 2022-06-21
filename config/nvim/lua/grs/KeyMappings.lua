--[[ Setup keymappings/keybindings

       Module: grs
       File: ~/.config/nvim/lua/grs/KeyMappings.lua

     The only things this config file should do
     is setup Which-Key, define keymappings, and
     some of the functions used by the keymappings.
  ]]

local M = {}

--[[ Which-Key setup - helps make keymappings user discoverable ]]
local ok, wk = pcall(require, 'which-key')
if ok then
  wk.setup {
    plugins = {
      spelling = {
        enabled = true,
        suggestions = 36
      }
    }
  }
  M.wk = wk
else
  print('Problem loading which-key.nvim: ' .. wk)
end

--[[ Define Leader Keys ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

--[[ Define some utility functions ]]
local setKM = function(mode, desc, kb, cmd)
  vim.api.nvim_set_keymap(mode, kb, cmd, {
    noremap = true,
    silent = true,
    desc = desc
  })
end

local setCB = function(mode, desc, kb, callback)
  vim.api.nvim_set_keymap(mode, kb, '', {
    noremap = true,
    silent = true,
    desc = desc,
    callback = callback
  })
end

M.setKM = setKM
M.setCB = setCB

--[[ Set key mappings/bindings ]]

-- Turn off some redundant keybindings
setKM('n', '', '<BS>', '')
setKM('n', '', '-',    '')
setKM('n', '', '+',    '')

-- Creating, closing & navigating windows
setKM('n', 'goto window left',     '<M-h>', '<C-w>h')
setKM('n', 'goto window below',    '<M-j>', '<C-w>j')
setKM('n', 'goto window above',    '<M-k>', '<C-w>k')
setKM('n', 'goto window right',    '<M-l>', '<C-w>l')
setKM('n', 'goto previous window', '<M-p>', '<C-w>p')
setKM('n', 'close current window', '<M-c>', '<C-w>c')
setKM('n', 'breakout window new tabpage', '<M-b>', '<C-w>T')
setKM('n', 'close other tabpage windows', '<M-o>', '<C-w>o')
setKM('n', 'split current window',  '<M-s>', '<C-w>s')
setKM('n', 'vsplit current window', '<M-d>', '<C-w>v')
setKM('n', 'fish term in split',  '<M-f>', '<Cmd>split<Bar>term fish<CR>i')
setKM('n', 'fish term in vsplit', '<M-g>', '<Cmd>vsplit<Bar>term fish<CR>i')

-- Creating, closing & navigating tabpages
setKM('n', 'create new tab',    '<C-n>',     '<Cmd>tabnew<CR>')
setKM('n', 'close current tab', '<C-e>',     '<Cmd>tabclose<CR>')
setKM('n', 'goto tab left',     '<C-Left>',  '<Cmd>-tabnext<CR>')
setKM('n', 'goto tab last',     '<C-Down>',  '<Cmd>tablast<CR>')
setKM('n', 'goto tab first',    '<C-Up>',    '<Cmd>tabfirst<CR>')
setKM('n', 'goto tab right',    '<C-Right>', '<Cmd>+tabnext<CR>')

-- Changing window layout
setKM('n', 'move window lhs',    '<M-S-h>', '<C-w>H')
setKM('n', 'move window bot',    '<M-S-j>', '<C-w>J')
setKM('n', 'move window top',    '<M-S-k>', '<C-w>K')
setKM('n', 'move window rhs',    '<M-S-l>', '<C-w>L')
setKM('n', 'exch window next',   '<M-x>',   '<C-w>x')
setKM('n', 'rotate inner split', '<M-r>',   '<C-w>r')
setKM('n', 'equalize windows',   '<M-e>',   '<C-w>=')

-- Resizing windows
setKM('n', 'make window narrower', '<M-->', '2<C-w><') -- think Alt+Minus
setKM('n', 'make window wider',    '<M-=>', '2<C-w>>') -- think Alt+Plus
setKM('n', 'make window shorter',  '<M-_>', '2<C-w>-') -- think Alt+Shift+Minus
setKM('n', 'make window taller',   '<M-+>', '2<C-w>+') -- think Alt+Shift+Plus

-- Move view in window, only move cursor to keep on screen
setKM('n', 'move view left 4 columns',  '<C-h>', 'z4h')
setKM('n', 'move view down 3 lines',    '<C-j>', '3<C-e>')
setKM('n', 'move view up 3 lines',      '<C-k>', '3<C-y>')
setKM('n', 'move view right 4 colunms', '<C-l>', 'z4l')

-- Shift text and reselect
setKM('v', 'shift left & reselect',  '<', '<gv')
setKM('v', 'shift right & reselect', '>', '>gv')

-- Normal mode leader keymappings
setKM('n', 'Clear hlsearch',              '<leader><leader>', '<Cmd>nohlsearch<Bar>diffupdate<CR>')
setKM('n', 'new unnamed buffer',          '<leader>b',        '<Cmd>enew<CR>')
setKM('n', 'treesitter highlight toggle', '<leader>h',        '<Cmd>TSBufToggle highlight<CR>')
setKM('n', 'pick & enter diagraph',       '<leader>k',        '<Cmd>dig<CR>a<C-k>')
setCB('n', 'line number toggle', '<leader>n', function()
  if vim.wo.relativenumber == true then
    vim.wo.number = false
    vim.wo.relativenumber = false
  elseif vim.wo.number == true then
    vim.wo.number = false
    vim.wo.relativenumber = true
  else
    vim.wo.number = true
    vim.wo.relativenumber = false
  end
end )
setKM('n', 'clear & redraw screen',    '<leader>r', '<Cmd>mode<CR>')
setKM('n', 'toggle spelling',          '<leader>s', '<Cmd>set invspell<CR>')
setKM('n', 'trim trailing whitespace', '<leader>w', '<Cmd>%s/\\s\\+$//<CR><C-o>')

--[[ LSP related keymappings - using localleader ]]
M.lsp_keybindings = function(bufnr)

  setCB('n', 'code action',          '<localleader>c',  vim.lsp.buf.code_action)
  setCB('n', 'diag set local list',  '<localleader>d',  vim.diagnostic.setloclist)
  setCB('n', 'format',               '<localleader>f',  vim.lsp.buf.formatting)
  setCB('n', 'goto definition',      '<localleader>gd', vim.lsp.buf.definition)
  setCB('n', 'goto declaration',     '<localleader>gD', vim.lsp.buf.declaration)
  setCB('n', 'goto implementation',  '<localleader>gi', vim.lsp.buf.implementation)
  setCB('n', 'goto references',      '<localleader>gr', vim.lsp.buf.references)
  setCB('n', 'signatue help',        '<localleader>H',  vim.lsp.buf.signatue_help)
  setCB('n', 'hover',                '<localleader>h',  vim.lsp.buf.hover)
  setCB('n', 'worksheet hover',      '<localleader>k',  vim.lsp.buf.worksheet_hover)
  setCB('n', 'rename',               '<localleader>r',  vim.lsp.buf.rename)
  setCB('n', 'document symbol',      '<localleader>sd', vim.lsp.buf.document_symbol)
  setCB('n', 'workspace symbol',     '<localleader>sw', vim.lsp.buf.workspace_symbol)
  setCB('n', 'add workspace folder', '<localleader>wa', vim.lsp.buf.add_workspace_folder)
  setCB('n', 'rm workspace folder',  '<localleader>wr', vim.lsp.buf.remove_workspace_folder)
  setCB('n', 'diagnostic prev',      '<localleader>[',  function () vim.diagnostic.goto_prev {wrap = false} end)
  setCB('n', 'diagnostic next',      '<localleader>]',  function () vim.diagnostic.goto_next {wrap = false} end)

  -- LSP labels configured by WhichKey
  local lsp_labels = {
    g = {
      name = 'goto',
      s = { name = 'goto symbol' }
    },
    s = { name = 'symbol' },
    w = { name = 'workspace folder' }
  }

  if M.wk then
    wk.register(lsp_labels, { prefix = '<localleader>', buffer = bufnr })
  end

end

--[[ Telescope related keybindings ]]
M.telescope_keybindings = function(tb)

  setKM('n', 'Telescope Command',    '<M-t>T',  '<Cmd>Telescope<CR>')
  setCB('n', 'List Buffers',         '<M-t>bl', tb.buffers)
  setCB('n', 'Fuzzy Find Curr Buff', '<M-t>bz', tb.current_buffer_fuzzy_find)
  setCB('n', 'Find File',            '<M-t>ff', tb.find_files)
  setCB('n', 'Open Recent File',     '<M-t>fr', tb.oldfiles)
  setCB('n', 'Live Grep',            '<M-t>gl', tb.live_grep)
  setCB('n', 'Grep String',          '<M-t>gs', tb.grep_string)
  setCB('n', 'Help Tags',            '<M-t>h',  tb.help_tags)

  -- Telescope labels configured by WhichKey
  local ts_labels = {
    ['<M-t>'] = {
      name = 'Telescope',
      b = { name = 'telescope buffer' },
      f = { name = 'telescope files' },
      g = { name = 'telescope grep' },
      t = { name = 'telescope tags' }
    }
  }

  if M.wk then
    wk.register(ts_labels, { })
  end
end

return M
