--[[ Define keymappings/keybindings - loaded via plugins/config.lua ]]

-- loaded on "VeryLazy" event

local km = vim.keymap.set

--[[ Window/Tabpage related mappings/bindings ]]

-- Navigating windows
km('n', '<m-h>', '<c-w>h', { desc = 'goto window left' })
km('n', '<m-j>', '<c-w>j', { desc = 'goto window below' })
km('n', '<m-k>', '<c-w>k', { desc = 'goto window above' })
km('n', '<m-l>', '<c-w>l', { desc = 'goto window right' })
km('n', '<m-p>', '<c-w>p', { desc = 'goto previous window' })

-- Creating new windows
km('n', '<m-s>', '<c-w>s', { desc = 'split current window' })
km('n', '<m-d>', '<c-w>v', { desc = 'vsplit current window' })
km('n', '<m-f>', '<cmd>split<bar>term fish<cr>i', { desc = 'split fish term' })
km('n', '<m-g>', '<cmd>vsplit<bar>term fish<cr>i', { desc = 'vsplit fish term' })

-- Changing window layout
km('n', '<m-s-h>', '<c-w>H', { desc = 'move window lhs' })
km('n', '<m-s-j>', '<c-w>J', { desc = 'move window bottom' })
km('n', '<m-s-k>', '<c-w>K', { desc = 'move window top' })
km('n', '<m-s-l>', '<c-w>L', { desc = 'move window rhs' })
km('n', '<m-x>', '<c-w>x', { desc = 'exchange window next' })
km('n', '<m-r>', '<c-w>r', { desc = 'rotate inner split' })
km('n', '<m-e>', '<c-w>=', { desc = 'equalize windows' })

-- Resizing windows
-- Think: Alt+Minus Alt+Plus Alt+Shift+Minus Alt+Shift+Plus
km('n', '<m-->', '2<c-w><', { desc = 'make window narrower' })
km('n', '<m-=>', '2<c-w>>', { desc = 'make window wider' })
km('n', '<m-_>', '2<c-w>-', { desc = 'make window shorter' })
km('n', '<m-+>', '2<c-w>+', { desc = 'make window taller' })

-- Move view in window, only move cursor to keep on screen
km('n', '<c-h>', 'z4h', { desc = 'move view left 4 columns' })
km('n', '<c-j>', '3<c-e>', { desc = 'move view down 3 lines' })
km('n', '<c-k>', '3<c-y>', { desc = 'move view up 3 lines' })
km('n', '<c-l>', 'z4l', { desc = 'move view right 4 columns' })

-- Managing tabpages
km('n', '<c-right>', '<cmd>tabnext<cr>', { desc = 'goto next tab' })
km('n', '<c-left>', '<cmd>tabprev<cr>', { desc = 'goto prev tab' })
km('n', '<c-up>', '<cmd>tabfirst<cr>', { desc = 'goto first tab' })
km('n', '<c-down>', '<cmd>tablast<cr>', { desc = 'goto last tab' })
km('n', '<m-n>', '<cmd>tabnew<cr>', { desc = 'create new tab' })
km('n', '<m-b>', '<c-w>T', { desc = 'breakout window new tab' })
km('n', '<m-c>', '<c-w>c', { desc = 'close current window' })
km('n', '<m-o>', '<c-w>o', { desc = 'close other tab windows' })

--[[ Text editting keymaps not related to any specific plugins ]]

-- toggle line numberings schemes
local function toggle_line_numbering()
   if not vim.wo.number and not vim.wo.relativenumber then
      vim.wo.number = true
      vim.wo.relativenumber = true
   elseif vim.wo.number and vim.wo.relativenumber then
      vim.wo.relativenumber = false
   else
      vim.wo.number = false
      vim.wo.relativenumber = false
   end
end

km('n', '<leader>n', toggle_line_numbering, {
   desc = 'toggle line numbering',
})

-- Delete & change text without affecting default register
km({ 'n', 'x' }, '<leader>d', '"_d', {
   desc = 'delete text to blackhole register',
})
km({ 'n', 'x' }, '<leader>c', '"_c', {
   desc = 'change text to blackhole register',
})

-- Yank, delete, change & paste with system clipboard
km({ 'n', 'x' }, '<leader>sy', '"+y', { desc = 'yank to system clipboard' })
km({ 'n', 'x' }, '<leader>sd', '"+d', { desc = 'delete to system clipboard' })
km({ 'n', 'x' }, '<leader>sc', '"+c', { desc = 'change with system clipboard' })
km({ 'n', 'x' }, '<leader>sp', '"+p', { desc = 'paste from system clipboard' })

-- Shift line and reselect
km('x', '<', '<gv', { desc = 'shift left & reselect' })
km('x', '>', '>gv', { desc = 'shift right & reselect' })

-- Move visual selection up or down a line
km('x', 'J', ":m '>+1<cr>gv=gv", { desc = 'move selection down a line' })
km('x', 'K', ":m '<-2<cr>gv=gv", { desc = 'move selection up a line' })

