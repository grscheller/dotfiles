--[[ Commands & autocmds not related to specific plugins ]]

--[[ Write file as root - works when sudo does not require a password ]]
vim.api.nvim_create_user_command('WRF', 'w !sudo tee <f-args> > /dev/null', { nargs = 1 })
vim.api.nvim_create_user_command('WR', 'WRF %', {})

--[[ Case sensitive search while in command mode ]]
vim.api.nvim_create_autocmd('CmdLineEnter', {
  pattern = '*',
  command = 'set nosmartcase noignorecase',
  desc = "Don't ignore case when in Command Mode"
})

vim.api.nvim_create_autocmd('CmdLineLeave', {
  pattern = '*',
  command = 'set ignorecase smartcase',
  desc = "Use smartcase when not in Command Mode"
})

--[[ Give visual feedback when yanking text ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank {
      timeout = 600,
      on_visual = false
    }
  end,
  desc = 'Give visual feedback when yanking text'
})
