--[[ Text related Autocmds & Usercmds ]]

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--[[ Auto commands related to nvim itself ]]

local GRS_Text_Grp = autogrp('GRS_Text', { clear = true })

-- No smartcase while in cmdline mode
autocmd('CmdLineEnter', {
   pattern = '*',
   command = 'set nosmartcase noignorecase',
   group = GRS_Text_Grp,
   desc = 'Use case sensitive search in command mode',
})

-- Use smartcase outside cmdline mode
autocmd('CmdLineLeave', {
   pattern = '*',
   command = 'set ignorecase smartcase',
   group = GRS_Text_Grp,
   desc = 'Use smartcase when not in Command Mode',
})

autocmd('TextYankPost', {
   pattern = '*',
   callback = function()
      vim.hl.on_yank { timeout = 500, higroup = 'Visual' }
   end,
   group = GRS_Text_Grp,
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
   group = GRS_Text_Grp,
   desc = 'Make sure folding is off',
})

-- Keep ftplugins from overriding my formatoptions
autocmd('FileType', {
   pattern = '*',
   command = 'setlocal formatoptions=tcqjr1',
   group = GRS_Text_Grp,
   desc = 'Keep ftplugins from overriding my formatoptions',
})
