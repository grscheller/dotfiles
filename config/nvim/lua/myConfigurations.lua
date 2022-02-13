--[[ Neovim Options, Functions & Autocommands

     Personal opinionated choices shaping Neovim
     behaviors.  Generally not related to specific
     plugins nor programming environments.         ]]

--[[ Set some default behaviors ]]
vim.o.shell = "/bin/sh"  -- Some packages need a POSIX compatible shell
vim.o.path = vim.o.path .. ".,**"  -- Allow gf and :find to use recursive sub-folders
vim.o.wildmenu = true                 -- Make tab completion in
vim.o.wildmode = "longest:full,full"  -- command mode more useful.

--[[ Set default fileencoding, localizations, and file formats ]]
vim.o.fileencoding = "utf-8"
vim.o.spelllang = "en_us"
vim.o.fileformats = "unix,mac,dos"

--[[ Set default tabstops and replace tabs with spaces ]]
vim.o.tabstop = 4       -- Display hard tab as 4 spaces
vim.o.shiftwidth = 4    -- Number of spaces used for auto-indent
vim.o.softtabstop = 4   -- Insert/delete 4 spaces when inserting <Tab>/<BS>
vim.o.expandtab = true  -- Expand tabs to spaces when inserting tabs

--[[ Settings for LSP client & WhichKey]]
vim.o.timeoutlen = 1000   -- Milliseconds to wait for key mapped sequence to complete
vim.o.updatetime = 300    -- Set update time for CursorHold event
vim.o.signcolumn = "yes"  -- Fixes first column, reduces jitter
vim.o.shortmess = "atToOc"

--[[ Save undo history in ~/.local/share/nvim/undo/ ]]
vim.o.undofile = true  -- nvim never deletes the undo histories stored here

--[[ Some personnal preferences ]]
vim.o.mouse = "a"        -- Enable mouse for all modes
vim.o.joinspaces = true  -- Use 2 spaces when joinig sentances
vim.o.scrolloff = 2      -- Keep cursor away from top/bottom of window
vim.o.wrap = false       -- Don't wrap lines
vim.o.sidescroll = 1     -- Horizontally scroll nicely
vim.o.sidescrolloff = 5  -- Keep cursor away from side of window
vim.o.splitbelow = true  -- Horizontally split below
vim.o.splitright = true  -- Vertically split to right
vim.o.nrformats = "bin,hex,octal,alpha"  -- bases & single letters for <C-A> & <C-X>
vim.o.matchpairs = vim.o.matchpairs .. ",<:>,「:」"  -- Additional matching pairs of characters
vim.o.showmode = false  -- Redundant with Lualine
vim.o.showcmd = false   -- Redundant with WhichKey

--[[ Case insensitive search, but not in command mode ]]
vim.o.ignorecase = true
vim.o.smartcase = true
vim.api.nvim_exec([[
    augroup dynamic_smartcase
        au!
        au CmdLineEnter : set nosmartcase
        au CmdLineEnter : set noignorecase
        au CmdLineLeave : set ignorecase
        au CmdLineLeave : set smartcase
    augroup end
]], false)

--[[ Give visual feedback for yanked text ]]
vim.api.nvim_exec([[
    augroup highlight_yank
        au!
        au TextYankPost * silent! lua vim.highlight.on_yank{timeout=600, on_visual=false}
    augroup end
]], false)

--[[ Toggle between 3 line numbering states ]]
vim.o.number = false
vim.o.relativenumber = false

myLineNumberToggle = function()
    if vim.o.relativenumber == true then
        vim.o.number = false
        vim.o.relativenumber = false
    elseif vim.o.number == true then
        vim.o.number = false
        vim.o.relativenumber = true
    else
        vim.o.number = true
        vim.o.relativenumber = false
    end
end
