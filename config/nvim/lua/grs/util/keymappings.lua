--[[ Setup keymappings/keybinding

     The only things this config file should do
     is setup WhichKey and define keymappings.

     Not all keymapping need be defined here, just
     those that help declutter other config files. ]]

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
vim.keymap.set('n', '<M-S-h>', '<C-w>H', {desc = 'move window lhs'})
vim.keymap.set('n', '<M-S-j>', '<C-w>J', {desc = 'move window bottom'})
vim.keymap.set('n', '<M-S-k>', '<C-w>K', {desc = 'move window top'})
vim.keymap.set('n', '<M-S-l>', '<C-w>L', {desc = 'move window rhs'})
vim.keymap.set('n', '<M-x>', '<C-w>x', {desc = 'exchange window next'})
vim.keymap.set('n', '<M-r>', '<C-w>r', {desc = 'rotate inner split'})
vim.keymap.set('n', '<M-e>', '<C-w>=', {desc = 'equalize windows'})

-- Resizing windows - Alt+Minus Alt+Plus Alt+Shift+Minus Alt+Shift+Plus
vim.keymap.set('n', '<M-->', '2<C-w><', {desc = 'make window narrower'})
vim.keymap.set('n', '<M-=>', '2<C-w>>', {desc = 'make window wider'})
vim.keymap.set('n', '<M-_>', '2<C-w>-', {desc = 'make window shorter'})
vim.keymap.set('n', '<M-+>', '2<C-w>+', {desc = 'make window taller'})

-- Move view in window, only move cursor to keep on screen
vim.keymap.set('n', '<C-h>', 'z4h', {desc = 'move view left 4 columns'})
vim.keymap.set('n', '<C-j>', '3<C-e>', {desc = 'move view down 3 lines'})
vim.keymap.set('n', '<C-k>', '3<C-y>', {desc = 'move view up 3 lines'})
vim.keymap.set('n', '<C-l>', 'z4l', {desc = 'move view right 4 columns'})

-- Shift text and reselect
vim.keymap.set('v', '<', '<gv', {desc = 'shift left & reselect'})
vim.keymap.set('v', '>', '>gv', {desc = 'shift right & reselect'})

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
-- The below keymappings may be out of date.
--
-- See https://github.com/neovim/nvim-lspconfig
-- and https://github.com/sharksforarms/neovim-rust
--
function M.lsp_kb(client, bufnr)
   vim.keymap.set('n', '\\ca', vim.lsp.buf.code_action, { desc = 'code action' })
   vim.keymap.set('n', '\\clh', vim.lsp.codelens.refresh, { desc = 'code lens refresh' })
   vim.keymap.set('n', '\\clr', vim.lsp.codelens.run, { desc = 'code lens run' })
   vim.keymap.set('n', '\\D', vim.diagnostic.setloclist, { desc = 'buffer diagnostics' })
   vim.keymap.set('n', '\\f', vim.lsp.buf.formatting, { desc = 'format' })
   vim.keymap.set('n', '\\gd', vim.lsp.buf.definition, { desc = 'goto definition' })
   vim.keymap.set('n', '\\gD', vim.lsp.buf.declaration, { desc = 'goto declaration' })
   vim.keymap.set('n', '\\gi', vim.lsp.buf.implementation, { desc = 'goto implementation' })
   vim.keymap.set('n', '\\gr', vim.lsp.buf.references, { desc = 'goto references' })
   vim.keymap.set('n', '\\gsd', vim.lsp.buf.document_symbol, { desc = 'document symbol' })
   vim.keymap.set('n', '\\gsw', vim.lsp.buf.workspace_symbol, { desc = 'workspace symbol' })
   vim.keymap.set('n', '\\H', vim.lsp.buf.signature_help, { desc = 'signature help' })
   vim.keymap.set('n', '\\h', vim.lsp.buf.hover, { desc = 'hover' })
   vim.keymap.set('n', '\\qd', vim.diagnostic.setqflist, { desc = 'qf list ws diagnostics' })
   vim.keymap.set('n', '\\qe', function() vim.diagnostic.setqflist { severity = 'E' } end, { desc = 'qf list ws errors' })
   vim.keymap.set('n', '\\qw', function() vim.diagnostic.setqflist { severity = 'W' } end, { desc = 'qf list ws warnings' })
   vim.keymap.set('n', '\\r', vim.lsp.buf.rename, {desc = 'rename' })
   vim.keymap.set('n', '\\wa', vim.lsp.buf.add_workspace_folder, { desc = 'add workspace folder' })
   vim.keymap.set('n', '\\wr', vim.lsp.buf.remove_workspace_folder, { desc = 'remove workspace folder' })
   vim.keymap.set('n', '\\[', function() vim.diagnostic.goto_prev { wrap = false } end, { desc = 'diagnostic goto previous' })
   vim.keymap.set('n', '\\]', function() vim.diagnostic.goto_next { wrap = false } end, { desc = 'diagnostic goto next' })

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
   vim.keymap.set('n', '\\db', dap.toggle_breakpoint, {desc = 'dap toggle breakpoint'})
   vim.keymap.set('n', '\\dc', dap.continue, {desc = 'dap continue'})
   vim.keymap.set('n', '\\dh', dapUiWidgets.hover, {desc = 'dap hover'})
   vim.keymap.set('n', '\\dl', dap.run_last, {desc = 'dap run last'})
   vim.keymap.set('n', '\\dr', dap.repl.toggle, {desc = 'dap repl toggle'})
   vim.keymap.set('n', '\\dso', dap.step_over, {desc = 'dap step over'})
   vim.keymap.set('n', '\\dsi', dap.step_into, {desc = 'dap step into'})

   local dap_labels = {
      d = {
         name = 'dap',
         s = { name = 'step' }
      }
   }

   if M.wk then
      wk.register(dap_labels, { prefix = '\\', buffer = bufnr })
   end
end

--[[ Scala Metals related keybindings ]]
function M.sm_kb(bufnr)
   local metals = require('metals')
   vim.keymap.set('n', '\\mh', metals.hover_worksheet, {desc = 'metals hover worksheet'})

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

   vim.keymap.set('n', ' T', '<Cmd>Telescope<CR>', {desc = 'telescope command'})
   vim.keymap.set('n', ' tbl', tb.buffers, {desc = 'list buffers'})
   vim.keymap.set('n', ' tbz', tb.current_buffer_fuzzy_find, {desc = 'fuzzy find current buffer'})
   vim.keymap.set('n', ' tff', tb.find_files, {desc = 'find files'})
   vim.keymap.set('n', ' tfr', tb.oldfiles, {desc = 'find recent files'})
   vim.keymap.set('n', ' tgl', tb.live_grep, {desc = 'live grep'})
   vim.keymap.set('n', ' tgs', tb.grep_string, {desc = 'grep string'})
   vim.keymap.set('n', ' th', tb.help_tags, {desc = 'help tags'})

   local telescope_labels = {
      t = {
         name = 'telescope',
         b = { name = 'telescope buffers' },
         f = { name = 'telescope files' },
         g = { name = 'telescope grep' }
      }
   }

   if M.wk then
      wk.register(telescope_labels, { prefix = '<Space>' })
   end
end

return M
