--[[ Neovim configuration ~/.config/nvim/init.lua ]]

local options = {
   -- Some plugins need a POSIX compatible shell
   shell = "/bin/bash",

   -- Set default fileencoding, localizations, and file formats
   fileencoding = "utf-8",
   spelllang = "en_us",
   fileformats = "unix,mac,dos",

   -- Set default tabstops, replace tabs with spaces
   tabstop = 8,       -- Display hard tab as 8 spaces
   shiftwidth = 4,    -- Number of spaces used for auto-indent
   softtabstop = 4,   -- Insert/delete 4 spaces when inserting <Tab>/<BS>
   expandtab = true,  -- Expand tabs to spaces when inserting tabs

   -- Save undo history in ~/.local/share/nvim/undo/, nvim
   -- never deletes the undo histories stored there.
   undofile = true,

   -- Other personnal preferences
   mouse = "a",           -- Enable mouse for all modes
   joinspaces = true,     -- Use 2 spaces when joinig sentances
   scrolloff = 2,         -- Keep cursor away from top/bottom of window
   wrap = false,          -- Don't wrap lines
   sidescroll = 1,        -- Horizontally scroll nicely
   sidescrolloff = 5,     -- Keep cursor away from side of window
   splitbelow = true,     -- Horizontally split below
   splitright = true,     -- Vertically split to right
   shortmess = "atToOc",  -- shorten statusline & don't give ins-completion-menu messages
   nrformats = "bin,hex,octal,alpha",  -- bases & single letters for <C-A> & <C-X>

   -- Settings for LSP client & plugins
   timeoutlen = 1000,   -- Milliseconds to wait for key mapped sequence to complete
   updatetime = 300,    -- Set update time for CursorHold event
   signcolumn = "yes",  -- Fixes first column, reduces jitter
   showmode = false,    -- Redundant with Lualine
   showcmd = false,     -- Redundant with WhichKey
   completeopt = "menuone,noinsert,noselect",  -- For nvim-cmp
   termguicolors = true,  -- for Tokyo Night, and most other, colorschemes
   complete = ".,w,b,u,kspell"  -- no "t,i" for ins-completion-menu - redundant with LSP
}

--[[ Case insensitive search, but not in command mode ]]
options['ignorecase'] = true
options['smartcase'] = true

vim.cmd[[
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

--[[ Set options in nvim ]]
for k, v in pairs(options) do
   vim.opt[k] = v
end

--[[ Modified existing nvim options ]]
vim.o.matchpairs = vim.o.matchpairs .. ',<:>,「:」'  -- Additional matching pairs of characters
vim.o.iskeyword = vim.o.iskeyword .. ',-'            -- Adds snake-case to word motions

--[[ Set up plugins ]]
require('grs.plugins')

--[[ Set up Key Bindings ]]
require('grs.keybindings.myKeybindings')
