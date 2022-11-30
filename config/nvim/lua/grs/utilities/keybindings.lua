--[[ Define keybindings/keymappings ]]

--[[
     The only things this config file should do
     is setup WhichKey and define keybindings.

     Not all keybindings need be defined here, just
     those that help declutter other config files.
--]]

local M = {}

local utils = require 'grs.utilities.grsUtils'
local msg = utils.msg_hit_return_to_continue
local kb = vim.keymap.set

M.kb = kb

--[[ Which-Key setup - helps make keybindings user discoverable ]]
local ok, wk = pcall(require, 'which-key')
if ok then
   wk.setup {
      plugins = {
         spelling = {
            enabled = true,
            suggestions = 36,
         },
      },
   }
   M.wk = wk
else
   msg 'Problem in keybindings.lua: which-key failed to load'
end

--[[ General key mappings/bindings ]]
function M.general_kb()
   -- Navigating windows
   kb('n', '<M-h>', '<C-w>h', { desc = 'goto window left' })
   kb('n', '<M-j>', '<C-w>j', { desc = 'goto window below' })
   kb('n', '<M-k>', '<C-w>k', { desc = 'goto window above' })
   kb('n', '<M-l>', '<C-w>l', { desc = 'goto window right' })
   kb('n', '<M-p>', '<C-w>p', { desc = 'goto previous window' })

   -- Creating new windows
   kb('n', '<M-s>', '<C-w>s', { desc = 'split current window' })
   kb('n', '<M-d>', '<C-w>v', { desc = 'vsplit current window' })
   kb('n', '<M-f>', '<Cmd>split<Bar>term fish<CR>i', {
      desc = 'fish term in split',
   })
   kb('n', '<M-g>', '<Cmd>vsplit<Bar>term fish<CR>i', {
      desc = 'fish term in vsplit',
   })

   -- Changing window layout
   kb('n', '<M-S-h>', '<C-w>H', { desc = 'move window lhs' })
   kb('n', '<M-S-j>', '<C-w>J', { desc = 'move window bottom' })
   kb('n', '<M-S-k>', '<C-w>K', { desc = 'move window top' })
   kb('n', '<M-S-l>', '<C-w>L', { desc = 'move window rhs' })
   kb('n', '<M-x>', '<C-w>x', { desc = 'exchange window next' })
   kb('n', '<M-r>', '<C-w>r', { desc = 'rotate inner split' })
   kb('n', '<M-e>', '<C-w>=', { desc = 'equalize windows' })

   -- Resizing windows
   -- Think: Alt+Minus Alt+Plus Alt+Shift+Minus Alt+Shift+Plus
   kb('n', '<M-->', '2<C-w><', { desc = 'make window narrower' })
   kb('n', '<M-=>', '2<C-w>>', { desc = 'make window wider' })
   kb('n', '<M-_>', '2<C-w>-', { desc = 'make window shorter' })
   kb('n', '<M-+>', '2<C-w>+', { desc = 'make window taller' })

   -- Move view in window, only move cursor to keep on screen
   kb('n', '<C-h>', 'z4h', { desc = 'move view left 4 columns' })
   kb('n', '<C-j>', '3<C-e>', { desc = 'move view down 3 lines' })
   kb('n', '<C-k>', '3<C-y>', { desc = 'move view up 3 lines' })
   kb('n', '<C-l>', 'z4l', { desc = 'move view right 4 columns' })

   -- Managing tabpages
   kb('n', '<M-Left>', '<Cmd>tabprev<CR>', { desc = 'goto tab left' })

   kb('n', '<M-Right>', '<Cmd>tabnext<CR>', { desc = 'goto tab right' })
   kb('n', '<M-n>', '<Cmd>tabnew<CR>', { desc = 'create new tab' })
   kb('n', '<M-t>', '<C-w>T', { desc = 'breakout window new tab' })
   kb('n', '<M-c>', '<C-w>c', { desc = 'close current window' })
   kb('n', '<M-o>', '<C-w>o', { desc = 'close other tab windows' })

   -- Shift text and reselect
   kb('x', '<', '<gv', { desc = 'shift left & reselect' })
   kb('x', '>', '>gv', { desc = 'shift right & reselect' })

   -- For <Space> based keymaps
   if M.wk then
      wk.register(
         { name = 'system clipboard' },
         { mode = { 'n', 'x' }, prefix = ' s' }
      )
   end

   kb('n', '  ', '<Nop>', { desc = 'punt on <Space> Keymap' })

   -- Yank, delete, change & paste with system clipboard
   kb({ 'n', 'x' }, ' sy', '"+y', { desc = 'yank to system clipboard' })
   kb({ 'n', 'x' }, ' sd', '"+d', { desc = 'delete to system clipboard' })
   kb({ 'n', 'x' }, ' sc', '"+c', { desc = 'change text to system clipboard' })
   kb({ 'n', 'x' }, ' sp', '"+p', { desc = 'paste from system clipboard' })

   -- Delete & change text without affecting default register
   kb({ 'n', 'x' }, ' d', '"_d', {
      desc = 'delete text to blackhole register',
   })
   kb({ 'n', 'x' }, ' c', '"_c', {
      desc = 'change text to blackhole register',
   })

   -- toggle line numberings schemes
   kb('n', ' n', utils.toggle_line_numbering, {
      desc = 'toggle line numbering',
   })

   -- Misc keybindings
   kb('n', 'z ', '<Cmd>set invspell<CR>', { desc = 'toggle spelling' })
   kb('n', ' b', '<Cmd>enew<CR>', { desc = 'new unnamed buffer' })
   kb('n', ' k', '<Cmd>dig<CR>a<C-k>', { desc = 'pick & enter diagraph' })
   kb('n', ' h', '<Cmd>TSBufToggle highlight<CR>', {
      desc = 'toggle treesitter',
   })
   kb('n', ' l', '<Cmd>nohlsearch<Bar>diffupdate<bar>mode<CR>', {
      desc = 'clear & redraw window',
   })
   kb('n', ' w', '<Cmd>%s/\\s\\+$//<CR><C-o>', {
      desc = 'trim trailing whitespace',
   })
