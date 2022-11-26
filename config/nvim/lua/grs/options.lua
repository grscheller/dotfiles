--[[ Options - reflecting my personal preferences ]]

local options = {
   -- POSIX compatible shells are needed by some plugins
   shell = '/bin/sh',

   -- Set default fileencoding, localizations, and file formats
   fileencoding = 'utf-8',
   spelllang = 'en_us',
   fileformats = 'unix,mac,dos',

   -- Set default tab/indenting behavior
   tabstop = 8, -- set tab stops every 8 columns, makes tab chars easy to spot
   shiftwidth = 4, -- number of columns used for auto-indentation
   softtabstop = 4, -- insert/delete 4 columns of ws when tabbing/backspacing
   expandtab = true, -- use only spaces when tabbing or auto-indenting

   -- Buffer/Editing preferences
   hidden = true, -- my expectations are that buffers don't get abandoned
   joinspaces = true, -- use 2 spaces when joinig sentances
   nrformats = 'bin,hex,octal,alpha', -- for <C-A> & <C-X>
   undofile = true, -- save undo history in ~/.local/share/nvim/undo/
   ignorecase = true, -- Case insensitive search when given
   smartcase = true,  -- just lower case search patterns.
   colorcolumn = '80', -- indicate column 80, as a guide to keep source code

   -- Windowing preferences
   mouse = 'a', -- enable mouse for all modes
   ruler = false, -- disable ruler
   splitbelow = true, -- horizontally split window below
   splitright = true, -- vertically split window to right
   number = false, -- initially no window line numbering
   relativenumber = false, -- initially no window relative line numbering
   wrap = false, -- don't wrap lines
   scrolloff = 1, -- try to keep cursor off of top/bottom line of window
   sidescrolloff = 4, -- try to keep cursor away from side of window
   sidescroll = 1, -- horizontally scroll one character at a time

   -- Settings affecting LSP clients & plugins
   timeoutlen = 1500, -- ms to wait for key mapped sequence to complete
   updatetime = 300, -- set update time for CursorHold event
   signcolumn = 'yes', -- fixes first column, reduces jitter
   showmode = false, -- redundant with Lualine
   showcmd = false, -- redundant with WhichKey
   completeopt = 'menu,menuone,noselect', -- for nvim-cmp
   termguicolors = true, -- enable 24-bit RGB color for ISO-8613-3 terminals
   complete = '.,w,b,u,kspell', -- no "t,i" - redundant with LSP
   shortmess = 'atToOc' -- shorten statusline - removed F for Scala Metals
}

for k, v in pairs(options) do
   vim.opt[k] = v
end

-- Modified existing nvim options
vim.opt.matchpairs:append { '<:>' } -- additional symbols for '%' matching
vim.opt.iskeyword:append { '-' } -- adds snake-case to word motions