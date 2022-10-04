--[[ Commands & autocmds not related to specific plugins ]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

local grs_group = augroup('grs', {})

--[[ Write file as root - works when sudo does not require a password ]]
usercmd('WRF', 'w !sudo tee <f-args> > /dev/null', { nargs = 1 })
usercmd('WR', 'WRF %', {})

--[[ Case sensitive search while in command mode ]]
autocmd('CmdLineEnter', {
   pattern = '*',
   command = 'set nosmartcase noignorecase',
   group = grs_group,
   desc = "Don't ignore case when in Command Mode"
})

autocmd('CmdLineLeave', {
   pattern = '*',
   command = 'set ignorecase smartcase',
   group = grs_group,
   desc = "Use smartcase when not in Command Mode"
})

--[[ Give visual feedback when yanking text ]]
autocmd('TextYankPost', {
   pattern = '*',
   callback = function()
      vim.highlight.on_yank {
         timeout = 600,
         on_visual = false
      }
   end,
   group = grs_group,
   desc = 'Give visual feedback when yanking text'
})

-- Todo: Incorporated ideas from
-- https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/lua/theprimeagen/init.lua
-- See where else autocmds/augroups are used.