end

--[[ Telescope related keybindings ]]
function M.telescope_kb(ts, tb)
   if M.wk then wk.register({ name = 'telescope' }, { prefix = ' t' }) end

   -- Telescope built-ins
   local tb_td = tb.grep_string
   local tb_tf = tb.find_files
   local tb_tg = tb.live_grep
   local tb_th = tb.help_tags
   local tb_tl = tb.buffers
   local tb_tr = tb.oldfiles
   local tb_tz = tb.current_buffer_fuzzy_find

   kb('n', ' td', tb_td, { desc = 'grep files curr dir' })
   kb('n', ' tf', tb_tf, { desc = 'find files' })
   kb('n', ' tg', tb_tg, { desc = 'grep content files' })
   kb('n', ' th', tb_th, { desc = 'help tags' })
   kb('n', ' tl', tb_tl, { desc = 'list buffers' })
   kb('n', ' tr', tb_tr, { desc = 'find recent files' })
   kb('n', ' tz', tb_tz, { desc = 'fuzzy find curr buff' })

   -- Telescope extensions
   local filebrowser = ts.extensions.file_browser.file_browser
   local frecency = ts.extensions.frecency.frecency
   kb('n', ' tb', filebrowser, { desc = 'file browser' })
   kb('n', ' tq', frecency, { desc = 'telescope frecency' })

   -- Telescope commands
   kb('n', ' tt', '<Cmd>Telescope<CR>', { desc = 'telescope command' })
end

