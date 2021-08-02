-- Neovim configuration file ~/.config/nvim/init.lua

--[[ Bootstrap Paq by cloning into "right place"

       git clone https://github.com/savq/paq-nvim.git \
           ~/.local/share/nvim/site/pack/paqs/opt/paq-nvim

     then from command mode run

       :PaqInstall

     Paq Commands:
       :PaqInstall  <- Install all packages listed in configuration below
       :PaqUpdate   <- Update packages already on system
       :PaqClean    <- Remove packages not in configuration
       :PaqSync     <- Execute all three operations above ]]
require'paq' {
    "savq/paq-nvim";  -- Paq manages itself
    "nvim-telescope/telescope.nvim";  -- fuzzy finder over lists
    "nvim-lua/plenary.nvim";          -- required by telescope.nvim
    "nvim-lua/popup.nvim";            -- required by telescope.nvim
    "folke/which-key.nvim";  -- show possible keybinding in popup, also can define keybindings
    "neovim/nvim-lspconfig";  -- Collection of common configurations for built-in LSP client
    "hrsh7th/nvim-compe";     -- Autocompletion framework for built-in LSP client
    "hrsh7th/vim-vsnip";      -- Snippet engine to handle LSP snippets
    "simrat39/rust-tools.nvim";  -- extra functionality over rust analyzer
    "scalameta/nvim-metals";  -- Metals LSP server for Scala
    "dag/vim-fish";  -- Provide Fish syntax highlighting support.
    "tpope/vim-surround";  -- Surrond text objects with matching (). {}. '', etc.
                           --     ds delete surronding - ds"
                           --     cs change surronding - cs[{
                           --     ys surround text object or motion - ysiw)
                           --   Works on various markup tags and in visual line mode.
    "tpope/vim-repeat";  -- Repeat last action via "." for supported packages.
    "vim-airline/vim-airline";  -- Used to configure statusline.
    "norcalli/nvim-colorizer.lua";  -- Colorize hexcodes and names like Blue.
    "grscheller/tokyonight.nvim"  -- Install my hacked version of Tokyo Night colorschemes.
}

-- Set default encoding, localizations, and file formats
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.spelllang = "en_us"
vim.o.fileformats = "unix,mac,dos"

vim.o.modeline = false -- Remove Vim vulnerability
vim.o.shell = "/bin/sh"  -- Some packages need a POSIX compatible shell
vim.o.backspace = "indent,eol,start"  -- More powerful backspacing in insert mode
vim.o.path = vim.o.path .. ".,**"  -- Allow gf and :find to use recursive sub-folders

-- Allow hidden buffers; don't ask to save changes when leaving buffer
vim.o.hidden = true

-- Make tab completion in command mode more useful
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"

-- For a better completion experience in insert mode
vim.o.completeopt = "menuone,noinsert,noselect"

-- Milliseconds to wait for key mapped sequence to complete
vim.o.timeoutlen = 800

-- Message settings most compatible with builtin LSP client
vim.o.shortmess = "atToOc"
--
-- Some personnal preferences
vim.o.history = 10000    -- Number lines of command history to keep
vim.o.mouse = "a"        -- Enable mouse for all modes
vim.o.scrolloff = 2      -- Keep cursor away from top/bottom of window
vim.o.wrap = false       -- Don't wrap lines
vim.o.sidescroll = 1     -- Horizontally scroll nicely
vim.o.sidescrolloff = 5  -- Keep cursor away from side of window
vim.o.splitbelow = true  -- Horizontally split below
vim.o.splitright = true  -- Vertically split to right
vim.o.showcmd = true     -- Show partial normal mode commands in lower right corner
vim.o.hlsearch = true       -- Highlight search results
vim.o.incsearch = true      -- Highlight search matches as you type
vim.o.nrformats = "bin,hex,octal,alpha"  -- bases and single letters used for <C-A> & <C-X>

-- Set default tabstops and replace tabs with spaces
vim.o.tabstop = 4       -- tab size 4 spaces
vim.o.shiftwidth = 4    -- number of spaces used for auto-indent
vim.o.softtabstop = 4   -- number spaces in tab when editing
vim.o.expandtab = true  -- expand tabs to spaces when inserting tabs

-- Set additional matching pairs of characters and highlight matching brackets
vim.o.matchpairs = vim.o.matchpairs .. ",<:>,「:」"

-- Set up smartcase, don't use in command mode
vim.o.ignorecase = true     -- Case insensitive search,
vim.o.smartcase = true      -- unless query has caps.

vim.api.nvim_exec([[
  augroup dynamic_smartcase
    au!
    au CmdLineEnter : set nosmartcase
    au CmdLineEnter : set noignorecase
    au CmdLineLeave : set smartcase
    au CmdLineLeave : set noignorecase
  augroup end
]], false)

--[[ Setup folke/which-key.nvim ]]
local wk = require'which-key'
wk.setup {}

-- example from folke/which-key.nvim
wk.register({
  ["<Leader>f"] = { name = "+file" },
  ["<Leader>ff"] = { "<Cmd>Telescope find_files<CR>", "Find file" },
  ["<Leader>fr"] = { "<Cmd>Telescope oldfiles<CR>", "Open recent file" },
  ["<Leader>fn"] = { "<Cmd>enew<cr>", "New File" }
})

--[[ Compe for commpletion ]]
require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    source = {
        path = true;
        buffer = true;
        calc = true;
        vsnip = true;
        nvim_lsp = true;
        nvim_lua = true;
        spell = true;
        tags = true;
        snippets_nvim = true
    }
}

