--[[ Using Which-Key to make keymappings/bindings user discoverable

       Module: grs
       File: ~/.config/nvim/lua/grs/KeyMappings.lua

     The only things this config file should do
     is setup Which-Key, define keymappings, and
     some of the functions used by the keymappings.
  ]]

local M = {}

--[[ Which-Key setup ]]

local ok, wk = pcall(require, 'which-key')
if not ok then
  print('Problem loading which-key.nvim: ' .. wk)
  return false
end

wk.setup {
  plugins = {
    spelling = {
      enabled = true,
      suggestions = 36
    }
  }
}

M.wk = wk

--[[ Define Leader Keys ]]

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

--[[ Window management, modeled somewhat after Sway on Linux ]]
local sk = vim.api.nvim_set_keymap

-- Navigating between windows and tabs
sk('n', '<M-h>', '<C-w>h', {noremap = true, desc = 'goto window left'})
sk('n', '<M-j>', '<C-w>j', {noremap = true, desc = 'goto window below'})
sk('n', '<M-k>', '<C-w>k', {noremap = true, desc = 'goto window above'})
sk('n', '<M-l>', '<C-w>l', {noremap = true, desc = 'goto window right'})
sk('n', '<M-p>', '<C-w>p', {noremap = true, desc = 'goto previous window'})
sk('n', '<M-t>', '<Cmd>tabnew<CR>', {noremap = true, desc = 'goto new tab'})
sk('n', '<M-,>', '<Cmd>-tabnext<CR>', {noremap = true, desc = 'goto tab left'})
sk('n', '<M-.>', '<Cmd>+tabnext<CR>', {noremap = true, desc = 'goto tab right'})

local window_mappings = {
  -- Moving, creating, removing windows
  ['<M-S-h>'] = {'<C-w>H', 'move window lhs'},
  ['<M-S-j>'] = {'<C-w>J', 'move window bot'},
  ['<M-S-k>'] = {'<C-w>K', 'move window top'},
  ['<M-S-l>'] = {'<C-w>L', 'move window rhs'},
  ['<M-S-x>'] = {'<C-w>x', 'exchange windows inner split'},
  ['<M-S-r>'] = {'<C-w>r', 'rotate windows inner split'},
  ['<M-S-q>'] = {'<C-w>q', 'quit current window'},
  ['<M-S-c>'] = {'<C-w>c', 'close current windows'},
  ['<M-S-o>'] = {'<C-w>o', 'close all other windows in tab'},
  ['<M-S-e>'] = {'<C-w>=', 'equalize heights/widths windows'},
  ['<M-S-t>'] = {'<C-w>T', 'break window out new tab'},

  -- Resizing windows
  ['<M-->'] = {'2<C-w><', 'make window narrower'},  -- Think Alt+"-"
  ['<M-=>'] = {'2<C-w>>', 'make window wider'},     -- Think Alt+"+"
  ['<M-_>'] = {'2<C-w>-', 'make window shorter'},   -- Think Alt+Shift+"-"
  ['<M-+>'] = {'2<C-w>+', 'make window taller'},    -- Think Alt+Shift+"+"

  -- Move view in window, only move cursor to keep on screen
  ['<C-h>'] = {'z4h', 'move view left 4 columns'},
  ['<C-j>'] = {'3<C-e>', 'move view down 3 lines'},
  ['<C-k>'] = {'3<C-y>', 'move view up 3 lines'},
  ['<C-l>'] = {'z4l', 'move view right 4 colunms'}
}

wk.register(window_mappings, {})

--[[ Visual mode keymappings ]]

local visual_mappings = {
  ['<'] = {'<gv', 'shift left & reselect'},  -- Reselect visual region
  ['>'] = {'>gv', 'shift right & reselect'}  -- upon indention of text.
}

wk.register(visual_mappings, {mode = 'v'})

--[[ Normal mode leader keymappings ]]

local nl_mappings = {
  b = {'<Cmd>enew<CR>', 'new unnamed buffer'},
  h = {'<Cmd>TSBufToggle highlight<CR>', 'treesitter highlight toggle'},
  i = {'<Cmd>set invspell<CR>', 'toggle spelling'},
  k = {'<Cmd>dig<CR>a<C-k>', 'pick & enter diagraph'},
  l = {'<Cmd>nohlsearch<Bar>diffupdate<CR>', 'Clear hlsearch'},
  r = {'<Cmd>mode<CR>', 'clear & redraw screen'},
  f = {
    name = '+fish shell in terminal',
    s = {'<Cmd>split<Bar>term fish<CR>i', 'fish shell in split'},
    v = {'<Cmd>vsplit<Bar>term fish<CR>i', 'fish shell in vsplit'} },
  s = {'xi', 'replace lost normal mode s'},
  w = {'<Cmd>%s/\\s\\+$//<CR><C-o>', 'trim trailing whitespace'}
}

wk.register(nl_mappings, {prefix = '<leader>'})

vim.api.nvim_set_keymap('n', '<leader>n', '', {
  noremap = true,
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
  end,
  desc = "line number toggle"
})

--[[ LSP related normal mode localleader keymappings ]]

M.lsp_on_attach = function(client, bufnr)

  local lsp_mappings = {
    ca = {'<Cmd>lua vim.lsp.buf.code_action()<CR>', 'code action'},
    d = {'<Cmd>lua vim.diagnostic.setloclist()<CR>', 'diagnostic set local list'},
    f = {'<Cmd>lua vim.lsp.buf.formatting()<CR>', 'format'},
    g = {
      name = '+goto',
      d = {'<Cmd>lua vim.lsp.buf.definition()<CR>', 'goto definition'},
      D = {'<Cmd>lua vim.lsp.buf.declaration()<CR>', 'goto Declaration'},
      i = {'<Cmd>lua vim.lsp.buf.implementation()<CR>', 'goto implementation'},
      r = {'<Cmd>lua vim.lsp.buf.references()<CR>', 'goto references'},
      s = {
        name = '+goto symbol',
        d = {'<Cmd>lua vim.lsp.buf.document_symbol()<CR>', 'document symbol'},
        w = {'<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'workspace symbol'} } },
    H = {'<Cmd>lua vim.lsp.buf.signature_help()<CR>', 'signature Help'},
    h = {'<Cmd>lua vim.lsp.buf.hover()<CR>', 'hover'},
    k = {'<Cmd>lua vim.lsp.buf.worksheet_hover()<CR>', 'worksheet hover'},
    r = {'<Cmd>lua vim.lsp.buf.rename()<CR>', 'rename'},
    s = {
      name = '+symbol',
      d = {'<Cmd>lua vim.lsp.buf.document_symbol()<CR>', 'document symbol'},
      w = {'<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'workspace symbol'} },
    w = {
      name = '+workspace folder',
      a = {'<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'add workspace folder'},
      r = {'<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'remove workspace folder'} },
    ['['] = {'<Cmd>lua vim.diagnostic.goto_prev {wrap = false}<CR>', 'diagnostic previous'},
    [']'] = {'<Cmd>lua vim.diagnostic.goto_next {wrap = false}<CR>', 'diagnostic next'}
    -- To add nvim-dap debugging, see example for Scala here
    -- https://github.com/scalameta/nvim-metals/discussions/39
  }

  wk.register(lsp_mappings, {prefix = '<localleader>', buffer = bufnr})

end

return M
