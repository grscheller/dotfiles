--[[ Options reflecting my personal preferences ]]

local options = {
   -- POSIX compatible shells are needed by some plugins
   shell = '/bin/sh',

   -- Set default fileencoding, localizations, and file formats
   fileencoding = 'utf-8',
   spelllang = 'en_us',
   fileformats = 'unix,mac,dos',

   -- Set default tab stops and auto-indenting behavior
   tabstop = 8, -- set tab stops every 8 columns
   shiftwidth = 4, -- number of columns used for auto-indentation
   softtabstop = 4, -- insert/delete 4 columns of ws when tabbing/backspacing
   expandtab = true, -- use only spaces when tabbing or auto-indenting

   -- Buffer/Editing preferences
   hidden = true, -- my expectations are that buffers don't get abandoned
   joinspaces = true, -- use 2 spaces when joinig sentances
   nrformats = 'bin,hex,octal,alpha', -- bases & single letters for <C-A> & <C-X>
   undofile = true, -- save undo history in ~/.local/share/nvim/undo/
   ignorecase = true, -- Default to case insensitive search if
   smartcase = true, -- give just lower case search patterns.

   -- Windowing preferences
   mouse = 'a', -- enable mouse for all modes
   ruler = false, -- disable ruler
   splitbelow = true, -- horizontally split window below
   splitright = true, -- vertically split window to right
   number = false, -- Default initial window
   relativenumber = false, -- line numbering state.
   wrap = false, -- don't wrap lines
   scrolloff = 1, -- try to keep cursor off of top/bottom line of window
   sidescrolloff = 4, -- try to keep cursor away from side of window
   sidescroll = 1, -- horizontally scroll one character at a time

   -- Settings affecting LSP clients & plugins
   timeoutlen = 1500, -- milliseconds to wait for key mapped sequence to complete
   updatetime = 300, -- set update time for CursorHold event
   signcolumn = 'yes', -- fixes first column, reduces jitter
   showmode = false, -- redundant with Lualine
   showcmd = false, -- redundant with WhichKey
   completeopt = 'menuone,noinsert,noselect', -- for nvim-cmp
   termguicolors = true, -- enable 24-bit RGB color on ISO-8613-3 compaible terminals
   complete = '.,w,b,u,kspell', -- no "t,i" for ins-completion-menu - redundant with LSP
   shortmess = 'atToOc' -- shorten statusline - removed F for Scala Metals
}

for k, v in pairs(options) do
   vim.opt[k] = v
end

-- Modified existing nvim options
vim.o.matchpairs = vim.o.matchpairs .. ',<:>,「:」' -- additional matching pairs of characters
vim.o.iskeyword = vim.o.iskeyword .. ',-' -- adds snake-case to word motions
