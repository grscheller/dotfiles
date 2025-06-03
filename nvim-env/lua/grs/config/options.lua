--[[ Options - loaded before lazy takes control ]]

vim.o.shell = '/bin/sh' -- POSIX compatible shells are needed by some plugins

-- Set default file encoding, localization, and file formats
vim.o.fileencoding = 'utf-8'
vim.o.spelllang = 'en_us'
vim.o.fileformats = 'unix,mac,dos'

-- Set default tab/indenting behavior
vim.o.tabstop = 4        -- tab stops every 4 spaces, not size of tab character
vim.o.shiftwidth = 4     -- number of columns used for auto-indentation with << & >>
vim.o.softtabstop = 4    -- <tab>/<bs> inserts/deletes 4 columns of white space
vim.o.expandtab = true   -- use only spaces when tabbing or auto-indenting
vim.o.autoindent = true  -- align a newline ident with previous line
vim.o.shiftround = true  -- round ident to a multiple of shiftwidth

-- Buffer/Editing preferences
vim.o.hidden = true                        -- my expectations are that buffers don't get abandoned
vim.o.joinspaces = false                   -- use 2 spaces when joining sentences
vim.o.nrformats = 'bin,hex,octal,alpha'    -- for <c-a> & <c-x>
vim.o.undofile = true                      -- save undo history in ~/.local/share/nvim/undo/
vim.o.ignorecase = true                    -- Case insensitive search when given
vim.o.smartcase = true                     -- ignore case for all lower case search patterns.
vim.o.textwidth = 80                       -- keep comments & code horizontally under control
vim.o.colorcolumn = '+1,+21,+41'           -- rule-of-thumb: comments <= 80 code <= 100, data <= 120
vim.o.spelloptions = 'camel'               -- spellCheckCamelCaseComponents
vim.o.formatoptions = 'tcqjr1'             -- use <C-u> to undo unwanted comment insertion
vim.o.spell = true                         -- use 'z ' to toggle unknown word highlighting
vim.o.matchpairs = '(:),{:},[:],<:>'       -- for '%' matching pair jumping
vim.o.iskeyword = '@,48-57,_,192-255,-'    -- adding - to defaults
vim.o.list = true                          -- Edit in "list" mode to always display these
vim.o.listchars = 'nbsp:␣,tab:» ,trail:·'  -- whitespace characters in an obtrusive way.

-- Window preferences
vim.o.hlsearch = true         -- highlight search term
vim.o.mouse = 'a'             -- enable mouse for all modes
vim.o.number = false          -- initially no window line numbering
vim.o.relativenumber = false  -- initially no window relative line numbering
vim.o.scrolloff = 3           -- try to keep cursor off of top/bottom line of window
vim.o.sidescrolloff = 8       -- try to keep cursor away from side of window
vim.o.sidescroll = 1          -- horizontally scroll one character at a time
vim.o.splitbelow = true       -- horizontally split window below
vim.o.splitright = true       -- vertically split window to right
vim.o.ruler = false           -- disable ruler
vim.o.wrap = false            -- don't wrap lines

-- Settings affecting LSP clients & plugins
vim.o.termguicolors = true                   -- enable 24-bit RGB color for ISO-8613-3 terminals
vim.o.timeoutlen = 1200                      -- ms to wait for key mapped sequence to complete
vim.o.updatetime = 400                       -- ms of no cursor movement to trigger CursorHold event
vim.o.signcolumn = 'yes'                     -- fixes first column, reduces jitter
vim.o.showmode = false                       -- redundant with Lualine
vim.o.showcmd = false                        -- redundant with WhichKey
vim.o.wildmenu = false                       -- using hrsh7th/cmp-cmdline for this
vim.o.shortmess = 'asAIcCF'                  -- shorten/gag extraneous statusline messages
vim.o.complete = '.,w,b,u,kspell'            -- no "t,i" redundant with LSP
vim.o.completeopt = 'menu,menuone,noselect'  -- for nvim-cmp

-- Essentially disable folding
vim.o.foldenable = false     -- Allows me to reuse of folding keybindings. I have
vim.o.foldmethod = 'manual'  -- an autocmd which helps folding stay disabled.
vim.o.foldlevelstart = 99

-- Configure diagnostics
vim.diagnostic.config {
   virtual_text = true, -- virtual text sometimes gets in the way
   underline = false,  -- set to true if virtual text is false
   update_in_insert = false,
   severity_sort = true,
   float = {
      border = "rounded",
      source = true,
   },
   signs = true,
}
