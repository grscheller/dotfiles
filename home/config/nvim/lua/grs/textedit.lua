--[[ Plugins & General Text Editing Related Autocmds & Keybindings ]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

local kb = vim.keymap.set

-- Configure numToStr/Comment.nvim
local ok, comment = pcall(require, 'Comment')
if ok then
   comment.setup {
      ignore = '^$',
      mappings = {
         basic = true,
         extra = true
      }
   }
end

-- Configure justtinmk/vim-sneak plugin
vim.g['sneak#label'] = 1 -- minimalist alternative to EasyMotion

kb({'n', 'x'}, 'f', '<Plug>Sneak_f', {desc = 'f one char sneak'})
kb({'n', 'x'}, 'F', '<Plug>Sneak_F', {desc = 'F one char sneak'})
kb({'n', 'x'}, 't', '<Plug>Sneak_t', {desc = 't one char sneak'})
kb({'n', 'x'}, 'T', '<Plug>Sneak_T', {desc = 'T one char sneak'})

--[[ Commands/autocmds/keybindings not related to specific plugins ]]
require('grs.util.keybindings').general_kb()

local grs_text_group = augroup('grs_text', {})

-- Write file as root - works when sudo does not require a password
usercmd('WRF', 'w !sudo tee <f-args> > /dev/null', { nargs = 1 })
usercmd('WR', 'WRF %', {})

-- Case sensitive search while in command mode
autocmd('CmdLineEnter', {
   pattern = '*',
   command = 'set nosmartcase noignorecase',
   group = grs_text_group,
   desc = "Don't ignore case when in Command Mode"
})

autocmd('CmdLineLeave', {
   pattern = '*',
   command = 'set ignorecase smartcase',
   group = grs_text_group,
   desc = "Use smartcase when not in Command Mode"
})

-- Give visual feedback when yanking text
autocmd('TextYankPost', {
   pattern = '*',
   callback = function()
      vim.highlight.on_yank {
         timeout = 500,
         higroup = 'Visual'
      }
   end,
   group = grs_text_group,
   desc = 'Give visual feedback when yanking text'
})
