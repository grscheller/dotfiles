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
   print('Problem loading which-key.nvim: %s', wk)
end

--[[ Set key mappings/bindings lu]]

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
vim.keymap.set('x', '<', '<gv', {desc = 'shift left & reselect'})
vim.keymap.set('x', '>', '>gv', {desc = 'shift right & reselect'})

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

--[[ Telescope related keybindings ]]
function M.telescope_keybindings()
   local ts = require('telescope')
   local tb = require('telescope.builtin')
   local tfb = ts.extensions.file_browser
   local tfq = ts.extensions.frecency

   -- telescope
   vim.keymap.set('n', '<C-t>t', '<Cmd>Telescope<CR>', {desc = 'telescope command'})
   vim.keymap.set('n', '<C-t>bl', tb.buffers, {desc = 'list buffers'})
   vim.keymap.set('n', '<C-t>bz', tb.current_buffer_fuzzy_find, {desc = 'fuzzy find current buffer'})
   vim.keymap.set('n', '<C-t>ff', tb.find_files, {desc = 'find files'})
   vim.keymap.set('n', '<C-t>fr', tb.oldfiles, {desc = 'find recent files'})
   vim.keymap.set('n', '<C-t>gl', tb.live_grep, {desc = 'live grep'})
   vim.keymap.set('n', '<C-t>gs', tb.grep_string, {desc = 'grep string'})
   vim.keymap.set('n', '<C-t>h',  tb.help_tags, {desc = 'help tags'})

   -- telescope-file-browser
   vim.keymap.set('n', '<C-t>fb', tfb.file_browser, {desc = 'telescope file browser'})

   -- telescope-frecency
   vim.keymap.set('n', '<C-t>fq', tfq.frecency, {desc = 'telescope frecency'})

   if M.wk then
      local telescope_labels = {
         name = 'telescope',
         b = { name = 'telescope buffers' },
         f = { name = 'telescope files' },
         g = { name = 'telescope grep' }
      }

      wk.register(telescope_labels, { prefix = '<C-t>' })
   end
end

--[[ LSP related keymappings ]]
-- The below keymappings may be out of date.
--
-- See https://github.com/neovim/nvim-lspconfig
-- and https://github.com/sharksforarms/neovim-rust
--
function M.lsp_kb(client, bufnr)
   vim.keymap.set('n', '\\ca', vim.lsp.buf.code_action, {desc = 'code action', buffer = bufnr})
   vim.keymap.set('n', '\\clh', vim.lsp.codelens.refresh, {desc = 'code lens refresh', buffer = bufnr})
   vim.keymap.set('n', '\\clr', vim.lsp.codelens.run, {desc = 'code lens run', buffer = bufnr})
   vim.keymap.set('n', '\\D', vim.diagnostic.setloclist, {desc = 'buffer diagnostics', buffer = bufnr})
   vim.keymap.set('n', '\\ff', vim.lsp.buf.formatting, {desc = 'format', buffer = bufnr})
   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = 'goto definition', buffer = bufnr})
   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {desc = 'goto declaration', buffer = bufnr})
   vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, {desc = 'goto implementation', buffer = bufnr})
   vim.keymap.set('n', 'gr', vim.lsp.buf.references, {desc = 'goto references', buffer = bufnr})
   vim.keymap.set('n', 'gsd', vim.lsp.buf.document_symbol, {desc = 'document symbol', buffer = bufnr})
   vim.keymap.set('n', 'gsw', vim.lsp.buf.workspace_symbol, {desc = 'workspace symbol', buffer = bufnr})
   vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, {desc = 'goto type definition', buffer = bufnr})
   vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {desc = 'signature help', buffer = bufnr})
   vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc = 'hover', buffer = bufnr})
   vim.keymap.set('n', '\\qd', vim.diagnostic.setqflist, {desc = 'qf list ws diagnostics', buffer = bufnr})
   vim.keymap.set('n', '\\qe', function() vim.diagnostic.setqflist {severity = 'E'} end, {desc = 'qf list ws errors', buffer = bufnr})
   vim.keymap.set('n', '\\qw', function() vim.diagnostic.setqflist {severity = 'W'} end, {desc = 'qf list ws warnings', buffer = bufnr})
   vim.keymap.set('n', '\\r', vim.lsp.buf.rename, {desc = 'rename', buffer = bufnr})
   vim.keymap.set('n', '\\wa', vim.lsp.buf.add_workspace_folder, {desc = 'add workspace folder', buffer = bufnr})
   vim.keymap.set('n', '\\wr', vim.lsp.buf.remove_workspace_folder, {desc = 'remove workspace folder', buffer = bufnr})
   vim.keymap.set('n', '\\[', function() vim.diagnostic.goto_prev {wrap = false} end, {desc = 'diagnostic goto previous', buffer = bufnr})
   vim.keymap.set('n', '\\]', function() vim.diagnostic.goto_next {wrap = false} end, {desc = 'diagnostic goto next', buffer = bufnr})

   if M.wk then
      local lsp_labels_1 = {
         g = {
            name = 'goto',
            s = { name = 'symbol' }
         }
      }

      local lsp_labels_2 = {
         c = {
            name = 'code',
            l = { name = 'code lens' }
         },
         f = { name = 'format' },
         q = { name = 'quickfix' },
         w = { name = 'workspace folder' }
      }

      wk.register(lsp_labels_1, { buffer = bufnr })
      wk.register(lsp_labels_2, { prefix = '\\', buffer = bufnr })
   end

   return client
end

--[[ Haskell related keybindings ]]
function M.haskell_kb(bufnr)
   vim.keymap.set('n', '\\fs', '<Cmd>%!stylish-haskell<CR>', {desc = 'stylish-haskell', buffer = bufnr})
end

--[[ Scala Metals related keybindings ]]
function M.sm_kb(bufnr)
   local metals = require('metals')
   vim.keymap.set('n', 'mK', metals.hover_worksheet, {desc = 'metals hover worksheet', buffer = bufnr})

   if M.wk then
      local metals_labels = {
         m = { name = 'metals' }
      }

      wk.register(metals_labels, { buffer = bufnr })
   end
end

--[[ DAP (Debug Adapter Protocol) related keybindings ]]
function M.dap_kb(bufnr)
   local dap = require('dap')
   local dapUiWidgets = require('dap.ui.widgets')
   vim.keymap.set('n', '\\db', dap.toggle_breakpoint, {desc = 'dap toggle breakpoint', buffer = bufnr})
   vim.keymap.set('n', '\\dc', dap.continue, {desc = 'dap continue', buffer = bufnr})
   vim.keymap.set('n', '\\dh', dapUiWidgets.hover, {desc = 'dap hover', buffer = bufnr})
   vim.keymap.set('n', '\\dl', dap.run_last, {desc = 'dap run last', buffer = bufnr})
   vim.keymap.set('n', '\\dr', dap.repl.toggle, {desc = 'dap repl toggle', buffer = bufnr})
   vim.keymap.set('n', '\\dso', dap.step_over, {desc = 'dap step over', buffer = bufnr})
   vim.keymap.set('n', '\\dsi', dap.step_into, {desc = 'dap step into', buffer = bufnr})

   if M.wk then
      local dap_labels = {
         d = {
            name = 'dap',
            s = { name = 'step' }
         }
      }

      wk.register(dap_labels, { prefix = '\\', buffer = bufnr })
   end
end

return M