-- Cleanup related keymaps
km('n', '<leader>w', '<cmd>%s/\\s\\+$//<cr><c-o>', { desc = 'trim trailing whitespace' })
km('n', "<esc>", "<cmd>noh<bar>mode<cr><esc>", { desc = "rm hlsearch & redraw on ESC" })

-- Buffer related keymaps
km('n', '<leader>b', '<cmd>enew<cr>', { desc = 'new unnamed buffer' })

-- treesitter related keymaps
km('n', '<leader>H', '<cmd>TSBufToggle highlight<cr>', { desc = 'toggle treesitter', })

-- spelling related keymaps
km('n', 'z ', '<cmd>set invspell<cr>', { desc = 'toggle spelling' })

-- character related keymaps
km('n', '<leader>K', '<cmd>dig<cr>a<c-k>', { desc = 'pick & enter diagraph' })
km('n', '<leader>u', 'a<c-v>u', { desc = 'enter unicode code point in hex' })

local M = {}

--LSP related keymaps
function M.lsp_km(_, bufnr)
   km('n', 'H', vim.lsp.buf.hover, {
      buffer = bufnr,
      desc = 'hover',
   })
   km('n', 'K', vim.lsp.buf.signature_help, {
      buffer = bufnr,
      desc = 'signature help',
   })
   km('n', 'zd', vim.diagnostic.setloclist, {
      buffer = bufnr,
      desc = 'buffer diagnostics',
   })
   km('n', 'g[', vim.diagnostic.goto_prev, {
      buffer = bufnr,
      desc = 'goto prev diagostic',
   })
   km('n', 'g]', vim.diagnostic.goto_next, {
      buffer = bufnr,
      desc = 'goto next diagostic',
   })
   km('n', 'gd', vim.lsp.buf.definition, {
      buffer = bufnr,
      desc = 'goto definition',
   })
   km('n', 'gD', vim.lsp.buf.declaration, {
      buffer = bufnr,
      desc = 'goto declaration',
   })
   km('n', 'gI', vim.lsp.buf.implementation, {
      buffer = bufnr,
      desc = 'goto implementation',
   })
   km('n', 'gr', vim.lsp.buf.references, {
      buffer = bufnr,
      desc = 'goto references',
   })
   km('n', 'gt', vim.lsp.buf.type_definition, {
      buffer = bufnr,
      desc = 'goto type definition',
   })
   km('n', 'gW', vim.lsp.buf.workspace_symbol, {
      buffer = bufnr,
      desc = 'workspace symbol',
   })
   km('n', 'g0', vim.lsp.buf.document_symbol, {
      buffer = bufnr,
      desc = 'document symbol',
   })
   km('n', 'za', vim.lsp.buf.code_action, {
      buffer = bufnr,
      desc = 'code action',
   })
   km('n', 'zh', vim.lsp.codelens.refresh, {
      buffer = bufnr,
      desc = 'code lens refresh',
   })
   km('n', 'zl', vim.lsp.codelens.run, {
      buffer = bufnr,
      desc = 'code lens run',
   })
   km('n', 'zr', vim.lsp.buf.rename, {
      buffer = bufnr,
      desc = 'rename',
   })
   km('n', 'zA', vim.lsp.buf.add_workspace_folder, {
      buffer = bufnr,
      desc = 'add workspace folder',
   })
   km('n', 'zR', vim.lsp.buf.remove_workspace_folder, {
      buffer = bufnr,
      desc = 'remove workspace folder',
   })
   km({ 'n', 'x' }, 'zF', vim.lsp.buf.format, {
      buffer = bufnr,
      desc = 'lsp format',
   })
end

-- Haskell related keymaps
function M.haskell_km(bufnr)
   km({ 'n', 'x' }, 'zH', '<cmd>%!stylish-haskell<cr>', {
      desc = 'stylish haskell format',
      buffer = bufnr,
   })
end

-- Scala Metals related keymaps
function M.metals_km(bufnr, metals)
   km('n', 'M', metals.hover_worksheet, {
      desc = 'metals hover worksheet',
      buffer = bufnr,
   })
end

-- DAP (Debug Adapter Protocol) related kemaps
function M.dap_km(bufnr, dap, dap_ui_widgets)
   require('which-key').register(
      { name = 'dap' },
      { buffer = bufnr, prefix = '\\' }
   )

   km('n', '\\c', dap.continue, {
      buffer = bufnr,
      desc = 'dap continue',
   })
   km('n', '\\h', dap_ui_widgets.hover, {
      buffer = bufnr,
      desc = 'dap hover',
   })
   km('n', '\\l', dap.run_last, {
      buffer = bufnr,
      desc = 'dap run last',
   })
   km('n', '\\o', dap.step_over, {
      buffer = bufnr,
      desc = 'dap step over',
   })
   km('n', '\\i', dap.step_into, {
      buffer = bufnr,
      desc = 'dap step into',
   })
   km('n', '\\b', dap.toggle_breakpoint, {
      buffer = bufnr,
      desc = 'dap toggle breakpoint',
   })
   km('n', '\\r', dap.repl.toggle, {
      buffer = bufnr,
      desc = 'dap repl toggle',
   })
end

return M
