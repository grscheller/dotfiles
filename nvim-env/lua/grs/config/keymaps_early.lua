--[[ Keymaps & related tweaks defined before invoking lazy.nvim ]]

local km = vim.keymap.set
local scroll = require 'grs.lib.scroll' --[[ keymappings not depending on external plugins ]]

-- Creating new windows
km('n', '<m-->', '<c-w>s', { desc = 'split current window' })
km('n', '<m-=>', '<c-w>v', { desc = 'vsplit current window' })
km('n', '<m-t>', '<cmd>vsplit<bar>term fish<cr>i', { desc = 'fish term' })

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

-- Auto-scroll window with focus
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
km({ 'n', 'v', 'o' }, '<c-b>d', '"_d', { desc = 'delete to blackhole register' })
km({ 'n', 'v', 'o' }, '<c-b>c', '"_c', { desc = 'change to blackhole register' })

-- Yank, delete, & paste with system clipboard
km({ 'n', 'v', 'o' }, '<c-s>y', '"+y', { desc = 'yank to system clipboard' })
km({ 'n', 'v', 'o' }, '<c-s>d', '"+d', { desc = 'delete to system clipboard' })
km({ 'n', 'v', 'o' }, '<c-s>p', '"+p', { desc = 'system clipboard paste after' })
km({ 'n', 'v', 'o' }, '<c-s>P', '"+P', { desc = 'system clipboard paste before' })

-- Keep next pattern match center of screen (normal mode only)
km('n', 'n', 'nzz', { desc = 'find next and center' })

-- Shift line and re-select
km('v', '<', '<gv', { desc = 'shift left & reselect' })
km('v', '>', '>gv', { desc = 'shift right & reselect' })

-- Move visual selection up or down a line
km('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'move selection down a line' })
km('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'move selection up a line' })

-- Visually select what was just pasted
km('n', 'gV', '`[v`]', { desc = 'select what was just pasted' })

-- Cleanup related keymaps
km('n', '<leader>w', '<cmd>%s/<bslash>s<bslash>+$//<cr><c-o>', { desc = 'trim trailing whitespace' })
km('n', '<esc>', '<cmd>noh<bar>mode<cr><esc>', { desc = 'rm hlsearch & redraw on ESC' })

-- Spelling related keymaps
km('n', 'z ', '<cmd>set invspell<cr>', { desc = 'toggle spelling' })

-- Editing tweaks
km('n', 'cL', 'cl <c-o>h', { desc = 'cl with SPACE' })
km('i', '<c-l>', '<c-o>l', { desc = 'move cursor one space right' })
km('i', '<c-h>', '<c-o>h', { desc = 'move cursor one space left' })

--[[ Diagnostic keymaps & a vim.diagnostic tweak ]]

km('n', '<bslash>[', function()
   vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'prev_diagostic' })

km('n', '<bslash>]', function()
   vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'prev_diagostic' })

km('n', '<bslash>e', vim.diagnostic.open_float, { desc = 'diag_err_messages' })
km('n', '<bslash>q', vim.diagnostic.setloclist, { desc = 'diag_qfix_list' })

vim.diagnostic.config {
   virtual_text = false, -- virtual text gets in the way
   signs = true,
   underline = true,
   severity_sort = true,
}
