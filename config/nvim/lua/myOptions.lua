--[[ Neovim Options, Functions & Autocommands

     Personal opinionated choices shaping Neovim
     behaviors.  Generally not related to specific
     plugins nor programming environments.         ]]

--[[ Set options ]]
local options = {
    shell = "/bin/sh",               -- Some packages need a POSIX compatible shell
    wildmenu = true,                 -- Make tab completion in
    wildmode = "longest:full,full",  -- command mode more useful.
    --
    --[[ Set default fileencoding, localizations, and file formats ]]
    fileencoding = "utf-8",
    spelllang = "en_us",
    fileformats = "unix,mac,dos",

    --[[ Set default tabstops and replace tabs with spaces ]]
    tabstop = 4,       -- Display hard tab as 4 spaces
    shiftwidth = 4,    -- Number of spaces used for auto-indent
    softtabstop = 4,   -- Insert/delete 4 spaces when inserting <Tab>/<BS>
    expandtab = true,  -- Expand tabs to spaces when inserting tabs

    --[[ Save undo history in ~/.local/share/nvim/undo/ ]]
    undofile = true,  -- nvim never deletes the undo histories stored here

    --[[ Other personnal preferences ]]
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

    --[[ Settings for LSP client & some plugins ]]
    timeoutlen = 1000,   -- Milliseconds to wait for key mapped sequence to complete
    updatetime = 300,    -- Set update time for CursorHold event
    signcolumn = "yes",  -- Fixes first column, reduces jitter
    showmode = false,    -- Redundant with Lualine
    showcmd = false      -- Redundant with WhichKey

}

for k, v in pairs(options) do
    vim.opt[k] = v
end

--[[ Modified options ]]
vim.o.matchpairs = vim.o.matchpairs .. ',<:>,「:」'  -- Additional matching pairs of characters
vim.o.iskeyword = vim.o.iskeyword .. ',-'            -- Adds snake-case to word motions

--[[ Case insensitive search, but not in command mode ]]
vim.opt['ignorecase'] = true
vim.opt['smartcase'] = true

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
vim.cmd [[
    augroup highlight_yank
        au!
        au TextYankPost * silent! lua vim.highlight.on_yank{timeout=600, on_visual=false}
    augroup end
]]

--[[ Toggle between 3 line numbering states ]]
vim.opt['number'] = false
vim.opt['relativenumber'] = false

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
