--[[ Using Which-Key to manage keymappings/bindings

       Module: grs
       File: ~/.config/nvim/lua/grs/WhichKey.lua

     The only things this config file should do
     is setup Which-Key, define keymappings, and
     functions used by some of the keymappings.

     Which-Keys default keymapping options are

       mode = 'n', prefix = '', buffer = nil,
       silent = true, noremap = true, nowait = false

     unless specified command starts with <Plug>, then

       noremap = false
  ]]

local M = {}

--[[ WhichKey setup ]]
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

--[[ Define Leader Keys ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

M.wk = wk

--[[ Define functions used in below keymappings ]]

-- Toggle between 3 line numbering states on per window basis
MYLINENUMBERTOGGLE = function()
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
end

--[[  Define some general purpose keymappings ]]

-- Window management, modeled somewhat after Sway on Linux
local window_mappings = {
  -- Navigating between windows
  ['<M-h>'] = {'<C-w>h', 'goto window left'},
  ['<M-j>'] = {'<C-w>j', 'goto window down'},
  ['<M-k>'] = {'<C-w>k', 'goto window up'},
  ['<M-l>'] = {'<C-w>l', 'goto window right'},
  ['<M-p>'] = {'<C-w>p', 'goto previous window'},
  ['<M-t>'] = {'<Cmd>tabnew<CR>', 'open new tab'},

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

-- Visual mode keymappings
local visual_mappings = {
  ['<'] = {'<gv', 'shift left & reselect'},  -- Reselect visual region
  ['>'] = {'>gv', 'shift right & reselect'}  -- upon indention of text.
}

wk.register(visual_mappings, {mode = 'v'})

-- Normal mode leader keymappings
local nl_mappings = {
  b = {'<Cmd>enew<CR>', 'new unnamed buffer'},
  h = {'<Cmd>TSBufToggle highlight<CR>', 'treesitter highlight toggle'},
  i = {'<Cmd>set invspell<CR>', 'toggle spelling'},
  k = {'<Cmd>dig<CR>a<C-k>', 'pick & enter diagraph'},
  l = {'<Cmd>nohlsearch<Bar>diffupdate<CR>', 'Clear hlsearch'},
  r = {'<Cmd>mode<CR>', 'clear & redraw screen'},
  n = {'<Cmd>lua MYLINENUMBERTOGGLE()<CR>', 'line number toggle'},
  f = {
    name = '+fish shell in terminal',
    s = {'<Cmd>split<Bar>term fish<CR>i', 'fish shell in split'},
    v = {'<Cmd>vsplit<Bar>term fish<CR>i', 'fish shell in vsplit'} },
  s = {'xi', 'replace lost normal mode s'},
  w = {'<Cmd>%s/\\s\\+$//<CR><C-o>', 'trim trailing whitespace'}
}

wk.register(nl_mappings, {prefix = '<leader>'})

-- LSP related normal mode localleader keymappings
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
