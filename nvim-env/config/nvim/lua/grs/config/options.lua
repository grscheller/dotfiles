--[[ Options - loaded before lazy takes control ]]

local options = {

   shell = '/bin/sh', -- POSIX compatible shells are needed by some plugins

   -- Set default file encoding, localization, and file formats
   fileencoding = 'utf-8',
   spelllang = 'en_us',
   fileformats = 'unix,mac,dos',

   -- Set default tab/indenting behavior
   tabstop = 4, -- tab stops every 4 spaces, not size of tab character
   shiftwidth = 4, -- number of columns used for auto-indentation with << & >>
   softtabstop = 4, -- <tab>/<bs> inserts/deletes 4 columns of white space
   expandtab = true, -- use only spaces when tabbing or auto-indenting
   autoindent = true, -- align a newline ident with previous line
   shiftround = true, -- round ident to a multiple of shiftwidth

   -- Buffer/Editing preferences
   hidden = true, -- my expectations are that buffers don't get abandoned
   joinspaces = false, -- use 2 spaces when joining sentences
   nrformats = 'bin,hex,octal,alpha', -- for <c-a> & <c-x>
   undofile = true, -- save undo history in ~/.local/share/nvim/undo/
   ignorecase = true, -- Case insensitive search when given
   smartcase = true, -- just lower case search patterns.
   textwidth = 80, -- keep comments & code horizontally under control
   colorcolumn = '+1,+21,+41', -- keep comments <= 80 code <= 100, data <= 120
   spelloptions = 'camel', -- spellCheckCamelCaseComponents
   formatoptions = 'tcqjr1', -- use <C-u> to undo unwanted comment insertion
   spell = true, -- use 'z ' to toggle unknown word highlighting

   -- Window preferences
   list = true, -- see listchars below
   hlsearch = true, -- highlight search term
   mouse = 'a', -- enable mouse for all modes
   number = false, -- initially no window line numbering
   relativenumber = false, -- initially no window relative line numbering
   scrolloff = 3, -- try to keep cursor off of top/bottom line of window
   sidescrolloff = 8, -- try to keep cursor away from side of window
   sidescroll = 1, -- horizontally scroll one character at a time
   splitbelow = true, -- horizontally split window below
   splitright = true, -- vertically split window to right
   ruler = false, -- disable ruler
   wrap = false, -- don't wrap lines

   -- Settings affecting LSP clients & plugins
   termguicolors = true, -- enable 24-bit RGB color for ISO-8613-3 terminals
   timeoutlen = 1200, -- ms to wait for key mapped sequence to complete
   updatetime = 400, -- ms of no cursor movement to trigger CursorHold event
   signcolumn = 'yes', -- fixes first column, reduces jitter
   showmode = false, -- redundant with Lualine
   showcmd = false, -- redundant with WhichKey
   wildmenu = false, -- using hrsh7th/cmp-cmdline for this
   shortmess = 'asAIcCF', -- shorten/gag extraneous statusline messages
   complete = '.,w,b,u,kspell', -- no "t,i" redundant with LSP
   completeopt = 'menu,menuone,noselect', -- for nvim-cmp

   -- Essentially disable folding
   foldenable = false, -- Allows the reuse of folding keybindings.
   foldmethod = 'manual', -- I have autocmd which helps folding stay disabled.
   foldlevelstart = 99,
}

for k, v in pairs(options) do
   vim.opt[k] = v
end

-- list & dictionary options
vim.opt.matchpairs:append { '<:>' } -- additional symbols for '%' matching
vim.opt.iskeyword:append { '-' } -- adds snake-case to word motions
vim.opt.listchars = {
   tab = '» ',
   trail = '·',
   nbsp = '␣',
}
