--[[ Autocmds not related to specific plugins

       Module: grs
       File: ~/.config/nvim/lua/grs/AutoCmds.lua

  ]]

-- Case sensitive search while in command mode
vim.cmd [[
  augroup dynamic_smartcase
    au!
    au CmdLineEnter : set nosmartcase
    au CmdLineEnter : set noignorecase
    au CmdLineLeave : set ignorecase
    au CmdLineLeave : set smartcase
  augroup end
]]

-- Give visual feedback for yanked text
vim.cmd[[
  augroup highlight_yank
    au!
    au TextYankPost * silent! lua vim.highlight.on_yank{ timeout=600, on_visual=false }
  augroup end
]]
