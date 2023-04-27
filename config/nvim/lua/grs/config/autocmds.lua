--[[ Autocmds & Usercmds - loaded on VeryLazy event ]]

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

--[[ Text editing commands/autocmds not related to specific plugins ]]
local GrsTextGrp = autogrp('GrsText', {})

-- Write file as root - works when sudo doesn't require a password
usercmd('WRF', 'w !sudo tee <f-args> > /dev/null', { nargs = 1 })
usercmd('WR', 'WRF %', {})

-- No smartcase while in cmdline mode
autocmd('CmdLineEnter', {
   pattern = '*',
   command = 'set nosmartcase noignorecase',
   group = GrsTextGrp,
   desc = 'Use case sensitive search in command mode',
})

-- Use smartcase outside cmdline mode
autocmd('CmdLineLeave', {
   pattern = '*',
   command = 'set ignorecase smartcase',
   group = GrsTextGrp,
   desc = 'Use smartcase when not in Command Mode',
})

autocmd('TextYankPost', {
   pattern = '*',
   callback = function()
      vim.highlight.on_yank { timeout = 500, higroup = 'Visual' }
   end,
   group = GrsTextGrp,
   desc = 'Give visual feedback when yanking text',
})

-- Return to last edit posistion - doesn't work for first file on cmdline
autocmd('BufReadPost', {
   pattern = '*',
   callback = function()
      if vim.fn.line '\'"' > 1 and vim.fn.line '\'"' <= vim.fn.line '$' then
         vim.api.nvim_exec('normal! g\'"', false)
      end
   end,
   group = GrsTextGrp,
   desc = 'Open file at last cursor position',
})
