--[[ Text related Autocmds & Usercmds ]]

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

--[[ Text editing commands/autocmds not related to specific plugins ]]
local GrsTextGrp = autogrp('GrsText', { clear = true })

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
      vim.hl.on_yank { timeout = 500, higroup = 'Visual' }
   end,
   group = GrsTextGrp,
   desc = 'Give visual feedback when yanking text',
})

-- Make sure folding remains essentially disabled.
autocmd({ 'BufWritePost', 'BufEnter' }, {
   pattern = '*',
   callback = function()
      vim.o.foldenable = false
      vim.o.foldmethod = 'manual'
      vim.o.foldlevelstart = 99
   end,
   group = GrsTextGrp,
   desc = 'Make sure folding is off',
})

-- Keep ftplugins from overriding my formatoptions
autocmd('FileType', {
   pattern = '*',
   command = 'setlocal formatoptions=tcqjr1',
   group = GrsTextGrp,
   desc = 'Keep ftplugins from overriding my formatoptions',
})
