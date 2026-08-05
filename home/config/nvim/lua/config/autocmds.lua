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

-- Make sure folding remains essentially disabled outside diff mode.
autocmd('OptionSet', {
   pattern = 'diff',
   callback = function()
      if not vim.v.option_new then
         vim.opt_local.foldenable = false
      end
   end,
   group = GRS_Text_Grp,
   desc = 'Keep folding off when leaving diff mode',
})

-- Keep ftplugins from overriding my formatoptions
autocmd('FileType', {
   pattern = '*',
   command = 'setlocal formatoptions=tcqjr1',
   group = GRS_Text_Grp,
   desc = 'Keep ftplugins from overriding my formatoptions',
})

-- MasonToolsInstaller related auto commands:

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
