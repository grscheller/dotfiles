--[[ Define keymappings/keybindings - loaded on VeryLazy event ]]

-- loaded on "VeryLazy" event

local M = {}

local km = vim.keymap.set
local scroll = require 'grs.lib.scroll'

--[[ Window/Tabpage related mappings/bindings ]]

-- Creating new windows
km('n', '<m-->', '<c-w>s', { desc = 'split current window' })
km('n', '<m-=>', '<c-w>v', { desc = 'vsplit current window' })
km('n', '<m-f>', '<cmd>split<bar>term fish<cr>i', { desc = 'split fish term' })
km('n', '<m-g>', '<cmd>vsplit<bar>term fish<cr>i', { desc = 'vsplit fish term' })

-- Navigating windows
km('n', '<c-h>', '<c-w>h', { desc = 'goto window left' })
km('n', '<c-j>', '<c-w>j', { desc = 'goto window below' })
km('n', '<c-k>', '<c-w>k', { desc = 'goto window above' })
km('n', '<c-l>', '<c-w>l', { desc = 'goto window right' })

-- closing windows
km('n', '<m-c>', '<c-w>c', { desc = 'close current window' })
km('n', '<m-o>', '<c-w>o', { desc = 'close all other windows' })

-- Changing window layout
km('n', '<m-h>', '<c-w>H', { desc = 'move window lhs' })
km('n', '<m-j>', '<c-w>J', { desc = 'move window bottom' })
km('n', '<m-k>', '<c-w>K', { desc = 'move window top' })
km('n', '<m-l>', '<c-w>L', { desc = 'move window rhs' })
km('n', '<m-e>', '<c-w>=', { desc = 'equalize windows' })

-- Resizing windows
km('n', '<m-left>', '2<c-w><', { desc = 'make window narrower' })
km('n', '<m-right>', '2<c-w>>', { desc = 'make window wider' })
km('n', '<m-up>', '2<c-w>+', { desc = 'make window taller' })
km('n', '<m-down>', '2<c-w>-', { desc = 'make window shorter' })

-- Move view in window, only move cursor to keep on screen
km('n', '<c-left>', 'z4h', { desc = 'move view left 4 columns' })
km('n', '<c-right>', 'z4l', { desc = 'move view right 4 columns' })
km('n', '<c-up>', '3<c-y>', { desc = 'move up 3 lines' })
km('n', '<c-down>', '3<c-e>', { desc = 'move view down 3 lines' })

-- Managing tabpages - use gt & gT to move between tabpages
km('n', '<m-t>', '<c-w>T', { desc = 'breakout window to new tab' })
km('n', '<m-y>', '<cmd>tabnew<cr>', { desc = 'create new tab' })
km('n', '<m-u>', '<cmd>tabclose<cr>', { desc = 'close current tab' })

-- Autoscroll window with focus
km('n', '<pageup>', scroll.up, { desc = 'autoscroll up' })
km('n', '<pagedown>', scroll.down, { desc = 'autoscroll down' })
km('n', '<home>', scroll.faster, { desc = 'autoscroll faster' })
km('n', '<end>', scroll.slower, { desc = 'autoscroll slower' })
km('n', '<ins>', scroll.reset, { desc = 'autoscroll reset' })
km('n', '<del>', scroll.pause, { desc = 'autoscroll pause' })

--[[ Text editing keymaps not related to any specific plugins ]]

-- Toggle line numbering schemes
local function toggle_line_numbering()
   if not vim.wo.number and not vim.wo.relativenumber then
      vim.wo.number = true
      vim.wo.relativenumber = false
   elseif vim.wo.number and not vim.wo.relativenumber then
      vim.wo.relativenumber = true
   else
      vim.wo.number = false
      vim.wo.relativenumber = false
   end
end

km('n', '<leader>n', toggle_line_numbering, { desc = 'toggle line numbering' })

-- Delete & change text without affecting default register
km({ 'n', 'x' }, '<leader><leader>d', '"_d', { desc = 'delete text to blackhole register' })
km({ 'n', 'x' }, '<leader><leader>c', '"_c', { desc = 'change text to blackhole register' })

