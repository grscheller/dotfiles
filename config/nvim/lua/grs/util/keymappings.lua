--[[ Setup keymappings/keybindings

     The only things this config file should do
     is setup WhichKey, define keymappings, define
     a couple of utility functions, and functions
     used by some of the keymappings. ]]

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

--[[ Define some utility functions ]]
local function setKM(mode, desc, kb, cmd)
   vim.api.nvim_set_keymap(mode, kb, cmd, {
      noremap = true,
      silent = true,
      desc = desc
   })
end

local function setCB(mode, desc, kb, callback)
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

-- Turn off some redundant motions
vim.keymap.set('n', '<BS>', '')
vim.keymap.set('n', '-', '')
vim.keymap.set('n', '+', '')

-- Creating, closing & navigating windows
vim.keymap.set('n', '<M-h>', '<C-w>h', {desc = 'goto window left'})
vim.keymap.set('n', '<M-j>', '<C-w>j', {desc = 'goto window below'})
vim.keymap.set('n', '<M-k>', '<C-w>k', {desc = 'goto window above'})
vim.keymap.set('n', '<M-l>', '<C-w>l', {desc = 'goto window right'})
vim.keymap.set('n', '<M-p>', '<C-w>p', {desc = 'goto previous window'})
vim.keymap.set('n', '<M-s>', '<C-w>s', {desc = 'split current window'})
vim.keymap.set('n', '<M-d>', '<C-w>v', {desc = 'vsplit current window'})
vim.keymap.set('n', '<M-f>', '<Cmd>split<Bar>term fish<CR>i', {desc = 'fish term in split'})
vim.keymap.set('n', '<M-g>', '<Cmd>vsplit<Bar>term fish<CR>i', {desc = 'fish term in vsplit'})
vim.keymap.set('n', '<M-o>', '<C-w>o', {desc = 'close other tab windows'})
vim.keymap.set('n', '<M-c>', '<C-w>c', {desc = 'close current window'})

-- Creating, closing & navigating tabpages
vim.keymap.set('n', '<C-n>', '<Cmd>tabnew<CR>', {desc = 'create new tab'})
vim.keymap.set('n', '<C-e>', '<Cmd>tabclose<CR>', {desc = 'close current tab'})
vim.keymap.set('n', '<C-b>', '<C-w>T', {desc = 'breakout window to new tab'})
vim.keymap.set('n', '<C-Left>', '<Cmd>tabprev<CR>', {desc = 'goto tab left'})
vim.keymap.set('n', '<C-Right>', '<Cmd>tabnext<CR>', {desc = 'goto tab right'})

-- Changing window layout
setKM('n', 'move window lhs', '<M-S-h>', '<C-w>H')
setKM('n', 'move window bot', '<M-S-j>', '<C-w>J')
setKM('n', 'move window top', '<M-S-k>', '<C-w>K')
setKM('n', 'move window rhs', '<M-S-l>', '<C-w>L')
setKM('n', 'exch window next', '<M-x>', '<C-w>x')
setKM('n', 'rotate inner split', '<M-r>', '<C-w>r')
setKM('n', 'equalize windows', '<M-e>', '<C-w>=')

-- Resizing windows
setKM('n', 'make window narrower', '<M-->', '2<C-w><') -- think Alt+Minus
setKM('n', 'make window wider', '<M-=>', '2<C-w>>') -- think Alt+Plus
setKM('n', 'make window shorter', '<M-_>', '2<C-w>-') -- think Alt+Shift+Minus
setKM('n', 'make window taller', '<M-+>', '2<C-w>+') -- think Alt+Shift+Plus

-- Move view in window, only move cursor to keep on screen
setKM('n', 'move view left 4 columns', '<C-h>', 'z4h')
setKM('n', 'move view down 3 lines', '<C-j>', '3<C-e>')
setKM('n', 'move view up 3 lines', '<C-k>', '3<C-y>')
setKM('n', 'move view right 4 colunms', '<C-l>', 'z4l')

-- Shift text and reselect
setKM('v', 'shift left & reselect', '<', '<gv')
setKM('v', 'shift right & reselect', '>', '>gv')

-- Misc keymappings
vim.keymap.set('n', 'z ', '<Cmd>set invspell<CR>', {desc = 'toggle spelling'})
vim.keymap.set('n', '  ', '<Cmd>nohlsearch<Bar>diffupdate<CR>', {desc = 'clear hlsearch'})
vim.keymap.set('n', ' b', '<Cmd>enew<CR>', {desc = 'new unnamed buffer'})
vim.keymap.set('n', ' k', '<Cmd>dig<CR>a<C-k>', {desc = 'pick & enter diagraph'})
vim.keymap.set('n', ' l', '<Cmd>mode<CR>', {desc = 'clear & redraw screen'})
vim.keymap.set('n', ' w', '<Cmd>%s/\\s\\+$//<CR><C-o>', {desc = 'trim trailing whitespace'})
vim.keymap.set('n', ' h', '<Cmd>TSBufToggle highlight<CR>', {desc = 'treesitter highlight toggle'})
vim.keymap.set('n', ' n', function()
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
end, {desc = 'line number toggle'})

