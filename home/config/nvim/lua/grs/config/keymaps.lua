--[[ Define keybindings/keymappings ]]

local kmap = vim.keymap.set

--[[ Window/Tab related mappings/bindings ]]

-- Navigating windows
kmap('n', '<M-h>', '<C-w>h', { desc = 'goto window left' })
kmap('n', '<M-j>', '<C-w>j', { desc = 'goto window below' })
kmap('n', '<M-k>', '<C-w>k', { desc = 'goto window above' })
kmap('n', '<M-l>', '<C-w>l', { desc = 'goto window right' })
kmap('n', '<M-p>', '<C-w>p', { desc = 'goto previous window' })

-- Creating new windows
kmap('n', '<M-s>', '<C-w>s', { desc = 'split current window' })
kmap('n', '<M-d>', '<C-w>v', { desc = 'vsplit current window' })
kmap('n', '<M-f>', '<Cmd>split<Bar>term fish<CR>i', {
   desc = 'fish term in split',
})
kmap('n', '<M-g>', '<Cmd>vsplit<Bar>term fish<CR>i', {
   desc = 'fish term in vsplit',
})

-- Changing window layout
kmap('n', '<M-S-h>', '<C-w>H', { desc = 'move window lhs' })
kmap('n', '<M-S-j>', '<C-w>J', { desc = 'move window bottom' })
kmap('n', '<M-S-k>', '<C-w>K', { desc = 'move window top' })
kmap('n', '<M-S-l>', '<C-w>L', { desc = 'move window rhs' })
kmap('n', '<M-x>', '<C-w>x', { desc = 'exchange window next' })
kmap('n', '<M-r>', '<C-w>r', { desc = 'rotate inner split' })
kmap('n', '<M-e>', '<C-w>=', { desc = 'equalize windows' })

-- Resizing windows
-- Think: Alt+Minus Alt+Plus Alt+Shift+Minus Alt+Shift+Plus
kmap('n', '<M-->', '2<C-w><', { desc = 'make window narrower' })
kmap('n', '<M-=>', '2<C-w>>', { desc = 'make window wider' })
kmap('n', '<M-_>', '2<C-w>-', { desc = 'make window shorter' })
kmap('n', '<M-+>', '2<C-w>+', { desc = 'make window taller' })

-- Move view in window, only move cursor to keep on screen
kmap('n', '<C-h>', 'z4h', { desc = 'move view left 4 columns' })
kmap('n', '<C-j>', '3<C-e>', { desc = 'move view down 3 lines' })
kmap('n', '<C-k>', '3<C-y>', { desc = 'move view up 3 lines' })
kmap('n', '<C-l>', 'z4l', { desc = 'move view right 4 columns' })

-- Managing tabpages
kmap('n', '<M-Left>', '<Cmd>tabprev<CR>', { desc = 'goto tab left' })

kmap('n', '<M-Right>', '<Cmd>tabnext<CR>', { desc = 'goto tab right' })
kmap('n', '<M-n>', '<Cmd>tabnew<CR>', { desc = 'create new tab' })
kmap('n', '<M-t>', '<C-w>T', { desc = 'breakout window new tab' })
kmap('n', '<M-c>', '<C-w>c', { desc = 'close current window' })
kmap('n', '<M-o>', '<C-w>o', { desc = 'close other tab windows' })

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

kmap('n', ' n', toggle_line_numbering, {
   desc = 'toggle line numbering',
})

-- Delete & change text without affecting default register
kmap({ 'n', 'x' }, ' d', '"_d', {
   desc = 'delete text to blackhole register',
})
kmap({ 'n', 'x' }, ' c', '"_c', {
   desc = 'change text to blackhole register',
})

-- Yank, delete, change & paste with system clipboard
kmap({ 'n', 'x' }, ' sy', '"+y', { desc = 'yank to system clipboard' })
kmap({ 'n', 'x' }, ' sd', '"+d', { desc = 'delete to system clipboard' })
kmap({ 'n', 'x' }, ' sc', '"+c', { desc = 'change text to system clipboard' })
kmap({ 'n', 'x' }, ' sp', '"+p', { desc = 'paste from system clipboard' })

-- Shift line and reselect
kmap('x', '<', '<gv', { desc = 'shift left & reselect' })
kmap('x', '>', '<gv', { desc = 'shift right & reselect' })

