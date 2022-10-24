--[[ Define keybindings/keymappings

     The only things this config file should do
     is setup WhichKey and define keybindings.

     Not all keybindings need be defined here, just
     those that help declutter other config files. ]]

local kb = vim.keymap.set

local M = {}

--[[ Which-Key setup - helps make keybindings user discoverable ]]

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
end

--[[ General key mappings/bindings ]]

-- Window & tab layout and navigation related keybindings
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
   kb('n', '<M-f>', '<Cmd>split<Bar>term fish<CR>i',
                              { desc = 'fish term in split' })
   kb('n', '<M-g>', '<Cmd>vsplit<Bar>term fish<CR>i',
                              { desc = 'fish term in vsplit' })

   -- Changing window layout
   kb('n', '<M-S-h>', '<C-w>H', { desc = 'move window lhs' })
   kb('n', '<M-S-j>', '<C-w>J', { desc = 'move window bottom' })
   kb('n', '<M-S-k>', '<C-w>K', { desc = 'move window top' })
   kb('n', '<M-S-l>', '<C-w>L', { desc = 'move window rhs' })
   kb('n', '<M-x>',   '<C-w>x', { desc = 'exchange window next' })
   kb('n', '<M-r>',   '<C-w>r', { desc = 'rotate inner split' })
   kb('n', '<M-e>',   '<C-w>=', { desc = 'equalize windows' })

   -- Resizing windows
   -- Think: Alt+Minus Alt+Plus Alt+Shift+Minus Alt+Shift+Plus
   kb('n', '<M-->', '2<C-w><', { desc = 'make window narrower' })
   kb('n', '<M-=>', '2<C-w>>', { desc = 'make window wider' })
   kb('n', '<M-_>', '2<C-w>-', { desc = 'make window shorter' })
   kb('n', '<M-+>', '2<C-w>+', { desc = 'make window taller' })

   -- Move view in window, only move cursor to keep on screen
   kb('n', '<C-h>', 'z4h',    { desc = 'move view left 4 columns' })
   kb('n', '<C-j>', '3<C-e>', { desc = 'move view down 3 lines' })
   kb('n', '<C-k>', '3<C-y>', { desc = 'move view up 3 lines' })
   kb('n', '<C-l>', 'z4l',    { desc = 'move view right 4 columns' })

   -- Managing tabpages
   kb('n', '<M-Left>',  '<Cmd>tabprev<CR>', { desc = 'goto tab left' })
   kb('n', '<M-Right>', '<Cmd>tabnext<CR>', { desc = 'goto tab right' })
   kb('n', '<M-n>',     '<Cmd>tabnew<CR>',  { desc = 'create new tab' })
   kb('n', '<M-t>',     '<C-w>T',  { desc = 'breakout window new tab' })
   kb('n', '<M-c>',     '<C-w>c',  { desc = 'close current window' })
   kb('n', '<M-o>',     '<C-w>o',  { desc = 'close other tab windows' })

   -- Shift text and reselect
   kb('x', '<', '<gv', { desc = 'shift left & reselect' })
   kb('x', '>', '>gv', { desc = 'shift right & reselect' })

   -- Yank, delete, change & paste with system clipboard
   kb({ 'n', 'v' }, ' sy', '"+y', { desc = 'yank to system clipboard' })
   kb({ 'n', 'v' }, ' sd', '"+d', { desc = 'delete to system clipboard' })
   kb({ 'n', 'v' }, ' sc', '"+c', { desc = 'change text to system clipboard' })
   kb({ 'n', 'v' }, ' sp', '"+p', { desc = 'paste from system clipboard' })

   -- Delete & change text without affecting default register
   kb({ 'n', 'v' }, ' d', '"_d', { desc = 'delete text to blackhole register' })
   kb({ 'n', 'v' }, ' c', '"_c', { desc = 'change text to blackhole register' })

   -- Misc keybindings
   kb('n', ' b', '<Cmd>enew<CR>', {
      desc = 'new unnamed buffer'
   })
   kb('n', ' h', '<Cmd>TSBufToggle highlight<CR>', {
      desc = 'toggle treesitter'
   })
   kb('n', ' k', '<Cmd>dig<CR>a<C-k>', {
      desc = 'pick & enter diagraph'
   })
   kb('n', ' l', '<Cmd>nohlsearch<Bar>diffupdate<bar>mode<CR>', {
      desc = 'clear & redraw window'
   })
   kb('n', ' w', '<Cmd>%s/\\s\\+$//<CR><C-o>', {
      desc = 'trim trailing whitespace'
   })
   kb('n', 'z ', '<Cmd>set invspell<CR>', {
      desc = 'toggle spelling'
   })

   -- toggle line numberings schemes
   kb('n', ' n', function()
         if not vim.wo.number and not vim.wo.relativenumber then
            vim.wo.number = true
            vim.wo.relativenumber = false
         elseif vim.wo.number and not vim.wo.relativenumber then
            vim.wo.relativenumber = true
         elseif vim.wo.number and vim.wo.relativenumber then
            vim.wo.number = false
         else
            vim.wo.number = false
            vim.wo.relativenumber = false
         end
      end, {
      desc = 'line number toggle'
   })

   -- Used with LSP
   --[[ kb('n', '[', function()
         vim.diagnostic.goto_prev { wrap = false }
      end, {
      desc = 'diagnostic goto previous'
   })
   kb('n', ']', function()
         vim.diagnostic.goto_next { wrap = false }
      end, {
      desc = 'diagnostic goto next'
   }) ]]

   -- WhichKey labels
   if M.wk then
      local label = { name = 'system clipboard' }
      local opts_n = {
         mode = 'n',
         prefix = ' s'
      }
      local opts_x = {
         mode = 'x',
         prefix = ' s'
      }
      wk.register(label, opts_n)
      wk.register(label, opts_x)
   end

