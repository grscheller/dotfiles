--[[ Options, functions & autocmds - not related to specific plugins

       Module: grs
       File: ~/.config/nvim/lua/grs/Options.lua

  ]]

-- Define options to be set
local options = {
  shell = '/bin/bash',  -- POSIX compatible shells are needed by some plugins

  -- Set default fileencoding, localizations, and file formats
  fileencoding = 'utf-8',
  spelllang = 'en_us',
  fileformats = 'unix,mac,dos',

  -- Set default tab stops and auto-indenting behavior
  tabstop = 8,  -- Set tab stops every 8 columns
  shiftwidth = 4,  -- Number of columns used for auto-indentation
  softtabstop = 4,  -- Insert/delete 4 columns of ws when tabbing/backspacing
  expandtab = true,  -- Use only spaces when tabbing or auto-indenting

  -- Other personnal preferences
  mouse = 'a',  -- Enable mouse for all modes
  hidden = true,  -- my expectations are that buffers don't get abandoned
  joinspaces = true,  -- Use 2 spaces when joinig sentances
  wrap = false,  -- Don't wrap lines
  splitbelow = true,  -- Horizontally split below
  splitright = true,  -- Vertically split to right
  nrformats = 'bin,hex,octal,alpha',  -- bases & single letters for <C-A> & <C-X>
  undofile = true,  -- Save undo history in ~/.local/share/nvim/undo/

  -- Settings affected due to LSP client & plugins
  timeoutlen = 1000,  -- Milliseconds to wait for key mapped sequence to complete
  updatetime = 300,  -- Set update time for CursorHold event
  signcolumn = 'yes',  -- Fixes first column, reduces jitter
  showmode = false,  -- Redundant with Lualine
  showcmd = false,  -- Redundant with WhichKey
  completeopt = 'menuone,noinsert,noselect',  -- For nvim-cmp
  termguicolors = true,  -- for Tokyo Night, and most other, colorschemes
  complete = '.,w,b,u,kspell',  -- no "t,i" for ins-completion-menu - redundant with LSP
  shortmess = 'atToOc'  --[[ shorten statusline, don't give ins-completion-menu
                              messages, removed F for Scala Metals ]]
}

-- Case insensitive search, but not in command mode
options['ignorecase'] = true
options['smartcase'] = true

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

-- Toggle between 3 line numbering states on per window basis
options['number'] = false
options['relativenumber'] = false

myLineNumberToggle = function()
  if vim.wo.relativenumber == true then
    vim.wo.number = false
    vim.wo.relativenumber = false
  elseif vim.wo.number == true then
    vim.wo.number = false
    vim.wo.relativenumber = true
  else
    vim.wo.number = true
    vim.wo.relativenumber = false
  end
end

-- Now set the options defined above
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Modified existing nvim options
vim.o.matchpairs = vim.o.matchpairs .. ',<:>,「:」'  -- Additional matching pairs of characters
vim.o.iskeyword = vim.o.iskeyword .. ',-'  -- Adds snake-case to word motions

-- Setup some general purpose key mappings
local whichkey = require('grs.WhichKey')

if whichkey then
  whichkey.gpKB()
else
  print('General Purpose key binding setup failed')
end
