--[[ Define keymappings/keybindings - loaded on VeryLazy event ]]

-- loaded on "VeryLazy" event

local M = {}
local km = vim.keymap.set

--[[ Plugin related keymaps ]]

-- Lazy gui
km('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'lazy gui' })

-- Telescope related keymaps
km('n', '<leader>tt', '<cmd>Telescope<cr>', {
   noremap = true,
   silent = true,
   desc = 'telescope',
})

-- Treesitter related keymaps
km('n', '<leader>H', '<cmd>TSBufToggle highlight<cr>', {
   noremap = true,
   silent = true,
   desc = 'toggle treesitter highlighting',
})

--[[ Window/Tabpage related mappings/bindings ]]

-- Navigating windows
km('n', '<m-h>', '<c-w>h', { noremap = true, silent = true, desc = 'goto window left' })
km('n', '<m-j>', '<c-w>j', { noremap = true, silent = true, desc = 'goto window below' })
km('n', '<m-k>', '<c-w>k', { noremap = true, silent = true, desc = 'goto window above' })
km('n', '<m-l>', '<c-w>l', { noremap = true, silent = true, desc = 'goto window right' })
km('n', '<m-p>', '<c-w>p', { noremap = true, silent = true, desc = 'goto previous window' })

-- Creating new windows
km('n', '<m-s>', '<c-w>s', { noremap = true, silent = true, desc = 'split current window' })
km('n', '<m-d>', '<c-w>v', { noremap = true, silent = true, desc = 'vsplit current window' })
km('n', '<m-f>', '<cmd>split<bar>term fish<cr>i', {
   noremap = true,
   silent = true,
   desc = 'split fish term',
})
km('n', '<m-g>', '<cmd>vsplit<bar>term fish<cr>i', {
   noremap = true,
   silent = true,
   desc = 'vsplit fish term',
})

-- Changing window layout
km('n', '<m-s-h>', '<c-w>H', { noremap = true, silent = true, desc = 'move window lhs' })
km('n', '<m-s-j>', '<c-w>J', { noremap = true, silent = true, desc = 'move window bottom' })
km('n', '<m-s-k>', '<c-w>K', { noremap = true, silent = true, desc = 'move window top' })
km('n', '<m-s-l>', '<c-w>L', { noremap = true, silent = true, desc = 'move window rhs' })
km('n', '<m-e>', '<c-w>=',   { noremap = true, silent = true, desc = 'equalize windows' })

-- Resizing windows
km('n', '<m-left>',  '2<c-w><', { noremap = true, silent = true, desc = 'make window narrower' })
km('n', '<m-right>', '2<c-w>>', { noremap = true, silent = true, desc = 'make window wider' })
km('n', '<m-down>',  '2<c-w>-', { noremap = true, silent = true, desc = 'make window shorter' })
km('n', '<m-up>',    '2<c-w>+', { noremap = true, silent = true, desc = 'make window taller' })

-- Move view in window, only move cursor to keep on screen
km('n', '<c-h>', 'z4h',    { noremap = true, silent = true, desc = 'move view left 4 columns' })
km('n', '<c-j>', '3<c-e>', { noremap = true, silent = true, desc = 'move view down 3 lines' })
km('n', '<c-k>', '3<c-y>', { noremap = true, silent = true, desc = 'move view up 3 lines' })
km('n', '<c-l>', 'z4l',    { noremap = true, silent = true, desc = 'move view right 4 columns' })

-- Managing tabpages
km('n', '<c-right>', '<cmd>tabnext<cr>',  { noremap = true, silent = true, desc = 'goto next tab' })
km('n', '<c-left>',  '<cmd>tabprev<cr>',  { noremap = true, silent = true, desc = 'goto prev tab' })
km('n', '<c-up>',    '<cmd>tabfirst<cr>', { noremap = true, silent = true, desc = 'goto first tab' })
km('n', '<c-down>',  '<cmd>tablast<cr>',  { noremap = true, silent = true, desc = 'goto last tab' })
km('n', '<m-n>',     '<cmd>tabnew<cr>',   { noremap = true, silent = true, desc = 'create new tab' })
km('n', '<m-t>', '<c-w>T', { noremap = true, silent = true, desc = 'breakout window new tab' })
km('n', '<m-c>', '<c-w>c', { noremap = true, silent = true, desc = 'close current window' })
km('n', '<m-o>', '<c-w>o', { noremap = true, silent = true, desc = 'close other tab windows' })

--[[ Launch external programs ]]

km('n', '<leader>f', '<cmd>!fish -c fishterm<cr><cr>', {
   noremap = true,
   silent = true,
   desc = 'launch fish shell in alacritty'
})

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
   noremap = true,
   silent = true,
   desc = 'toggle line numbering',
})

-- Delete & change text without affecting default register
km({ 'n', 'x' }, ',d', '"_d', {
   noremap = true,
   silent = true,
   desc = 'delete text to blackhole register',
})
km({ 'n', 'x' }, ',c', '"_c', {
   noremap = true,
   silent = true,
   desc = 'change text to blackhole register',
})

