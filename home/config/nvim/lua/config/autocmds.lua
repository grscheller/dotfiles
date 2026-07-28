--[[ Text related Autocmds & Usercmds ]]

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--[[ Auto commands related to nvim itself ]]

local GRS_Text_Grp = autogrp('GRS_Text', { clear = true })

-- Give visual feedback when yanking text
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
   desc = 'Make sure folding does not get in the way',
})

-- Keep ftplugins from overriding my formatoptions
autocmd('FileType', {
   pattern = '*',
   command = 'setlocal formatoptions=tcqjr1',
   group = GRS_Text_Grp,
   desc = 'Keep ftplugins from overriding my formatoptions',
})

-- MasonToolsInstaller related auto commands

autocmd('User', {
   pattern = 'MasonToolsStartingInstall',
   callback = function()
      vim.schedule(function()
         vim.notify 'mason-tool-installer (starting)'
      end)
   end,
})

autocmd('User', {
   pattern = 'MasonToolsUpdateCompleted',
   callback = function(e)
      vim.schedule(function()
         vim.notify(
            'mason-tool-installer (finished): ' .. vim.inspect(e.data)
         )
      end)
   end,
})