vim.api.nvim_set_keymap('i', '<C-Space>', "compe#complete()", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<CR>', "compe#confirm('<CR>')", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-e>', "compe#close('<C-e>')", { noremap = true, expr = true, silent = true })

vim.o.signcolumn = "yes"  -- Fix column to reduce jitter
vim.o.updatetime = 300    -- Set update time for CursorHold

vim.api.nvim_exec([[
  augroup compe_cursorhold
    au!
    au CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
  augroup end
]], false)

-- Setup key mappings, define <Leader> explicitly as a space
vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', { noremap = true })
vim.g.mapleader = ' '

-- Toggle between 3 line numbering states via <Leader>n
vim.o.number = false
vim.o.relativenumber = false

MyLineNumberToggle = function()
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

wk.register({
  ["<Leader>n"] = { "<Cmd>lua MyLineNumberToggle<CR>", "Line number toggle" },
  ["<Leader><Space>"] = { "<Cmd>nohlsearch<CR>", "Clear hlsearch" },
  ["<Leader>sp"] = { "<Cmd>set invspell<CR>", "Toggle spelling" }
})

-- vim.api.nvim_set_keymap('n', '<Leader>n', '<Cmd>lua MyLineNumberToggle()<CR>', { noremap = true, silent = true })

-- Clear search highlighting
--vim.api.nvim_set_keymap('n', '<Leader><Space>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Trim all trailing whitespace
vim.api.nvim_set_keymap('n', '<Leader>ws', ':%s/\\s\\+$//<CR>', { noremap = true })

-- Toggle spell checking
-- vim.api.nvim_set_keymap('n', '<Leader>sp', ':set invspell<CR>', { noremap = true, silent = true })

-- Fix an old vi inconsistancy between Y and D & C
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Automatically reselect visual area when visual shifting
vim.api.nvim_set_keymap('x', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('x', '>', '>gv', { noremap = true })

-- Open a vertical terminal running fish shell
vim.api.nvim_set_keymap('n', '<Leader>t', ':vsplit<CR>:term fish<CR>i', { noremap = true })

-- Reduce keystrokes and memmory load from :dig to entering digraph
   -- position cursor on char before you want to insert digraph
   -- type <Leader>k
   -- use q to exit digraph table
   -- type digraph
vim.api.nvim_set_keymap('n', '<Leader>k', ':dig<CR>a<C-K>', { noremap = true })

-- Clear & redraw screen, lost <C-L> to do that below
vim.api.nvim_set_keymap('n', '<Leader>l', ':mode<CR>', { noremap = true, silent = true })

-- Move windows around using CTRL-hjkl in normal mode
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>H', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>J', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>K', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>L', { noremap = true })

-- Navigate between windows using CTRL+arrow-keys in normal mode
vim.api.nvim_set_keymap('n', '<C-Left>',  '<C-W>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Down>',  '<C-W>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Up>',    '<C-W>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-W>l', { noremap = true })

-- Resize windows using ALT-hjkl in normal mode
vim.api.nvim_set_keymap('n', '<M-h>', '2<C-W><', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-j>', '2<C-W>-', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-k>', '2<C-W>+', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-l>', '2<C-W>>', { noremap = true })

-- Use <Tab> and <S-Tab> to navigate through popup menus
vim.api.nvim_set_keymap('i', '<Tab>', 'vim.fn.pumvisible() ? \'<C-n>\' : \'<Tab>\'', { noremap = true, expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'vim.fn.pumvisible() ? \'<C-p>\' : \'<Tab>\'', { noremap = true, expr = true })

--[[ LSP Configurations ]]

local nvim_lsp = require'lspconfig'

local lsp_servers = {
    "bashls",         -- bash-language-server (npm i -g bash-language-server)
    "pyright",        -- pyright for Python (pacman or npm)
    "clangd"
}

for _, lsp_server in ipairs(lsp_servers) do
    nvim_lsp[lsp_server].setup {}
end

-- Rust configuration, rust-tools.nvim will call lspconfig itself

local rust_opts = {
    server = {}  -- options to be sent to nvim-lspconfig
}

require('rust-tools').setup(rust_opts)

--[[ Metals configuration

     Modified from https://github.com/scalameta/nvim-metals/discussions/39

     See https://scalameta.org/metals/docs/editors/overview.html for what
     is the current stable and bloody edge versions. ]]

-- vim.g.metals_server_version = '0.10.5'
vim.g.metals_server_version = '0.10.5+56-b3ce05e8-SNAPSHOT'

-- Nvim-Metals setup with a few additions such as nvim-completions
metals_config = require'metals'.bare_config
metals_config.settings = {
   showImplicitArguments = true,
   excludedPackages = {
     "akka.actor.typed.javadsl",
     "com.github.swagger.akka.javadsl"
   }
}

metals_config.on_attach = function()
  require'completion'.on_attach();
end

metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = '',
    }
  }
)

vim.api.nvim_exec([[
  augroup metals_lsp
    au!
    au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
  augroup end
]], false)

-- Setup LSP related keymaps

local opts = { noremap = true, silent = true }

-- Key mapings, see `:help vim.lsp.*.*` for documentation on these functions
vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'H', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>sh', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gds', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gws', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>K', '<Cmd>lua vim.lsp.buf.worksheet_hover()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>F', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
vim.api.nvim_set_keymap('n', 'mca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_set_keymap('n', 'ma', '<Cmd>lua require\'metals\'.open_all_diagnostics()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>d', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
vim.api.nvim_set_keymap('n', 'g[', '<Cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>', opts)
vim.api.nvim_set_keymap('n', 'g]', '<Cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>', opts)

-- Quick-fix
vim.api.nvim_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)

--[[ Setup colors ]]

-- Nvim colorizer setup (create autocmds for filetypes)
vim.o.termguicolors = true
require'colorizer'.setup()

-- Configure Tokyo Night Colorscheme
vim.g.tokyonight_style = 'night'
vim.g.tokyonight_italic_functions = 1
vim.g.tokyonight_sidebars = { 'qf', 'vista_kind', 'terminal', 'packer' }
vim.cmd('colorscheme tokyonight')