-- Yank, delete, change & paste with system clipboard
km({ 'n', 'x' }, ',sy', '"+y', {
   noremap = true,
   silent = true,
   desc = 'yank to system clipboard',
})
km({ 'n', 'x' }, ',sd', '"+d', {
   noremap = true,
   silent = true,
   desc = 'delete to system clipboard',
})
km({ 'n', 'x' }, ',sc', '"+c', {
   noremap = true,
   silent = true,
   desc = 'change with system clipboard',
})
km({ 'n', 'x' }, ',sp', '"+p', {
   noremap = true,
   silent = true,
   desc = 'paste after cursor from system clipboard',
})
km({ 'n', 'x' }, ',sP', '"+P', {
   noremap = true,
   silent = true,
   desc = 'paste before cursor from system clipboard',
})

-- Shift line and reselect
km('x', '<', '<gv', { noremap = true, silent = true, desc = 'shift left & reselect' })
km('x', '>', '>gv', { noremap = true, silent = true, desc = 'shift right & reselect' })

-- Move visual selection up or down a line
km('x', 'J', ":m '>+1<cr>gv=gv", {
   noremap = true,
   silent = true,
   desc = 'move selection down a line',
})
km('x', 'K', ":m '<-2<cr>gv=gv", {
   noremap = true,
   silent = true,
   desc = 'move selection up a line',
})

-- Cleanup related keymaps
km('n', '<leader>w', '<cmd>%s/\\s\\+$//<cr><c-o>', {
   noremap = true,
   silent = true,
   desc = 'trim trailing whitespace',
})
km('n', '<esc>', '<cmd>noh<bar>mode<cr><esc>', {
   noremap = true,
   silent = true,
   desc = 'rm hlsearch & redraw on ESC',
})

-- Buffer related keymaps
km('n', '<leader>b', '<cmd>enew<cr>', {
   noremap = true,
   silent = true,
   desc = 'new unnamed buffer',
})

-- Spelling related keymaps
km('n', 'z ', '<cmd>set invspell<cr>', {
   noremap = true,
   silent = true,
   desc = 'toggle spelling',
})

-- Character related keymaps
km('n', '<leader>K', '<cmd>dig<cr>a<c-k>', {
   noremap = true,
   silent = true,
   desc = 'pick & enter diagraph',
})
km('n', '<leader>u', 'a<c-v>u', {
   noremap = true,
   silent = true,
   desc = 'enter unicode code point in hex',
})

--[[ LSP related keymaps ]]
km('n', 'zd', vim.diagnostic.setloclist, {
   noremap = true,
   silent = true,
   desc = 'buffer diagnostics',
})
km('n', 'g[', vim.diagnostic.goto_prev, {
   noremap = true,
   silent = true,
   desc = 'goto prev diagostic',
})
km('n', 'g]', vim.diagnostic.goto_next, {
   noremap = true,
   silent = true,
   desc = 'goto next diagostic',
})
function M.lsp(bufnr)
   km('n', 'H', vim.lsp.buf.hover, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'hover',
   })
   km('n', 'K', vim.lsp.buf.signature_help, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'signature help',
   })
   km('n', 'gd', vim.lsp.buf.definition, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto definition',
   })
   km('n', 'gD', vim.lsp.buf.declaration, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto declaration',
   })
   km('n', 'gI', vim.lsp.buf.implementation, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto implementation',
   })
   km('n', 'gr', vim.lsp.buf.references, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto references',
   })
   km('n', 'gt', vim.lsp.buf.type_definition, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto type definition',
   })
   km('n', 'gW', vim.lsp.buf.workspace_symbol, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'workspace symbol',
   })
   km('n', 'g0', vim.lsp.buf.document_symbol, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'document symbol',
   })
   km('n', 'za', vim.lsp.buf.code_action, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'code action',
   })
   km('n', 'zh', vim.lsp.codelens.refresh, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'code lens refresh',
   })
   km('n', 'zl', vim.lsp.codelens.run, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'code lens run',
   })
   km('n', 'zr', vim.lsp.buf.rename, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'rename',
   })
   km('n', 'zA', vim.lsp.buf.add_workspace_folder, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'add workspace folder',
   })
   km('n', 'zR', vim.lsp.buf.remove_workspace_folder, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'remove workspace folder',
   })
   km({ 'n', 'x' }, 'zF', vim.lsp.buf.format, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'lsp format',
   })
end

-- Haskell related keymaps
function M.haskell(bufnr)
   km({ 'n', 'x' }, 'zS', '<cmd>%!stylish-haskell<cr>', {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'stylish haskell format',
   })
end

-- Rust-Tools related keymaps
function M.rust(bufnr, rt)
   km('n', 'zH', rt.hover_actions.hover_actions, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'rust hover actions',
   })
   km('n', 'zA', rt.code_action_group.code_action_group, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'rust code action group',
   })
end

-- Scala Metals related keymaps
function M.metals(bufnr, metals)
   km('n', 'zH', metals.hover_worksheet, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'metals hover worksheet',
   })
end

--[[ DAP (Debug Adapter Protocol) related kemaps ]]

function M.dap(bufnr, dap, dap_ui_widgets)
   km('n', '\\c', dap.continue, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap continue',
   })
   km('n', '\\h', dap_ui_widgets.hover, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap hover',
   })
   km('n', '\\l', dap.run_last, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap run last',
   })
   km('n', '\\o', dap.step_over, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap step over',
   })
   km('n', '\\i', dap.step_into, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap step into',
   })
   km('n', '\\b', dap.toggle_breakpoint, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap toggle breakpoint',
   })
   km('n', '\\r', dap.repl.toggle, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap repl toggle',
   })
end

return M
