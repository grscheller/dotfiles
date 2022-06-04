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

-- Creating, closing & navigating windows and tabs
sk('n', '<M-h>', '<C-w>h', {noremap = true, desc = 'goto window left'})
sk('n', '<M-j>', '<C-w>j', {noremap = true, desc = 'goto window below'})
sk('n', '<M-k>', '<C-w>k', {noremap = true, desc = 'goto window above'})
sk('n', '<M-l>', '<C-w>l', {noremap = true, desc = 'goto window right'})
sk('n', '<M-p>', '<C-w>p', {noremap = true, desc = 'goto previous window'})
sk('n', '<M-q>', '<C-w>q', {noremap = true, desc = 'quit current window'})
sk('n', '<M-t>', '<Cmd>tabnew<CR>', {noremap = true, desc = 'goto new tab'})
sk('n', '<M-,>', '<Cmd>-tabnext<CR>', {noremap = true, desc = 'goto tab left'})
sk('n', '<M-.>', '<Cmd>+tabnext<CR>', {noremap = true, desc = 'goto tab right'})
sk('n', '<M-o>', '<C-w>o', {noremap = true, desc = 'close other windows in tab'})

  -- Moving, creating, removing windows
sk('n', '<M-S-h>', '<C-w>H', {noremap = true, desc = 'move window lhs'})
sk('n', '<M-S-j>', '<C-w>J', {noremap = true, desc = 'move window bot'})
sk('n', '<M-S-k>', '<C-w>K', {noremap = true, desc = 'move window top'})
sk('n', '<M-S-l>', '<C-w>L', {noremap = true, desc = 'move window rhs'})
sk('n', '<M-S-x>', '<C-w>x', {noremap = true, desc = 'exchange windows inner split'})
sk('n', '<M-S-r>', '<C-w>r', {noremap = true, desc = 'rotate windows inner split'})
sk('n', '<M-S-e>', '<C-w>=', {noremap = true, desc = 'equalize heights/widths windows'})
sk('n', '<M-S-t>', '<C-w>T', {noremap = true, desc = 'break window out new tab'})

  -- Resizing windows
sk('n', '<M-->', '2<C-w><', {noremap = true, desc = 'make window narrower'})
sk('n', '<M-=>', '2<C-w>>', {noremap = true, desc = 'make window wider'})
sk('n', '<M-_>', '2<C-w>-', {noremap = true, desc = 'make window shorter'})
sk('n', '<M-+>', '2<C-w>+', {noremap = true, desc = 'make window taller'})

  -- Move view in window, only move cursor to keep on screen
sk('n', '<C-h>', 'z4h', {noremap = true, desc = 'move view left 4 columns'})
sk('n', '<C-j>', '3<C-e>', {noremap = true, desc = 'move view down 3 lines'})
sk('n', '<C-k>', '3<C-y>', {noremap = true, desc = 'move view up 3 lines'})
sk('n', '<C-l>', 'z4l', {noremap = true, desc = 'move view right 4 colunms'})

-- Shift text and reselect
sk('v', '<', '<gv', {noremap=true, desc='shift left & reselect'})
sk('v', '>', '>gv', {noremap=true, desc='shift right & reselect'})

-- Normal mode leader keymappings
sk('n', '<leader>b', '<Cmd>enew<CR>', {noremap=true, desc ='new unnamed buffer'})
sk('n', '<leader>h', '<Cmd>TSBufToggle highlight<CR>', {noremap=true, desc ='treesitter highlight toggle'})
sk('n', '<leader>i', '<Cmd>set invspell<CR>', {noremap=true, desc ='toggle spelling'})
sk('n', '<leader>k', '<Cmd>dig<CR>a<C-k>', {noremap=true, desc ='pick & enter diagraph'})
sk('n', '<leader>l', '<Cmd>nohlsearch<Bar>diffupdate<CR>', {noremap=true, desc ='Clear hlsearch'})
sk('n', '<leader>r', '<Cmd>mode<CR>', {noremap=true, desc ='clear & redraw screen'})
sk('n', '<leader>w', '<Cmd>%s/\\s\\+$//<CR><C-o>', {noremap=true, desc ='trim trailing whitespace'})
sk('n', '<leader>n', '', {
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
sk('n', '<leader>fs', '<Cmd>split<Bar>term fish<CR>i', {noremap=true, desc ='fish shell in split'})
sk('n', '<leader>fv', '<Cmd>vsplit<Bar>term fish<CR>i', {noremap=true, desc ='fish shell in vsplit'})

if M.wk then
  local leader_mappings_labels = {
    f = { name = '+fish shell in terminal' }
  }
  wk.register(leader_mappings_labels, {prefix = '<leader>'})
end

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
