--[[ Plugins & General Text Editing Related Autocmds & Keybindings ]]

local keymaps = require 'grs.conf.keybindings'
local kb = keymaps.kb
local wk = keymaps.wk

local Vim = require 'grs.lib.Vim'

--[[ Configure specific text editing relaed plugins ]]

-- Configure numToStr/Comment.nvim
local ok, comment = pcall(require, 'Comment')
if ok then
   comment.setup {
      ignore = '^$',
      mappings = {
         basic = true,
         extra = true,
      },
   }
else
   Vim.msg_return_to_continue 'Problem in textedit.lua, Comment failed to load'
end

-- Configure justtinmk/vim-sneak plugin
vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion

kb({ 'n', 'x' }, 'f', '<Plug>Sneak_f')
kb({ 'n', 'x' }, 'F', '<Plug>Sneak_F')
kb({ 'n', 'x' }, 't', '<Plug>Sneak_t')
kb({ 'n', 'x' }, 'T', '<Plug>Sneak_T')

--[[ Text editing commands/autocmds not related to specific plugins ]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

local grs_text_group = augroup('grs_text', {})

-- Write file as root - works when sudo doesn't require a password
usercmd('WRF', 'w !sudo tee <f-args> > /dev/null', { nargs = 1 })
usercmd('WR', 'WRF %', {})

-- Case sensitive search while in command mode
autocmd('CmdLineEnter', {
   pattern = '*',
   command = 'set nosmartcase noignorecase',
   group = grs_text_group,
   desc = 'Don\'t ignore case when in Command Mode',
})

autocmd('CmdLineLeave', {
   pattern = '*',
   command = 'set ignorecase smartcase',
   group = grs_text_group,
   desc = 'Use smartcase when not in Command Mode',
})

-- Give visual feedback when yanking text
autocmd('TextYankPost', {
   pattern = '*',
   callback = function()
      vim.highlight.on_yank {
         timeout = 500,
         higroup = 'Visual',
      }
   end,
   group = grs_text_group,
   desc = 'Give visual feedback when yanking text',
})

--[[ Text editting keymaps not related to any specific plugins ]]

-- Delete & change text without affecting default register
kb({ 'n', 'x' }, ' d', '"_d', {
   desc = 'delete text to blackhole register',
})
kb({ 'n', 'x' }, ' c', '"_c', {
   desc = 'change text to blackhole register',
})

-- Yank, delete, change & paste with system clipboard
kb({ 'n', 'x' }, ' sy', '"+y', { desc = 'yank to system clipboard' })
kb({ 'n', 'x' }, ' sd', '"+d', { desc = 'delete to system clipboard' })
kb({ 'n', 'x' }, ' sc', '"+c', { desc = 'change text to system clipboard' })
kb({ 'n', 'x' }, ' sp', '"+p', { desc = 'paste from system clipboard' })

-- Shift line and reselect
kb('x', '<', '<gv', { desc = 'shift left & reselect' })
kb('x', '>', '<gv', { desc = 'shift right & reselect' })

-- Move visual selection up or down a line
kb('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'move selection down a line' })
kb('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'move selection up a line' })

-- toggle line numberings schemes
kb('n', ' n', Vim.toggle_line_numbering, {
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

-- For <Space> based keymaps
if wk then
   wk.register(
      { name = 'system clipboard' },
      { mode = { 'n', 'x' }, prefix = ' s' }
   )
end
