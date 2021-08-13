-- Neovim configuration ~/.config/nvim/init.lua

--[[ Bootstrap Paq by cloning it into the "right place"

       git clone https://github.com/savq/paq-nvim.git \
           ~/.local/share/nvim/site/pack/paqs/opt/paq-nvim

     Paq Commands:
       :PaqInstall  <- Install all packages listed in configuration below
       :PaqUpdate   <- Update packages already on system
       :PaqClean    <- Remove packages not in configuration
       :PaqSync     <- Execute all three operations above

     Location Paq stores repos: ~/.local/share/nvim/site/pack/paqs/start/ ]]
require'paq' {
  "savq/paq-nvim";  -- Paq manages itself
  "nvim-telescope/telescope.nvim";  -- fuzzy finder over lists
  "nvim-lua/plenary.nvim";          -- required by telescope.nvim
  "nvim-lua/popup.nvim";            -- required by telescope.nvim
  "folke/which-key.nvim";  -- show possible keybinding in popup, also define keybindings
  "nvim-treesitter/nvim-treesitter";  -- Install language modules for built-in treesitter
  "neovim/nvim-lspconfig";  -- Collection of common configurations for built-in LSP client
  "hrsh7th/nvim-compe";  -- Autocompletion framework, can use built-in LSP as a source
  "L3MON4D3/LuaSnip";  -- Snippet engine, used to handle LSP snippets
  "simrat39/rust-tools.nvim";  -- extra functionality over rust analyzer
  "scalameta/nvim-metals";  -- Configure built-in LSP client for Metals Scala language server
  "norcalli/nvim-colorizer.lua";  -- Colorize hexcodes and names like Blue or Green
  "folke/tokyonight.nvim";  -- Tokyo Night colorschemes
  "shadmansaleh/lualine.nvim"  -- Used to configure statusline - fork of hoob3rt/lualine.nvim
}

--[[ Set some default behaviors ]]
vim.o.hidden = true  -- Allow hidden buffers
vim.o.shell = "/bin/sh"  -- Some packages need a POSIX compatible shell
vim.o.backspace = "indent,eol,start"  -- More powerful backspacing in insert mode
vim.o.path = vim.o.path .. ".,**"  -- Allow gf and :find to use recursive sub-folders
vim.o.wildmenu = true                 -- Make tab completion in
vim.o.wildmode = "longest:full,full"  -- command mode more useful

--[[ Set default encoding, localizations, and file formats ]]
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.spelllang = "en_us"
vim.o.fileformats = "unix,mac,dos"

--[[ Set default tabstops and replace tabs with spaces ]]
vim.o.tabstop = 4       -- Tab size 4 spaces
vim.o.shiftwidth = 4    -- Number of spaces used for auto-indent
vim.o.softtabstop = 4   -- Number spaces in tab when editing
vim.o.expandtab = true  -- Expand tabs to spaces when inserting tabs

--[[ Settings for LSP client ]]
vim.o.timeoutlen = 800  -- Milliseconds to wait for key mapped sequence to complete
vim.o.updatetime = 300  -- Set update time for CursorHold event
vim.o.signcolumn = "yes"  -- Fixes first column, reduces jitter
vim.o.shortmess = "atToOc"

--[[ Some personnal preferences ]]
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
vim.o.matchpairs = vim.o.matchpairs .. ",<:>,「:」"  -- Additional matching pairs of characters

--[[ Case insensitive search, but not in command mode ]]
vim.o.ignorecase = true
vim.o.smartcase = true
vim.api.nvim_exec([[
  augroup dynamic_smartcase
    au!
    au CmdLineEnter : set nosmartcase
    au CmdLineEnter : set noignorecase
    au CmdLineLeave : set smartcase
    au CmdLineLeave : set ignorecase
  augroup end
]], false)

--[[ Toggle between 3 line numbering states ]]
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

--[[ Setup folke/which-key.nvim ]]
local wk = require'which-key'
wk.setup {}

-- Normal mode <Leader> keybindings
vim.g.mapleader = " "
wk.register {
  ["<Leader>n"] = {"<Cmd>lua MyLineNumberToggle()<CR>", "Line Number Toggle"},
  ["<Leader><Space>"] = {"<Cmd>nohlsearch<CR>", "Clear hlsearch"},
  ["<Leader>sp"] = {"<Cmd>set invspell<CR>", "Toggle Spelling"},
  ["<Leader>ws"] = {":%s/\\s\\+$//<CR>", "Trim Trailing White Space"},
  ["<Leader>t"] = {":vsplit<CR>:term fish<CR>i", "Fish Shell in vsplit"},
  ["<Leader>k"] = {":dig<CR>a<C-K>", "Pick & Enter Diagraph"},
  ["<Leader>l"] = {":mode<CR>", "Clear & Redraw Screen"},  -- Lost <C-L> for this below
  -- File related keybindings
  ["<Leader>f"] = {name = "+file"},
  ["<Leader>ff"] = {"<Cmd>Telescope find_files<CR>", "Find File"},
  ["<Leader>fr"] = {"<Cmd>Telescope oldfiles<CR>", "Open Recent File"},
  ["<Leader>fn"] = {"<Cmd>enew<cr>", "New File"}
}

-- Other normal mode keybindings
wk.register {
  -- Fix old vi inconsistency between Y and D & C
  ["Y"] = {"y$", "Yank to End of Line"},
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
}

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

--[[ Compe for completion ]]
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
}, {mode = "i", expr = true, silent = true})

vim.api.nvim_exec([[
  augroup compe_cursorhold
    au!
    au CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
  augroup end
]], false)

--[[ Setup nvim-treesitter ]]
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = {enable = true}
}

--[[ LSP Configurations ]]
local nvim_lsp = require'lspconfig'

local lsp_servers = {
  "bashls",         -- Bash-language-server (npm i -g bash-language-server)
  "pyright",        -- Pyright for Python (pacman or npm)
  "clangd"
}

for _, lsp_server in ipairs(lsp_servers) do
    nvim_lsp[lsp_server].setup {}
end

-- Rust configuration, rust-tools.nvim will call lspconfig itself
local rust_opts = {
  server = {}  -- Options to be sent to nvim-lspconfig
}
require('rust-tools').setup(rust_opts)

-- Metals configuration
vim.g.metals_server_version = '0.10.6-M1'  -- See https://scalameta.org/metals/docs/editors/overview.html
metals_config = require'metals'.bare_config

metals_config.settings = {showImplicitArguments = true}

vim.api.nvim_exec([[
  augroup metals_lsp
    au!
    au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
  augroup end
]], false)

-- Setup LSP related keybindings
wk.register({
  [","]   = {name = "+lsp"},
  [",g"]  = {name = "+goto"},
  [",s"]  = {name = "+symbol"},
  [",w"]  = {name = "+workspace folder"},
  [",m"]  = {"<Cmd>lua require'metals'.open_all_diagnostics()<CR>", "Metals Diagnostics"},
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
  [",]"]  = {"<Cmd>lua vim.lsp.diagnostic.goto_next {wrap = false}<CR>", "Diagnostic Goto Next"}
})

--[[ Setup colorsscemes and statusline ]]
vim.o.termguicolors = true
require'colorizer'.setup()

vim.g.tokyonight_style = "night"
vim.g.tokyonight_colors = {bg = "#000000"}
vim.g.tokyonight_italic_functions = 1
vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}

require'lualine'.setup {
  options = {theme = "tokyonight"}
}

vim.cmd[[colorscheme tokyonight]]
