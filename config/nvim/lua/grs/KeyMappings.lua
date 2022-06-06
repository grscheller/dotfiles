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

--[[ Set key mappings/bindings ]]

local sk = vim.api.nvim_set_keymap

-- Turn off some redundant keybindings
sk('n', '<BS>', '<Nop>', { noremap = true })
sk('n', '-', '<Nop>', { noremap = true })
sk('n', '+', '<Nop>', { noremap = true })

-- Creating, closing & navigating windows
sk('n', '<M-e>', '<C-w>=', { noremap = true, desc = 'equalize heights/widths windows' })
sk('n', '<M-h>', '<C-w>h', { noremap = true, desc = 'goto window left' })
sk('n', '<M-j>', '<C-w>j', { noremap = true, desc = 'goto window below' })
sk('n', '<M-k>', '<C-w>k', { noremap = true, desc = 'goto window above' })
sk('n', '<M-l>', '<C-w>l', { noremap = true, desc = 'goto window right' })
sk('n', '<M-p>', '<C-w>p', { noremap = true, desc = 'goto previous window' })
sk('n', '<M-c>', '<C-w>c', { noremap = true, desc = 'close current window' })
sk('n', '<M-o>', '<C-w>o', { noremap = true, desc = 'close other windows in tab' })
sk('n', '<M-s>', '<C-w>s', { noremap = true, desc = 'split current window' })
sk('n', '<M-h>', '<C-w>v', { noremap = true, desc = 'vsplit current window' })

-- Creating, closing & navigating windows tabs
sk('n', '<M-t>b', '<C-w>T', { noremap = true, desc = 'break window out new tab' })
sk('n', '<M-t>c', '<Cmd>tabclose<CR>', { noremap = true, desc = 'close current tab' })
sk('n', '<M-t>n', '<Cmd>tabnew<CR>', { noremap = true, desc = 'goto new tab' })
sk('n', '<M-,>', '<Cmd>-tabnext<CR>', { noremap = true, desc = 'goto tab left' })
sk('n', '<M-.>', '<Cmd>+tabnext<CR>', { noremap = true, desc = 'goto tab right' })

-- Changing window layout
sk('n', '<M-S-h>', '<C-w>H', { noremap = true, desc = 'move window lhs' })
sk('n', '<M-S-j>', '<C-w>J', { noremap = true, desc = 'move window bot' })
sk('n', '<M-S-k>', '<C-w>K', { noremap = true, desc = 'move window top' })
sk('n', '<M-S-l>', '<C-w>L', { noremap = true, desc = 'move window rhs' })
sk('n', '<M-S-x>', '<C-w>x', { noremap = true, desc = 'exchange windows inner split' })
sk('n', '<M-S-r>', '<C-w>r', { noremap = true, desc = 'rotate windows inner split' })

-- Resizing windows
sk('n', '<M-->', '2<C-w><', { noremap = true, desc = 'make window narrower' })
sk('n', '<M-=>', '2<C-w>>', { noremap = true, desc = 'make window wider' })
sk('n', '<M-_>', '2<C-w>-', { noremap = true, desc = 'make window shorter' })
sk('n', '<M-+>', '2<C-w>+', { noremap = true, desc = 'make window taller' })

-- Move view in window, only move cursor to keep on screen
sk('n', '<C-h>',    'z4h', { noremap = true, desc = 'move view left 4 columns' })
sk('n', '<C-j>', '3<C-e>', { noremap = true, desc = 'move view down 3 lines' })
sk('n', '<C-k>', '3<C-y>', { noremap = true, desc = 'move view up 3 lines' })
sk('n', '<C-l>',    'z4l', { noremap = true, desc = 'move view right 4 colunms' })

-- Shift text and reselect
sk('v', '<', '<gv', { noremap = true, desc = 'shift left & reselect' })
sk('v', '>', '>gv', { noremap = true, desc = 'shift right & reselect' })