--[[ LSP related keybindings ]]
function M.lsp_kb(_, bufnr)
   kb('n', 'H', vim.lsp.buf.hover, {
      buffer = bufnr,
      desc = 'hover',
   })
   kb('n', 'K', vim.lsp.buf.signature_help, {
      buffer = bufnr,
      desc = 'signature help',
   })
   kb('n', 'zd', vim.diagnostic.setloclist, {
      buffer = bufnr,
      desc = 'buffer diagnostics',
   })
   kb('n', 'g[', vim.diagnostic.goto_prev, {
      buffer = bufnr,
      desc = 'goto prev diagostic',
   })
   kb('n', 'g]', vim.diagnostic.goto_next, {
      buffer = bufnr,
      desc = 'goto next diagostic',
   })
   kb('n', 'gd', vim.lsp.buf.definition, {
      buffer = bufnr,
      desc = 'goto definition',
   })
   kb('n', 'gD', vim.lsp.buf.declaration, {
      buffer = bufnr,
      desc = 'goto declaration',
   })
   kb('n', 'gI', vim.lsp.buf.implementation, {
      buffer = bufnr,
      desc = 'goto implementation',
   })
   kb('n', 'gr', vim.lsp.buf.references, {
      buffer = bufnr,
      desc = 'goto references',
   })
   kb('n', 'gt', vim.lsp.buf.type_definition, {
      buffer = bufnr,
      desc = 'goto type definition',
   })
   kb('n', 'gW', vim.lsp.buf.workspace_symbol, {
      buffer = bufnr,
      desc = 'workspace symbol',
   })
   kb('n', 'g0', vim.lsp.buf.document_symbol, {
      buffer = bufnr,
      desc = 'document symbol',
   })
   kb('n', 'za', vim.lsp.buf.code_action, {
      buffer = bufnr,
      desc = 'code action',
   })
   kb('n', 'zh', vim.lsp.codelens.refresh, {
      buffer = bufnr,
      desc = 'code lens refresh',
   })
   kb('n', 'zl', vim.lsp.codelens.run, {
      buffer = bufnr,
      desc = 'code lens run',
   })
   kb('n', 'zr', vim.lsp.buf.rename, {
      buffer = bufnr,
      desc = 'rename',
   })
   kb('n', 'zA', vim.lsp.buf.add_workspace_folder, {
      buffer = bufnr,
      desc = 'add workspace folder',
   })
   kb('n', 'zR', vim.lsp.buf.remove_workspace_folder, {
      buffer = bufnr,
      desc = 'remove workspace folder',
   })
   kb({ 'n', 'x' }, 'zF', vim.lsp.buf.format, {
      buffer = bufnr,
      desc = 'lsp format',
   })
end

--[[ Haskell related keybindings ]]
function M.haskell_kb(bufnr)
   kb({ 'n', 'x' }, 'zH', '<Cmd>%!stylish-haskell<CR>', {
      desc = 'stylish haskell format',
      buffer = bufnr,
   })
end

--[[ Scala Metals related keybindings ]]
function M.metals_kb(bufnr, metals)
   kb('n', 'M', metals.hover_worksheet, {
      desc = 'metals hover worksheet',
      buffer = bufnr,
   })
end

--[[ DAP (Debug Adapter Protocol) related keybindings ]]
function M.dap_kb(bufnr, dap, dap_ui_widgets)
   if M.wk then
      wk.register({ name = 'dap' }, { buffer = bufnr, prefix = '\\' })
   end

   kb('n', '\\c', dap.continue, {
      buffer = bufnr,
      desc = 'dap continue',
   })
   kb('n', '\\h', dap_ui_widgets.hover, {
      buffer = bufnr,
      desc = 'dap hover',
   })
   kb('n', '\\l', dap.run_last, {
      buffer = bufnr,
      desc = 'dap run last',
   })
   kb('n', '\\o', dap.step_over, {
      buffer = bufnr,
      desc = 'dap step over',
   })
   kb('n', '\\i', dap.step_into, {
      buffer = bufnr,
      desc = 'dap step into',
   })
   kb('n', '\\b', dap.toggle_breakpoint, {
      buffer = bufnr,
      desc = 'dap toggle breakpoint',
   })
   kb('n', '\\r', dap.repl.toggle, {
      buffer = bufnr,
      desc = 'dap repl toggle',
   })
end

return M
