-- Neovim configuration file ~/.config/nvim/init.lua

--[[ Bootstrap Paq by cloning into "right place"

       git clone https://github.com/savq/paq-nvim.git \
           ~/.local/share/nvim/site/pack/paqs/opt/paq-nvim

     Paq Commands:
       :PaqInstall  <- Install all packages listed in configuration below
       :PaqUpdate   <- Update packages already on system
       :PaqClean    <- Remove packages not in configuration
       :PaqSync     <- Execute all three operations above
--]]
require'paq' {
    "savq/paq-nvim";  -- Paq manages itself
    "nvim-telescope/telescope.nvim";  -- fuzzy finder over lists
    "nvim-lua/plenary.nvim";          -- required by telescope.nvim
    "nvim-lua/popup.nvim";            -- required by telescope.nvim
    "folke/which-key.nvim";  -- show possible keybinding in popup, also can define keybindings
    "nvim-treesitter/nvim-treesitter";  -- Install language modules for treesitter
    "neovim/nvim-lspconfig";  -- Collection of common configurations for built-in LSP client
    "hrsh7th/nvim-compe";     -- Autocompletion framework for built-in LSP client
    "L3MON4D3/LuaSnip";       -- Snippet engine to handle LSP snippets
    "simrat39/rust-tools.nvim";  -- extra functionality over rust analyzer
    "scalameta/nvim-metals";  -- Metals LSP server for Scala
    "norcalli/nvim-colorizer.lua";  -- Colorize hexcodes and names like Blue
    "shadmansaleh/lualine.nvim";  -- Used to configure statusline - fork of hoob3rt/lualine.nvim
    "folke/tokyonight.nvim"  -- Install my hacked version of Tokyo Night colorschemes
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

--[[ Setup nvim-treesitter ]]
require'nvim-treesitter.configs'.setup {
    ensure_installed = 'maintained',
    highlight = {enable = true}
}

--[[ Setup folke/which-key.nvim ]]
vim.g.mapleader = ' '
local wk = require'which-key'
wk.setup {}

--[[ Compe for commpletion ]]
vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
    enabled = true;
    source = {
        path = true;
        buffer = true;
        calc = false;
        emoji = false;
        luasnip = true;
        nvim_lsp = true;
        nvim_lua = true;
        spell = true;
        tags = true;
        treesitter = true
    }
}

wk.register({
  ["<C-Space>"] = {"compe#complete()", "Compe Complete"},
  ["<CR>"] = {"compe#confirm('<CR>')", "Compe Confirm"},
  ["<C-E>"] = {"compe#close('<C-E>')", "Compe Close"},
  ["<C-U>"] = {"compe#scroll({'delta': -4})", "Compe Scroll Up"},
  ["<C-D>"] = {"compe#scroll({'delta': +4})", "Compe Scroll Down"}
}, {mode = "i", expr = true})

vim.o.signcolumn = "yes"  -- Fixed first column, reduces jitter
vim.o.updatetime = 300    -- Set update time for CursorHold

vim.api.nvim_exec([[
  augroup compe_cursorhold
    au!
    au CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
  augroup end
]], false)

-- File related keybindings
wk.register({
  ["<Leader>f"] = {name = "+file"},
  ["<Leader>ff"] = {"<Cmd>Telescope find_files<CR>", "Find File"},
  ["<Leader>fr"] = {"<Cmd>Telescope oldfiles<CR>", "Open Recent File"},
  ["<Leader>fn"] = {"<Cmd>enew<cr>", "New File"}
})

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
  ["<Leader>n"] = {"<Cmd>lua MyLineNumberToggle()<CR>", "Line Number Toggle"},
})

