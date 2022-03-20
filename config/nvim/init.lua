-- Neovim configuration ~/.config/nvim/init.lua

local options = {
  shell = "/bin/bash",  -- POSIX compatible shell needed by some plugins

  -- Set default fileencoding, localizations, and file formats
  fileencoding = "utf-8",
  spelllang = "en_us",
  fileformats = "unix,mac,dos",

  -- Set default tabstops, replace tabs with spaces
  tabstop = 8,       -- Tabstop actual <Tab>'s every 8 spaces
  shiftwidth = 4,    -- Number of spaces used for auto-indentation
  softtabstop = 4,   -- Insert/delete 4 spaces when inserting <Tab>/<BS>
  expandtab = true,  --[[ Expand inserted tabs to spaces.  While in
                          insert mode, use <C-V><Tab> to insert an
                          actual <Tab> ]]
  
  -- Other personnal preferences
  mouse = "a",           -- Enable mouse for all modes
  joinspaces = true,     -- Use 2 spaces when joinig sentances
  wrap = false,          -- Don't wrap lines
  sidescroll = 1,        -- Horizontally scroll nicely
  sidescrolloff = 5,     -- Keep cursor away from side of window
  splitbelow = true,     -- Horizontally split below
  splitright = true,     -- Vertically split to right
  nrformats = "bin,hex,octal,alpha",  -- bases & single letters for <C-A> & <C-X>
  undofile = true,  --[[ Save undo history in ~/.local/share/nvim/undo/,
                         nvim never deletes thesw undo histories. ]]

  -- Settings affected due to LSP client & plugins
  timeoutlen = 1000,   -- Milliseconds to wait for key mapped sequence to complete
  updatetime = 300,    -- Set update time for CursorHold event
  signcolumn = "yes",  -- Fixes first column, reduces jitter
  showmode = false,    -- Redundant with Lualine
  showcmd = false,     -- Redundant with WhichKey
  completeopt = "menuone,noinsert,noselect",  -- For nvim-cmp
  termguicolors = true,  -- for Tokyo Night, and most other, colorschemes
  complete = ".,w,b,u,kspell",  -- no "t,i" for ins-completion-menu - redundant with LSP
  shortmess = "atToOc"  --[[ shorten statusline, don't give ins-completion-menu
                              messages, remove F for Scala Metals ]]
}

--[[ Case insensitive search, but not in command mode ]]
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

--[[ Give visual feedback for yanked text ]]
vim.cmd[[
  augroup highlight_yank
    au!
    au TextYankPost * silent! lua vim.highlight.on_yank{timeout=600, on_visual=false}
  augroup end
]]

--[[ Toggle between 3 line numbering states ]]
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

--[[ Let nvim know which options to set ]]
for k, v in pairs(options) do
  vim.opt[k] = v
end

--[[ Modified existing nvim options ]]
vim.o.matchpairs = vim.o.matchpairs .. ',<:>,「:」'  -- Additional matching pairs of characters
vim.o.iskeyword = vim.o.iskeyword .. ',-'            -- Adds snake-case to word motions

--[[ Set <leader> & <localleader> ]]
vim.api.nvim_set_keymap('n', '-', '<Nop>', { noremap = true })
vim.g.mapleader = '\\'      -- set to single `\`
vim.g.maplocalleader = '-'  -- probably will never use this one

--[[ Set up plugins for an IDE like development environment ]]
require('grs')

--[[ Set up general purpose keybindings ]]
local ok, wk = pcall(require, 'which-key')
if not ok then
  print('Problem loading which-key.nvim.')
  return
end

-- Window navigation/position/size related keybindings
local window_management_opts = {
  mode = "n",
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
}

local window_management_kb = {
  -- Navigate between windows using CTRL+arrow-keys
  ['<C-H>'] = {'<C-W>h', 'Goto Window Left' },
  ['<C-J>'] = {'<C-W>j', 'Goto Window Down' },
  ['<C-K>'] = {'<C-W>k', 'Goto Window Up'   },
  ['<C-L>'] = {'<C-W>l', 'Goto Window Right'},
  -- Move windows around using CTRL-hjkl
  ['<M-Left>']  = {'<C-W>H', 'Move Window LHS'},
  ['<M-Down>']  = {'<C-W>J', 'Move Window BOT'},
  ['<M-Up>']    = {'<C-W>K', 'Move Window TOP'},
  ['<M-Right>'] = {'<C-W>L', 'Move Window RHS'},
  -- Resize windows using ALT-hjkl for Linux
  ['<M-h>'] = {'2<C-W><', 'Make Window Narrower'},
  ['<M-j>'] = {'2<C-W>-', 'Make Window Shorter' },
  ['<M-k>'] = {'2<C-W>+', 'Make Window Taller'  },
  ['<M-l>'] = {'2<C-W>>', 'Make Window Wider'   }
}

wk.register(window_management_kb, window_management_opts)

-- Visual mode keymappings
local visual_mode_kb = {
  ['<'] = {'<gv', 'Shift Left & Reselect'},  -- Reselect visual region
  ['>'] = {'>gv', 'Shift Right & Reselect'}  -- upon indention of text.
}

local visual_mode_opts = {
  mode = "v",
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
}

wk.register(visual_mode_kb, visual_mode_opts)

-- Normal mode <Space> keybindings
normal_mode_space_kb = {
  b = {':enew<CR>', 'New Unnamed Buffer'},
  h = {':TSBufToggle highlight<CR>', 'Treesitter Highlight Toggle'},
  k = {':dig<CR>a<C-K>', 'Pick & Enter Diagraph'},
  l = {':mode<CR>', 'Clear & Redraw Screen'},  -- Lost <C-L> for this above
  n = {':lua myLineNumberToggle()<CR>', 'Line Number Toggle'},
  f = {
    name = '+Fish Shell in Terminal',
    s = {':split<CR>:term fish<CR>i', 'Fish Shell in split'},
    v = {':vsplit<CR>:term fish<CR>i', 'Fish Shell in vsplit'} },
  s = {':set invspell<CR>', 'Toggle Spelling'},
  t = {':%s/\\s\\+$//<CR>', 'Trim Trailing Whitespace'},
  ['<Space>'] = {':nohlsearch<CR>', 'Clear hlsearch'}
}

local normal_mode_space_opts = {
  mode = 'n',
  prefix = '<Space>',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
}

wk.register(normal_mode_space_kb, normal_mode_space_opts)