-- Move visual selection up or down a line
kmap('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'move selection down a line' })
kmap('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'move selection up a line' })

-- Misc keybindings
kmap('n', 'z ', '<Cmd>set invspell<CR>', { desc = 'toggle spelling' })
kmap('n', ' b', '<Cmd>enew<CR>', { desc = 'new unnamed buffer' })
kmap('n', ' k', '<Cmd>dig<CR>a<C-k>', { desc = 'pick & enter diagraph' })
kmap('n', ' h', '<Cmd>TSBufToggle highlight<CR>', {
   desc = 'toggle treesitter',
})
kmap('n', ' l', '<Cmd>nohlsearch<Bar>diffupdate<bar>mode<CR>', {
   desc = 'clear & redraw window',
})
kmap('n', ' w', '<Cmd>%s/\\s\\+$//<CR><C-o>', {
   desc = 'trim trailing whitespace',
})

return {}

--[[
--LSP related keybindings
function M.lsp_kb(_, bufnr)
   kmap('n', 'H', vim.lsp.buf.hover, {
      buffer = bufnr,
      desc = 'hover',
   })
   kmap('n', 'K', vim.lsp.buf.signature_help, {
      buffer = bufnr,
      desc = 'signature help',
   })
   kmap('n', 'zd', vim.diagnostic.setloclist, {
      buffer = bufnr,
      desc = 'buffer diagnostics',
   })
   kmap('n', 'g[', vim.diagnostic.goto_prev, {
      buffer = bufnr,
      desc = 'goto prev diagostic',
   })
   kmap('n', 'g]', vim.diagnostic.goto_next, {
      buffer = bufnr,
      desc = 'goto next diagostic',
   })
   kmap('n', 'gd', vim.lsp.buf.definition, {
      buffer = bufnr,
      desc = 'goto definition',
   })
   kmap('n', 'gD', vim.lsp.buf.declaration, {
      buffer = bufnr,
      desc = 'goto declaration',
   })
   kmap('n', 'gI', vim.lsp.buf.implementation, {
      buffer = bufnr,
      desc = 'goto implementation',
   })
   kmap('n', 'gr', vim.lsp.buf.references, {
      buffer = bufnr,
      desc = 'goto references',
   })
   kmap('n', 'gt', vim.lsp.buf.type_definition, {
      buffer = bufnr,
      desc = 'goto type definition',
   })
   kmap('n', 'gW', vim.lsp.buf.workspace_symbol, {
      buffer = bufnr,
      desc = 'workspace symbol',
   })
   kmap('n', 'g0', vim.lsp.buf.document_symbol, {
      buffer = bufnr,
      desc = 'document symbol',
   })
   kmap('n', 'za', vim.lsp.buf.code_action, {
      buffer = bufnr,
      desc = 'code action',
   })
   kmap('n', 'zh', vim.lsp.codelens.refresh, {
      buffer = bufnr,
      desc = 'code lens refresh',
   })
   kmap('n', 'zl', vim.lsp.codelens.run, {
      buffer = bufnr,
      desc = 'code lens run',
   })
   kmap('n', 'zr', vim.lsp.buf.rename, {
      buffer = bufnr,
      desc = 'rename',
   })
   kmap('n', 'zA', vim.lsp.buf.add_workspace_folder, {
      buffer = bufnr,
      desc = 'add workspace folder',
   })
   kmap('n', 'zR', vim.lsp.buf.remove_workspace_folder, {
      buffer = bufnr,
      desc = 'remove workspace folder',
   })
   kmap({ 'n', 'x' }, 'zF', vim.lsp.buf.format, {
      buffer = bufnr,
      desc = 'lsp format',
   })
end

-- Haskell related keybindings
function M.haskell_kb(bufnr)
   kmap({ 'n', 'x' }, 'zH', '<Cmd>%!stylish-haskell<CR>', {
      desc = 'stylish haskell format',
      buffer = bufnr,
   })
end

-- Scala Metals related keybindings
function M.metals_kb(bufnr, metals)
   kmap('n', 'M', metals.hover_worksheet, {
      desc = 'metals hover worksheet',
      buffer = bufnr,
   })
end

-- DAP (Debug Adapter Protocol) related keybindings
function M.dap_kb(bufnr, dap, dap_ui_widgets)
   if M.wk then
      wk.register({ name = 'dap' }, { buffer = bufnr, prefix = '\\' })
   end

   kmap('n', '\\c', dap.continue, {
      buffer = bufnr,
      desc = 'dap continue',
   })
   kmap('n', '\\h', dap_ui_widgets.hover, {
      buffer = bufnr,
      desc = 'dap hover',
   })
   kmap('n', '\\l', dap.run_last, {
      buffer = bufnr,
      desc = 'dap run last',
   })
   kmap('n', '\\o', dap.step_over, {
      buffer = bufnr,
      desc = 'dap step over',
   })
   kmap('n', '\\i', dap.step_into, {
      buffer = bufnr,
      desc = 'dap step into',
   })
   kmap('n', '\\b', dap.toggle_breakpoint, {
      buffer = bufnr,
      desc = 'dap toggle breakpoint',
   })
   kmap('n', '\\r', dap.repl.toggle, {
      buffer = bufnr,
      desc = 'dap repl toggle',
   })
end
--]]