-- Yank, delete, & paste with system clipboard
km({ 'n', 'x' }, '<leader><leader>sy', '"+y', { desc = 'yank to system clipboard' })
km({ 'n', 'x' }, '<leader><leader>sd', '"+d', { desc = 'delete to system clipboard' })
km({ 'n', 'x' }, '<leader><leader>sp', '"+p', { desc = 'paste after cursor from system clipboard' })
km({ 'n', 'x' }, '<leader><leader>sP', '"+P', { desc = 'paste before cursor from system clipboard' })

-- Keep next pattern match center of screen (normal mode only)
km('n', 'n', 'nzz', { desc = 'find next and center' })

-- Shift line and re-select
km('x', '<', '<gv', { desc = 'shift left & reselect' })
km('x', '>', '>gv', { desc = 'shift right & reselect' })

-- Move visual selection up or down a line
km('x', 'J', ":m '>+1<cr>gv=gv", { desc = 'move selection down a line' })
km('x', 'K', ":m '<-2<cr>gv=gv", { desc = 'move selection up a line' })

-- Visually select what was just pasted
km('n', 'gV', '`[v`]', { desc = 'select what was just pasted' })

-- Cleanup related keymaps
km('n', '<leader>W', '<cmd>%s/<bslash>s<bslash>+$//<cr><c-o>', { desc = 'trim trailing whitespace' })
km('n', '<esc>', '<cmd>noh<bar>mode<cr><esc>', { desc = 'rm hlsearch & redraw on ESC' })

-- Spelling related keymaps
km('n', 'z ', '<cmd>set invspell<cr>', { desc = 'toggle spelling' })

-- --[[ Diagnostic keymaps ]]
km('n', '<bslash>[', vim.diagnostic.goto_prev, { desc = 'goto prev diagostic' })
km('n', '<bslash>]', vim.diagnostic.goto_next, { desc = 'goto next diagostic' })
km('n', '<bslash>e', vim.diagnostic.open_float, { desc = 'show diagnostic error messages' })
km('n', '<bslash>q', vim.diagnostic.setloclist, { desc = 'show diagnostic quickfix list' })

