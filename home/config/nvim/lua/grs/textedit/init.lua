--[[ Plugins & General Text Editing Related Autocmds & Keybindings ]]

local keymaps = require 'grs.conf.keybindings'
local Vim = require 'grs.lib.Vim'

local kb = keymaps.kb
local msg = Vim.msg_hit_return_to_continue

--[[ Keybindings not related to any specific plugins ]]
keymaps.textedit_kb()

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
   msg 'Problem in textedit.lua: Comment failed to load'
end

-- Configure justtinmk/vim-sneak plugin
Vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion

kb({ 'n', 'x' }, 'f', '<Plug>Sneak_f')
kb({ 'n', 'x' }, 'F', '<Plug>Sneak_F')
kb({ 'n', 'x' }, 't', '<Plug>Sneak_t')
kb({ 'n', 'x' }, 'T', '<Plug>Sneak_T')

--[[ Text editing commands/autocmds not related to specific plugins ]]
local augroup = Vim.api.nvim_create_augroup
local autocmd = Vim.api.nvim_create_autocmd
local usercmd = Vim.api.nvim_create_user_command

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
      Vim.highlight.on_yank {
         timeout = 500,
         higroup = 'Visual',
      }
   end,
   group = grs_text_group,
   desc = 'Give visual feedback when yanking text',
})