end

--[[ Telescope related keybindings ]]
function M.telescope_kb()
   local ts = require('telescope')
   local tb = require('telescope.builtin')
   local tfb = ts.extensions.file_browser
   local tfq = ts.extensions.frecency

   -- Telescope
   kb('n', ' tt', '<Cmd>Telescope<CR>', { desc = 'telescope command' })
   kb('n', ' tl', tb.buffers,           { desc = 'list buffers' })
   kb('n', ' tz',
      tb.current_buffer_fuzzy_find,
      { desc = 'fuzzy find current buffer' })
   kb('n', ' tb', tfb.file_browser, { desc = 'telescope file browser' })
   kb('n', ' tf', tb.find_files,    { desc = 'find files' })
   kb('n', ' tq', tfq.frecency,     { desc = 'telescope frecency' })
   kb('n', ' tr', tb.oldfiles,      { desc = 'find recent files' })
   kb('n', ' tg', tb.live_grep,     { desc = 'grep file contents' })
   kb('n', ' tn', tb.grep_string,   { desc = 'fzy find file names' })
   kb('n', ' th', tb.help_tags,     { desc = 'help tags' })

   -- WhichKey labels
   if M.wk then
      local label = { name = 'telescope' }
      local opts = { prefix = ' t' }
      wk.register(label, opts)
   end

end

