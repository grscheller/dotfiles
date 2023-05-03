--[[ Options - loaded before lazy takes control ]]

-- loaded very early

-- string, numeric  & boolean options
local options = {

   -- POSIX compatible shells are needed by some plugins
   shell = '/bin/sh',

   -- Set default fileencoding, localizations, and file formats
   fileencoding = 'utf-8',
   spelllang = 'en_us',
   fileformats = 'unix,mac,dos',

   -- Set default tab/indenting behavior
   tabstop = 4,       -- tab stops every 4 spaces, not size of tab character
   shiftwidth = 4,    -- number of columns used for auto-indentation
   softtabstop = 4,   -- <tab>/<bs> inserts/deletes 4 columns ws
   expandtab = true,  -- use only spaces when tabbing or auto-indenting

   -- Buffer/Editing preferences
   hidden = true,      -- my expectations are that buffers don't get abandoned
   joinspaces = true,  -- use 2 spaces when joining sentences
   nrformats = 'bin,hex,octal,alpha',  -- for <c-a> & <c-x>
   undofile = true,             -- save undo history in ~/.local/share/nvim/undo/
   ignorecase = true,           -- Case insensitive search when given
   smartcase = true,            -- just lower case search patterns.
   textwidth = 80,              -- keep comments & code horizontally under control
   colorcolumn = '+1,+21,+41',  -- keep comments <= 80 code <= 100, data <= 120 
   formatoptions = 'cqjp1',     -- for joining and breaking comment lines
   spelloptions = 'camel',      -- spellCheckCamelCaseComponents
   cpoptions = 'aABcfFJs',      -- the default is 'aABceFs_', cw & ce now differ

   -- Windowing preferences
   mouse = 'a',              -- enable mouse for all modes
   ruler = false,            -- disable ruler
   splitbelow = true,        -- horizontally split window below
   splitright = true,        -- vertically split window to right
   number = false,           -- initially no window line numbering
   relativenumber = false,   -- initially no window relative line numbering
   wrap = false,             -- don't wrap lines
   scrolloff = 1,            -- try to keep cursor off of top/bottom line of window
   sidescrolloff = 4,        -- try to keep cursor away from side of window
   sidescroll = 1,           -- horizontally scroll one character at a time

   -- Settings affecting LSP clients & plugins
   timeoutlen = 1200,                      -- ms to wait for key mapped sequence to complete
   updatetime = 400,                       -- ms of no cursor movement to trigger CursorHold event
   signcolumn = 'yes',                     -- fixes first column, reduces jitter
   showmode = false,                       -- redundant with Lualine
   showcmd = false,                        -- redundant with WhichKey
   completeopt = 'menu,menuone,noselect',  -- for nvim-cmp
   termguicolors = true,                   -- enable 24-bit RGB color for ISO-8613-3 terminals
   complete = '.,w,b,u,kspell',            -- no "t,i" - redundant with LSP
   shortmess = 'atToOc',                   -- shorten statusline - removed F for Scala Metals
   wildmenu = false,                       -- using hrsh7th/cmp-cmdline for this

   -- Essentially disable folding
   foldenable = false,     -- Allows the repurposing of folding
   foldmethod = 'manual',  -- related keymaps. I have an autocmd
   foldlevelstart = 99,    -- that helps it stay disabled.
}

for k, v in pairs(options) do
   vim.opt[k] = v
end

-- list & dictionary options
vim.opt.matchpairs:append { '<:>' }    -- additional symbols for '%' matching
vim.opt.iskeyword:append { '-' }       -- adds snake-case to word motions
vim.opt.listchars = {                  -- for :list, :set list, :set nolist
   space = '_',
   trail = '*',
   nbsp = '+',
   tab = '<->',
   eol = '$',
}