-- Normal mode leader keymappings
sk('n',  '<Leader><Leader>', '<Cmd>nohlsearch<Bar>diffupdate<CR>', { noremap = true, desc = 'Clear hlsearch' })
sk('n',  '<Leader>b', '<Cmd>enew<CR>', { noremap = true, desc = 'new unnamed buffer' })
sk('n', '<Leader>fs', '<Cmd>split<Bar>term fish<CR>i',  { noremap = true, desc = 'fish shell in split' })
sk('n', '<Leader>fv', '<Cmd>vsplit<Bar>term fish<CR>i', { noremap = true, desc = 'fish shell in vsplit' })
sk('n',  '<Leader>h', '<Cmd>TSBufToggle highlight<CR>', { noremap = true, desc = 'treesitter highlight toggle' })
sk('n',  '<Leader>k', '<Cmd>dig<CR>a<C-k>', { noremap = true, desc = 'pick & enter diagraph' })
sk('n',  '<Leader>n', '', {
  noremap = true,
  desc = "line number toggle",
  callback = function()
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
  end })
sk('n', '<Leader>r', '<Cmd>mode<CR>', { noremap = true, desc = 'clear & redraw screen' })
sk('n', '<Leader>s', '<Cmd>set invspell<CR>', { noremap = true, desc = 'toggle spelling' })
sk('n', '<Leader>w', '<Cmd>%s/\\s\\+$//<CR><C-o>', { noremap = true, desc = 'trim trailing whitespace' })

if M.wk then
  local leader_mappings_labels = {
    f = { name = '+fish shell in terminal' }
  }
  wk.register(leader_mappings_labels, { prefix = '<Leader>' })
end

--[[ LSP related normal mode localleader keymappings ]]

M.lsp_on_attach = function(client, bufnr)

  sk('n',   '<Localleader>c', '', { noremap = true, callback = vim.lsp.buf.code_action, desc = 'code action' })
  sk('n',   '<Localleader>d', '', { noremap = true, callback = vim.diagnostic.setloclist, desc = 'diagnostic set local list' })
  sk('n',   '<Localleader>f', '', { noremap = true, callback = vim.lsp.buf.formatting, desc = 'format' })
  sk('n',  '<Localleader>gd', '', { noremap = true, callback = vim.lsp.buf.definition, desc = 'goto definition' })
  sk('n',  '<Localleader>gD', '', { noremap = true, callback = vim.lsp.buf.declaration, desc = 'goto declaration' })
  sk('n',  '<Localleader>gi', '', { noremap = true, callback = vim.lsp.buf.implementation, desc = 'goto implementation' })
  sk('n',  '<Localleader>gr', '', { noremap = true, callback = vim.lsp.buf.references, desc = 'goto references' })
  sk('n',   '<Localleader>H', '', { noremap = true, callback = vim.lsp.buf.signatue_help, desc = 'signatue help' })
  sk('n',   '<Localleader>h', '', { noremap = true, callback = vim.lsp.buf.hover, desc = 'hover' })
  sk('n',   '<Localleader>k', '', { noremap = true, callback = vim.lsp.buf.worksheet_hover, desc = 'worksheet hover' })
  sk('n',   '<Localleader>r', '', { noremap = true, callback = vim.lsp.buf.rename, desc = 'rename' })
  sk('n',  '<Localleader>sd', '', { noremap = true, callback = vim.lsp.buf.document_symbol, desc = 'document symbol' })
  sk('n',  '<Localleader>sw', '', { noremap = true, callback = vim.lsp.buf.workspace_symbol, desc = 'workspace symbol' })
  sk('n',  '<Localleader>wa', '', { noremap = true, callback = vim.lsp.buf.add_workspace_folder, desc = 'add workspace folder' })
  sk('n',  '<Localleader>wr', '', { noremap = true, callback = vim.lsp.buf.remove_workspace_folder, desc = 'remove workspace folder' })
  sk('n',   '<Localleader>[', '', { noremap = true, callback = function () vim.diagnostic.goto_prev {wrap = false} end, desc = 'diagnostic prev' })
  sk('n',   '<Localleader>]', '', { noremap = true, callback = function () vim.diagnostic.goto_next {wrap = false} end, desc = 'diagnostic next' })

  local lsp_mappings = {
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
    wk.register(lsp_mappings, { prefix = '<Localleader>', buffer = bufnr })
  end

end

return M