--[[ LSP related keymappings ]]
function M.lsp_kb(client, bufnr)
   setCB('n', 'code action', '\\ca', vim.lsp.buf.code_action)
   setCB('n', 'code lens refresh', '\\clh', vim.lsp.codelens.refresh)
   setCB('n', 'code lens run', '\\clr', vim.lsp.codelens.run)
   setCB('n', 'buffer diagnostics', '\\D', vim.diagnostic.setloclist)
   setCB('n', 'format', '\\f', vim.lsp.buf.formatting)
   setCB('n', 'goto definition', '\\gd', vim.lsp.buf.definition)
   setCB('n', 'goto declaration', '\\gD', vim.lsp.buf.declaration)
   setCB('n', 'goto implementation', '\\gi', vim.lsp.buf.implementation)
   setCB('n', 'goto references', '\\gr', vim.lsp.buf.references)
   setCB('n', 'document symbol', '\\gsd', vim.lsp.buf.document_symbol)
   setCB('n', 'workspace symbol', '\\gsw', vim.lsp.buf.workspace_symbol)
   setCB('n', 'signatue help', '\\H', vim.lsp.buf.signatue_help)
   setCB('n', 'hover', '\\h', vim.lsp.buf.hover)
   setCB('n', 'hover_worksheet', '\\k', vim.lsp.buf.hover_worksheet)
   setCB('n', 'qflist ws diagnostics', '\\qd', vim.diagnostic.setqflist)
   setCB('n', 'qflist ws errors', '\\qe', function() vim.diagnostic.setqflist { severity = 'E' } end)
   setCB('n', 'qflist ws warnings', '\\qw', function() vim.diagnostic.setqflist { severity = 'W' } end)
   setCB('n', 'rename', '\\r', vim.lsp.buf.rename)
   setCB('n', 'add workspace folder', '\\wa', vim.lsp.buf.add_workspace_folder)
   setCB('n', 'rm workspace folder', '\\wr', vim.lsp.buf.remove_workspace_folder)
   setCB('n', 'diagnostic prev', '\\[', function() vim.diagnostic.goto_prev { wrap = false } end)
   setCB('n', 'diagnostic next', '\\]', function() vim.diagnostic.goto_next { wrap = false } end)

   local lsp_labels = {
      c = {
         name = 'code',
         l = { name = 'code lens' }
      },
      g = {
         name = 'goto',
         s = { name = 'symbol' }
      },
      q = { name = 'quickfix' },
      w = { name = 'workspace folder' }
   }

   if M.wk then
      wk.register(lsp_labels, { prefix = '\\', buffer = bufnr })
   end

   return client
end

--[[ DAP (Debug Adapter Protocol) related keybindings ]]
function M.dap_kb(bufnr)
   local dap = require('dap')
   local dapUiWidgets = require('dap.ui.widgets')
   setCB('n', 'dap continue', '\\dc', dap.continue)
   setCB('n', 'dap repl toggle', '\\dr', dap.repl.toggle)
   setCB('n', 'dap hover', '\\dh', dapUiWidgets.hover)
   setCB('n', 'dap toggle breakpoint', '\\dt', dap.toggle_breakpoint)
   setCB('n', 'dap step over', '\\do', dap.step_over)
   setCB('n', 'dap step into', '\\di', dap.step_into)
   setCB('n', 'dap run last', '\\dl', dap.run_last)

   local dap_labels = {
      d = { name = 'dap' }
   }

   if M.wk then
      wk.register(dap_labels, { prefix = '\\', buffer = bufnr })
   end
end

--[[ Scala Metals related keybindings ]]
function M.sm_kb(bufnr)
   local metals = require('metals')
   setCB('n', 'metals hover worksheet', '\\mh', metals.hover_worksheet)

   local metals_labels = {
      m = { name = 'metals' }
   }

   if M.wk then
      wk.register(metals_labels, { prefix = '\\', buffer = bufnr })
   end
end

--[[ Telescope related keybindings ]]
function M.telescope_keybindings()
   local tb = require('telescope.builtin')

   setKM('n', 'telescope command', '<Space>T', '<Cmd>Telescope<CR>')
   setCB('n', 'list buffers', '<Space>tbl', tb.buffers)
   setCB('n', 'fuzzy find curr buff', '<Space>tbz', tb.current_buffer_fuzzy_find)
   setCB('n', 'find file', '<Space>tff', tb.find_files)
   setCB('n', 'open recent file', '<Space>tfr', tb.oldfiles)
   setCB('n', 'live grep', '<Space>tgl', tb.live_grep)
   setCB('n', 'grep string', '<Space>tgs', tb.grep_string)
   setCB('n', 'help tags', '<Space>th', tb.help_tags)

   local telescope_labels = {
      t = {
         name = 'telescope',
         b = { name = 'telescope buffer' },
         f = { name = 'telescope files' },
         g = { name = 'telescope grep' }
      }
   }

   if M.wk then
      wk.register(telescope_labels, { prefix = '<Space>' })
   end
end

return M