-- LSP related keybindings
--
--   Using g and z as "leader keys" for LSP,
--   stepping on folding keybindings which I never use.
--
function M.lsp_kb(client, bufnr)
   kb('n', 'za',  vim.lsp.buf.code_action, {
      desc = 'code action', buffer = bufnr
   })
   kb('n', 'zlh', vim.lsp.codelens.refresh, {
      desc = 'code lens refresh', buffer = bufnr
   })
   kb('n', 'zlr', vim.lsp.codelens.run, {
      desc = 'code lens run', buffer = bufnr
   })
   kb('n', 'zd',  vim.diagnostic.setloclist, {
      desc = 'buffer diagnostics', buffer = bufnr
   })
   kb('n', 'zFf', vim.lsp.buf.format, {
      desc = 'lsp format', buffer = bufnr
   })
   kb('n', 'gd',  vim.lsp.buf.definition, {
      desc = 'goto definition', buffer = bufnr
   })
   kb('n', 'gD',  vim.lsp.buf.declaration, {
      desc = 'goto declaration', buffer = bufnr
   })
   kb('n', 'gI',  vim.lsp.buf.implementation, {
      desc = 'goto implementation', buffer = bufnr
   })
   kb('n', 'gr',  vim.lsp.buf.references, {
      desc = 'goto references', buffer = bufnr
   })
   kb('n', 'gsd', vim.lsp.buf.document_symbol, {
      desc = 'document symbol', buffer = bufnr
   })
   kb('n', 'gsw', vim.lsp.buf.workspace_symbol, {
      desc = 'workspace symbol', buffer = bufnr
   })
   kb('n', 'gt',  vim.lsp.buf.type_definition, {
      desc = 'goto type definition', buffer = bufnr
   })
   kb('n', 'zS',  vim.lsp.buf.signature_help, {
      desc = 'signature help', buffer = bufnr
   })
   kb('n', 'zh',   vim.lsp.buf.hover, {
      desc = 'hover', buffer = bufnr
   })
   kb('n', 'zr',  vim.lsp.buf.rename, {
      desc = 'rename', buffer = bufnr
   })
   kb('n', 'zWa', vim.lsp.buf.add_workspace_folder, {
      desc = 'add workspace folder', buffer = bufnr
   })
   kb('n', 'zWr', vim.lsp.buf.remove_workspace_folder, {
      desc = 'remove workspace folder', buffer = bufnr
   })

   -- WhichKey labels
   if M.wk then
      local labels_g = {
         s = { name = 'symbol' }
      }
      local labels_z = {
         F = { name = 'format' },
         l = { name = 'code lens' },
         W = { name = 'workspace folder' }
      }
      local opts_g = { prefix = ' g' }
      local opts_z = { prefix = ' z' }
      wk.register(labels_g, { opts_g, buffer = bufnr })
      wk.register(labels_z, { opts_z, buffer = bufnr })
   end

   return client

end

--[[ Haskell related keybindings ]]
function M.haskell_kb(bufnr)
   kb('n', 'zFh', '<Cmd>%!stylish-haskell<CR>', {
      desc = 'stylish haskell format', buffer = bufnr
   })
end

--[[ Scala Metals related keybindings ]]
function M.metals_kb(bufnr)
   local metals = require('metals')
   kb('n', 'mh', metals.hover_worksheet, {
      desc = 'metals hover worksheet', buffer = bufnr
   })

   -- WhichKey labels
   if M.wk then
      local label = { name = 'metals' }
      local opts = {
         prefix = 'm',
         buffer = bufnr
      }
      wk.register(label, opts)
   end

end

--[[ DAP (Debug Adapter Protocol) related keybindings ]]
function M.dap_kb(bufnr)
   local dap = require('dap')
   local dapUiWidgets = require('dap.ui.widgets')
   kb('n', '\\c', dap.continue, {
      desc = 'dap continue',
      buffer = bufnr
   })
   kb('n', '\\h', dapUiWidgets.hover, {
      desc = 'dap hover',
      buffer = bufnr
   })
   kb('n', '\\l', dap.run_last, {
      desc = 'dap run last',
      buffer = bufnr
   })
   kb('n', '\\o', dap.step_over, {
      desc = 'dap step over',
      buffer = bufnr
   })
   kb('n', '\\i', dap.step_into, {
      desc = 'dap step into',
      buffer = bufnr
   })
   kb('n', '\\b', dap.toggle_breakpoint, {
      desc = 'dap toggle breakpoint',
      buffer = bufnr
   })
   kb('n', '\\r', dap.repl.toggle, {
      desc = 'dap repl toggle',
      buffer = bufnr
   })

   -- WhichKey labels
   if M.wk then
      local label = { name = 'dap' }
      local opts = {
         prefix = '\\',
         buffer = bufnr
      }
      wk.register(label, opts)
   end

end

return M
