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
setKM('n', 'equalize windows',        '<M-e>', '<C-w>=')
setKM('n', 'goto window left',        '<M-h>', '<C-w>h')
setKM('n', 'goto window below',       '<M-j>', '<C-w>j')
setKM('n', 'goto window above',       '<M-k>', '<C-w>k')
setKM('n', 'goto window right',       '<M-l>', '<C-w>l')
setKM('n', 'goto previous window',    '<M-p>', '<C-w>p')
setKM('n', 'close current window',    '<M-c>', '<C-w>c')
setKM('n', 'close other tab windows', '<M-o>', '<C-w>o')
setKM('n', 'split current window',    '<M-s>', '<C-w>s')
setKM('n', 'vsplit current window',   '<M-d>', '<C-w>v')

-- Creating, closing & navigating windows tabs
setKM('n', 'break window out new tab', '<M-t>b', '<C-w>T')
setKM('n', 'close current tab',        '<M-t>c', '<Cmd>tabclose<CR>')
setKM('n', 'goto new tab',             '<M-t>n', '<Cmd>tabnew<CR>')
setKM('n', 'goto tab left',            '<M-,>',  '<Cmd>-tabnext<CR>')
setKM('n', 'goto tab right',           '<M-.>',  '<Cmd>+tabnext<CR>')

-- Changing window layout
setKM('n', 'move window lhs',  '<M-S-h>', '<C-w>H')
setKM('n', 'move window bot',  '<M-S-j>', '<C-w>J')
setKM('n', 'move window top',  '<M-S-k>', '<C-w>K')
setKM('n', 'move window rhs',  '<M-S-l>', '<C-w>L')
setKM('n', 'exchange windows', '<M-S-x>', '<C-w>x')
setKM('n', 'rotate windows',   '<M-S-r>', '<C-w>r')

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
setKM('n', 'Clear hlsearch',              '<Leader><Leader>', '<Cmd>nohlsearch<Bar>diffupdate<CR>')
setKM('n', 'new unnamed buffer',          '<Leader>b',        '<Cmd>enew<CR>')
setKM('n', 'fish shell in split',         '<Leader>fs',       '<Cmd>split<Bar>term fish<CR>i')
setKM('n', 'fish shell in vsplit',        '<Leader>fv',       '<Cmd>vsplit<Bar>term fish<CR>i')
setKM('n', 'treesitter highlight toggle', '<Leader>h',        '<Cmd>TSBufToggle highlight<CR>')
setKM('n', 'pick & enter diagraph',       '<Leader>k',        '<Cmd>dig<CR>a<C-k>')
setCB('n', 'line number toggle', '<Leader>n', function()
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
setKM('n', 'clear & redraw screen',    '<Leader>r', '<Cmd>mode<CR>')
setKM('n', 'toggle spelling',          '<Leader>s', '<Cmd>set invspell<CR>')
setKM('n', 'trim trailing whitespace', '<Leader>w', '<Cmd>%s/\\s\\+$//<CR><C-o>')

if M.wk then
  local leader_mappings_labels = {
    f = { name = '+fish shell in terminal' }
  }
  wk.register(leader_mappings_labels, { prefix = '<Leader>' })
end

--[[ LSP related localleader keymappings ]]
M.lsp_keybindings = function(bufnr)

  setCB('n', 'code action',          '<Localleader>c',  vim.lsp.buf.code_action)
  setCB('n', 'diag set local list',  '<Localleader>d',  vim.diagnostic.setloclist)
  setCB('n', 'format',               '<Localleader>f',  vim.lsp.buf.formatting)
  setCB('n', 'goto definition',      '<Localleader>gd', vim.lsp.buf.definition)
  setCB('n', 'goto declaration',     '<Localleader>gD', vim.lsp.buf.declaration)
  setCB('n', 'goto implementation',  '<Localleader>gi', vim.lsp.buf.implementation)
  setCB('n', 'goto references',      '<Localleader>gr', vim.lsp.buf.references)
  setCB('n', 'signatue help',        '<Localleader>H',  vim.lsp.buf.signatue_help)
  setCB('n', 'hover',                '<Localleader>h',  vim.lsp.buf.hover)
  setCB('n', 'worksheet hover',      '<Localleader>k',  vim.lsp.buf.worksheet_hover)
  setCB('n', 'rename',               '<Localleader>r',  vim.lsp.buf.rename)
  setCB('n', 'document symbol',      '<Localleader>sd', vim.lsp.buf.document_symbol)
  setCB('n', 'workspace symbol',     '<Localleader>sw', vim.lsp.buf.workspace_symbol)
  setCB('n', 'add workspace folder', '<Localleader>wa', vim.lsp.buf.add_workspace_folder)
  setCB('n', 'rm workspace folder',  '<Localleader>wr', vim.lsp.buf.remove_workspace_folder)
  setCB('n', 'diagnostic prev',      '<Localleader>[',  function () vim.diagnostic.goto_prev {wrap = false} end)
  setCB('n', 'diagnostic next',      '<Localleader>]',  function () vim.diagnostic.goto_next {wrap = false} end)

  -- Labels for WhichKey
  local lsp_labels = {
    g = {
      name = '+goto',
      s = {
        name = '+goto symbol'
      }
    },
    s = {
      name = '+symbol'
    },
    w = {
      name = '+workspace folder'
    }
  }

  if M.wk then
    wk.register(lsp_labels, { prefix = '<Localleader>', buffer = bufnr })
  end

end

--[[ Telescope related localleader keymappings ]]
M.telescope_keybindings = function(tb)

  setCB('n', 'List Buffers',              '<Leader>tbl', tb.buffers)
  setCB('n', 'Fuzzy Find Current Buffer', '<Leader>tbz', tb.current_buffer_fuzzy_find)
  setCB('n', 'Find File',                 '<Leader>tff', tb.find_files)
  setCB('n', 'Open Recent File',          '<Leader>tfr', tb.oldfiles)
  setCB('n', 'Live Grep',                 '<Leader>tgl', tb.live_grep)
  setCB('n', 'Grep String',               '<Leader>tgs', tb.grep_string)
  setCB('n', 'List Tags Current Buffer',  '<Leader>ttb', function () tb.tags { only_current_buffer = true } end)
  setCB('n', 'Help Tags',                 '<Leader>tth', tb.help_tags)
  setCB('n', 'List Tags',                 '<Leader>ttl', tb.tags)

  -- Labels for WhichKey
  local ts_labels = {
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

  if M.wk then
    wk.register(ts_labels, { prefix = '<leader>' })
  end
end

return M