-- Define more keybindings
wk.register({
  ["Y"] = {"y$", "Yank to End of Line"},  -- Fix old vi inconsistency between Y and D & C
  ["<Leader><Space>"] = {"<Cmd>nohlsearch<CR>", "Clear hlsearch"},
  ["<Leader>sp"] = {"<Cmd>set invspell<CR>", "Toggle Spelling"},
  ["<Leader>ws"] = {":%s/\\s\\+$//<CR>", "Trim Trailing White Space"},
  ["<Leader>t"] = {":vsplit<CR>:term fish<CR>i", "Fish Shell in vsplit"},
  ["<Leader>k"] = {":dig<CR>a<C-K>", "Pick & Enter Diagraph"},
  ["<Leader>l"] = {":mode<CR>", "Clear & Redraw Screen"},  -- Lost <C-L> below for this
  -- Move windows around using CTRL-hjkl in normal mode
  ["<C-H>"] = {"<C-W>H", "Move Window LHS"},
  ["<C-J>"] = {"<C-W>J", "Move Window BOT"},
  ["<C-K>"] = {"<C-W>K", "Move Window TOP"},
  ["<C-L>"] = {"<C-W>L", "Move Window RHS"},
  -- Navigate between windows using CTRL+arrow-keys in normal mode
  ["<C-Left>"]  = {"<C-W>h", "Goto Window Left" },
  ["<C-Down>"]  = {"<C-W>j", "Goto Window Down" },
  ["<C-Up>"]    = {"<C-W>k", "Goto Window Up"   },
  ["<C-Right>"] = {"<C-W>l", "Goto Window Right"},
  -- Resize windows using ALT-hjkl in normal mode
  ["<M-h>"] = {"2<C-W><", "Make Window Narrower"},
  ["<M-j>"] = {"2<C-W>-", "Make Window Shorter" },
  ["<M-k>"] = {"2<C-W>+", "Make Window Taller"  },
  ["<M-l>"] = {"2<C-W>>", "Make Window Wider"   }
})

-- Use <Tab> and <S-Tab> to navigate through popup menus
wk.register({
  ["<Tab>"]   = {"vim.fn.pumvisible() ? '<C-N>' : '<Tab>'"},
  ["<S-Tab>"] = {"vim.fn.pumvisible() ? '<C-P>' : '<Tab>'"}
}, {mode = "i", expr = true})

-- Automatically reselect visual area when visual shifting
wk.register({
  ["<"] = {"<gv", "Shift left and reselect" },
  [">"] = {">gv", "Shift right and reselect"}
}, {mode = "x", expr = true})

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

vim.g.metals_server_version = '0.10.6-M1'

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

wk.register({
  [",m"] = {"<Cmd>lua require'metals'.open_all_diagnostics()<CR>", "Metals Diagnostics"},
})

-- Setup LSP related keymaps

wk.register({
  [","]   = {name = "+lsp"},
  [",g"]  = {name = "+goto"},
  [",s"]  = {name = "+symbol"},
  [",w"]  = {name = "+workspace folder"},
  [",F"]  = {"<Cmd>lua vim.lsp.buf.formatting()<CR>", "Formatting"},
  [",gd"] = {"<Cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition"},
  [",gD"] = {"<Cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration"},
  [",gi"] = {"<Cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation"},
  [",gr"] = {"<Cmd>lua vim.lsp.buf.references()<CR>", "Goto References"},
  [",hs"] = {"<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help"},
  [",H"]  = {"<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover"},
  [",K"]  = {"<Cmd>lua vim.lsp.buf.worksheet_hover()<CR>", "Worksheet Hover"},
  [",rn"] = {"<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename"},
  [",sd"] = {"<Cmd>lua vim.lsp.buf.document_symbol()<CR>", "Document Symbol"},
  [",sw"] = {"<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "Workspace Symbol"},
  [",wa"] = {"<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace Folder"},
  [",wr"] = {"<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Workspace Folder"},
  [",l"]  = {"<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "Diagnostic Set Loclist"},
  [",["]  = {"<Cmd>lua vim.lsp.diagnostic.goto_prev {wrap = false}<CR>", "Diagnostic Goto Prev"},
  [",]"]  = {"<Cmd>lua vim.lsp.diagnostic.goto_next {wrap = false}<CR>", "Diagnostic Goto Next"},
})

--[[ Setup colors ]]
vim.o.termguicolors = true
require'colorizer'.setup()

vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = 1
vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
vim.g.tokyonight_colors = {bg = "#000000"}
vim.cmd("colorscheme tokyonight")

--[[ Setup Lualine ]]
require'lualine'.setup {
    options = {theme = "tokyonight"}
}