-- Which-key prefix-keys - defer until Which-Key is available
function M.wk_prefixes(wk)
   -- Leader & leader-like prefix-keys
   wk.register({
      name = 'space key',
   }, {
      prefix = '<space>',
      mode = { 'n', 'v' },
   })

   wk.register({
      name = 'LSP, DAP',
   }, {
      prefix = '<bslash>',
      mode = 'n',
   })

   wk.register({
      name = 'LSP',
   }, {
      prefix = '<bslash>',
      mode = 'v',
   })

   -- Lazy GUI prefix-key & keymap
   wk.register({
      name = 'lazy',
   }, {
      prefix = '<leader>l',
      mode = 'n',
   })

   km('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'lazy gui' })

   -- Telescope prefix-key & additional keymap
   wk.register({
      name = 'telescope',
   }, {
      prefix = '<leader>t',
      mode = 'n',
   })

   km('n', '<leader>tt', '<cmd>Telescope<cr>', {
      desc = 'telescope',
   })

   -- Treesitter related keymap
   km('n', '<leader>H', '<cmd>TSBufToggle highlight<cr>', {
      desc = 'toggle treesitter highlighting',
   })

   -- Harpoon prefix-key
   wk.register({
      name = 'harpoon',
   }, {
      prefix = '<leader>h',
      mode = 'n',
   })

   -- Refactoring prefix-key
   wk.register({
      name = 'refactoring',
   }, {
      prefix = '<leader>r',
      mode = { 'n', 'v' },
   })
end

--[[ LSP related keymaps ]]
function M.lsp(bufnr, wk)
   km('n', '<bslash>H', vim.lsp.buf.hover, {
      buffer = bufnr,
      desc = 'hover',
   })
   km('n', '<bslash>K', vim.lsp.buf.signature_help, {
      buffer = bufnr,
      desc = 'signature help',
   })
   km('n', '<bslash>gd', vim.lsp.buf.definition, {
      buffer = bufnr,
      desc = 'goto definition',
   })
   km('n', '<bslash>gD', vim.lsp.buf.declaration, {
      buffer = bufnr,
      desc = 'goto declaration',
   })
   km('n', '<bslash>gI', vim.lsp.buf.implementation, {
      buffer = bufnr,
      desc = 'goto implementation',
   })
   km('n', '<bslash>gr', vim.lsp.buf.references, {
      buffer = bufnr,
      desc = 'goto references',
   })
   km('n', '<bslash>gt', vim.lsp.buf.type_definition, {
      buffer = bufnr,
      desc = 'goto type definition',
   })
   km('n', '<bslash>gW', vim.lsp.buf.workspace_symbol, {
      buffer = bufnr,
      desc = 'workspace symbol',
   })
   km('n', '<bslash>gS', vim.lsp.buf.document_symbol, {
      buffer = bufnr,
      desc = 'document symbol',
   })
   km('n', '<bslash>a', vim.lsp.buf.code_action, {
      buffer = bufnr,
      desc = 'code action',
   })
   km('n', '<bslash>h', vim.lsp.codelens.refresh, {
      buffer = bufnr,
      desc = 'code lens refresh',
   })
   km('n', '<bslash>l', vim.lsp.codelens.run, {
      buffer = bufnr,
      desc = 'code lens run',
   })
   km('n', '<bslash>r', vim.lsp.buf.rename, {
      buffer = bufnr,
      desc = 'rename',
   })
   km('n', '<bslash>wa', vim.lsp.buf.add_workspace_folder, {
      buffer = bufnr,
      desc = 'add workspace folder',
   })
   km('n', '<bslash>wr', vim.lsp.buf.remove_workspace_folder, {
      buffer = bufnr,
      desc = 'remove workspace folder',
   })
   km({ 'n', 'v' }, '<bslash>F', vim.lsp.buf.format, {
      buffer = bufnr,
      desc = 'lsp format',
   })

   wk.register({
      name = 'goto',
   }, {
      prefix = '<bslash>g',
      mode = 'n',
      buffer = bufnr,
   })

   wk.register({
      name = 'workspace',
   }, {
      prefix = '<bslash>w',
      mode = 'n',
      buffer = bufnr,
   })
end

-- Haskell related keymaps
function M.haskell(bufnr, wk)
   km({ 'n', 'v' }, '<bslash>LF', '<cmd>%!stylish-haskell<cr>', {
      buffer = bufnr,
      desc = 'stylish haskell format',
   })

   wk.register({
      name = 'haskell specific',
   }, {
      prefix = '<bslash>L',
      mode = { 'n', 'v' },
      buffer = bufnr,
   })
end

-- Rust-Tools related keymaps
function M.rust(bufnr, rt, wk)
   km('n', '<bslash>LH', rt.hover_actions.hover_actions, {
      buffer = bufnr,
      desc = 'rust hover actions',
   })
   km('n', '<bslash>LA', rt.code_action_group.code_action_group, {
      buffer = bufnr,
      desc = 'rust code action group',
   })

   wk.register({
      name = 'rust specific',
   }, {
      prefix = '<bslash>L',
      mode = 'n',
      buffer = bufnr,
   })
end

-- Scala Metals related keymaps
function M.metals(bufnr, metals, wk)
   km('n', '<bslash>LH', metals.hover_worksheet, {
      buffer = bufnr,
      desc = 'metals hover worksheet',
   })

   wk.register({
      name = 'scala specific',
   }, {
      prefix = '<bslash>L',
      mode = 'n',
      buffer = bufnr,
   })
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.dap(bufnr, dap, dap_ui_widgets, wk)
   km('n', '<bslash>c', dap.continue, {
      buffer = bufnr,
      desc = 'dap continue',
   })
   km('n', '<bslash>h', dap_ui_widgets.hover, {
      buffer = bufnr,
      desc = 'dap hover',
   })
   km('n', '<bslash>l', dap.run_last, {
      buffer = bufnr,
      desc = 'dap run last',
   })
   km('n', '<bslash>o', dap.step_over, {
      buffer = bufnr,
      desc = 'dap step over',
   })
   km('n', '<bslash>i', dap.step_into, {
      buffer = bufnr,
      desc = 'dap step into',
   })
   km('n', '<bslash>b', dap.toggle_breakpoint, {
      buffer = bufnr,
      desc = 'dap toggle breakpoint',
   })
   km('n', '<bslash>r', dap.repl.toggle, {
      buffer = bufnr,
      desc = 'dap repl toggle',
   })

   wk.register({
      name = 'dap',
   }, {
      prefix = '<bslash>',
      mode = 'n',
      buffer = bufnr,
   })
end

return M
