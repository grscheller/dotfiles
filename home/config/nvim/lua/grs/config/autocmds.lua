--[[ Autocmds & Usercmds loaded on "VeryLazy" event ]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

--[[ Text editing commands/autocmds not related to specific plugins ]]
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

-- Mason-tool-installer
autocmd('User', {
   pattern = 'MasonToolsUpdateCompleted',
   callback = function()
      vim.schedule(function()
         print '  mason-tool-installer has finished!'
      end)
   end,
})
