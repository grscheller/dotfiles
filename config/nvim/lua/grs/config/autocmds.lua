--[[ Autocmds & Usercmds - loaded via plugins/config.lua ]]

-- loaded on "VeryLazy" event

--[[ Text editing commands/autocmds not related to specific plugins ]]
local grs_text_group = vim.api.nvim_create_augroup('grs_text', {})

-- Write file as root - works when sudo doesn't require a password
vim.api.nvim_create_user_command('WRF', 'w !sudo tee <f-args> > /dev/null', { nargs = 1 })
vim.api.nvim_create_user_command('WR', 'WRF %', {})

vim.api.nvim_create_autocmd('CmdLineEnter', {
   pattern = '*',
   command = 'set nosmartcase noignorecase',
   group = grs_text_group,
   desc = 'Use case sensitive search in command mode',
})

-- delete this comment
vim.api.nvim_create_autocmd('CmdLineLeave', {
   pattern = '*',
   command = 'set ignorecase smartcase',
   group = grs_text_group,
   desc = 'Use smartcase when not in Command Mode',
})

vim.api.nvim_create_autocmd('TextYankPost', {
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

vim.api.nvim_create_autocmd('BufReadPost', {
   pattern = '*',
   callback = function()
      if vim.fn.line('\'"') > 1 and vim.fn.line('\'"') <= vim.fn.line('$') then
         vim.api.nvim_exec('normal! g\'"', false)
      end
   end,
   group = grs_text_group,
   desc = 'Open file at last cursor position',
})

--[[ Mason-tool-installer feedback ]]
local grs_mason_group = vim.api.nvim_create_augroup('grs_mason', {})

vim.api.nvim_create_autocmd('User', {
   pattern = 'MasonToolsUpdateCompleted',
   callback = function()
      vim.schedule(function()
         vim.notify '  mason-tool-installer has finished!'
      end)
   end,
   group = grs_mason_group,
   desc = 'Give feedback when Mason is finished updating',
})
