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
    -- Paq manages itself
    "savq/paq-nvim";

    -- Colorize hexcodes and names like Blue, Yellow or Green
    "norcalli/nvim-colorizer.lua";

    -- Tokyo Night colorscheme
    "folke/tokyonight.nvim";

    -- Statusline - fork of hoob3rt/lualine.nvim
    "shadmansaleh/lualine.nvim";

    -- define keybindings; show keybindings in popup
    "folke/which-key.nvim";

    -- Install language modules for built-in treesitter
    "nvim-treesitter/nvim-treesitter";

    -- Fuzzy finder over lists
    "nvim-telescope/telescope.nvim";
    "nvim-lua/plenary.nvim";
    "nvim-lua/popup.nvim";
    "sharkdp/fd";

    -- Built-in LSP client config, completion and snippets support
    "neovim/nvim-lspconfig";
    "hrsh7th/nvim-cmp";
    "hrsh7th/cmp-nvim-lsp";
    "hrsh7th/cmp-path";
    "hrsh7th/cmp-buffer";
    "L3MON4D3/LuaSnip";
    "saadparwaiz1/cmp_luasnip";
    "rafamadriz/friendly-snippets";

    -- Extra functionality over rust analyzer
    "simrat39/rust-tools.nvim";

    -- Config built-in LSP client for Metals Scala language server
    "scalameta/nvim-metals"
}

--[[ Set some default behaviors ]]
vim.o.hidden = true  -- Allow hidden buffers
vim.o.shell = "/bin/sh"  -- Some packages need a POSIX compatible shell
vim.o.path = vim.o.path .. ".,**"  -- Allow gf and :find to use recursive sub-folders
vim.o.wildmenu = true                 -- Make tab completion in
vim.o.wildmode = "longest:full,full"  -- command mode more useful.

--[[ Set default encoding, localizations, and file formats ]]
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.spelllang = "en_us"
vim.o.fileformats = "unix,mac,dos"

-- Sit do
--[[ Set default tabstops and replace tabs with spaces ]]
vim.o.tabstop = 4       -- Display hard tab as 4 spaces
vim.o.shiftwidth = 4    -- Number of spaces used for auto-indent
vim.o.softtabstop = 4   -- Insert/delete 4 spaces when inserting <Tab>/<BS>
vim.o.expandtab = true

-- Expand tabs to spaces when inserting tabs

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
        au CmdLineLeave : set ignorecase
        au CmdLineLeave : set smartcase
    augroup end
]], false)

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

--[[ Setup folke/which-key.nvim ]]
local wk = require'which-key'
wk.setup {
    plugins = {
        spelling = {
            enabled = true,
            suggestions = 36
        }
    }
}

-- Normal mode keybindings
wk.register {
    ["<Space><Space>"] = {":nohlsearch<CR>", "Clear hlsearch"},
    ["Y"] = {"y$", "Yank to End of Line"}, -- Fix between Y, D & C inconsistency
    ["gp"] = {"`[v`]", "Reselect Previous Changed Text"},
    ["<Space>sp"] = {":set invspell<CR>", "Toggle Spelling"},
    ["<Space>ws"] = {":%s/\\s\\+$//<CR>", "Trim Trailing White Space"},
    ["<Space>t"] = {":vsplit<CR>:term fish<CR>i", "Fish Shell in vsplit"},
    ["<Space>k"] = {":dig<CR>a<C-K>", "Pick & Enter Diagraph"},
    ["<Space>l"] = {":mode<CR>", "Clear & Redraw Screen"},  -- Lost <C-L> for this below
    ["<Space>b"] = {":enew<CR>", "New Unnamed Buffer"},
    -- Telescope related keybindings
    ["<Space>f"] = {name = "+Telescope"},
    ["<Space>fb"] = {":Telescope buffers<CR>", "Buffers"},
    ["<Space>ff"] = {":Telescope find_files<CR>", "Find File"},
    ["<Space>fg"] = {":Telescope live_grep<CR>", "Live Grep"},
    ["<Space>fh"] = {":Telescope help_tags<CR>", "Help Tags"},
    ["<Space>fr"] = {":Telescope oldfiles<CR>", "Open Recent File"},
    -- Move windows around using CTRL-hjkl
    ["<C-H>"] = {"<C-W>H", "Move Window LHS"},
    ["<C-J>"] = {"<C-W>J", "Move Window BOT"},
    ["<C-K>"] = {"<C-W>K", "Move Window TOP"},
    ["<C-L>"] = {"<C-W>L", "Move Window RHS"},
    -- Navigate between windows using CTRL+arrow-keys
    ["<M-Left>"]  = {"<C-W>h", "Goto Window Left" },
    ["<M-Down>"]  = {"<C-W>j", "Goto Window Down" },
    ["<M-Up>"]    = {"<C-W>k", "Goto Window Up"   },
    ["<M-Right>"] = {"<C-W>l", "Goto Window Right"},
    -- Resize windows using ALT-hjkl for Linux
    ["<M-h>"] = {"2<C-W><", "Make Window Narrower"},
    ["<M-j>"] = {"2<C-W>-", "Make Window Shorter" },
    ["<M-k>"] = {"2<C-W>+", "Make Window Taller"  },
    ["<M-l>"] = {"2<C-W>>", "Make Window Wider"   }
}

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

-- Normal mode keybindings
wk.register {
    ["<Space>n"] = {":lua myLineNumberToggle()<CR>", "Line Number Toggle"}
}

--[[ Setup nvim-treesitter ]]
require'nvim-treesitter.configs'.setup {
    ensure_installed = 'maintained',
    highlight = {enable = true}
}

--[[ nvim-cmp for completions ]]
vim.o.completeopt = "menuone,noinsert,noselect"

local myHasWordsBefore = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require'luasnip'
local cmp = require'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),

        ['<C-E>'] = cmp.mapping.close(),

        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif myHasWordsBefore() then
                cmp.complete()
            else
                fallback()
            end
        end, {"i", "s"}),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"}),

        ['<C-D>'] = cmp.mapping.scroll_docs(-4),

        ['<C-F>'] = cmp.mapping.scroll_docs(4)
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'luasnip'},
        {name = 'nvim_lua'},
        {name = 'path'},
        {
            name = 'buffer',
            opts = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
        {name = 'treesitter'}
    }
}

--[[ LSP Configurations ]]
local nvim_lsp = require'lspconfig'

local lsp_servers = {
    "bashls", -- Bash-language-server (pacman or sudo npm i -g bash-language-server)
    "clangd", -- C and C++ - both clang and gcc
    "html",   -- HTML (npm i -g vscode-langservers-extracted)
    "pyright" -- Pyright for Python (pacman or npm)
}

for _, lsp_server in ipairs(lsp_servers) do
    nvim_lsp[lsp_server].setup {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
end

--[[ Rust configuration, rust-tools.nvim will call lspconfig itself ]]
local rust_opts = {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints ={
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = ""
        },
    },
    -- Options to be sent to nvim-lspconfig
    -- overriding defaults set by rust-tools.nvim
    server = {
        settings = {}
    }
}

require('rust-tools').setup(rust_opts)

--[[ Metals configuration ]]
vim.g.metals_server_version = '0.10.7'  -- See https://scalameta.org/metals/docs/editors/overview.html
metals_config = require'metals'.bare_config()

metals_config.settings = {showImplicitArguments = true}

vim.api.nvim_exec([[
    augroup metals_lsp
        au!
        au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
    augroup end
]], false)

--[[ LSP related keybindings ]]
wk.register {
    [","]   = {name = "+lsp"},
    [",g"]  = {name = "+goto"},
    [",s"]  = {name = "+symbol"},
    [",w"]  = {name = "+workspace folder"},
    [",m"]  = {":lua require'metals'.open_all_diagnostics()<CR>", "Metals Diagnostics"},
    [",F"]  = {":lua vim.lsp.buf.formatting()<CR>", "Formatting"},
    [",gd"] = {":lua vim.lsp.buf.definition()<CR>", "Goto Definition"},
    [",gD"] = {":lua vim.lsp.buf.declaration()<CR>", "Goto Declaration"},
    [",gi"] = {":lua vim.lsp.buf.implementation()<CR>", "Goto Implementation"},
    [",gr"] = {":lua vim.lsp.buf.references()<CR>", "Goto References"},
    [",hs"] = {":lua vim.lsp.buf.signature_help()<CR>", "Signature Help"},
    [",H"]  = {":lua vim.lsp.buf.hover()<CR>", "Hover"},
    [",K"]  = {":lua vim.lsp.buf.worksheet_hover()<CR>", "Worksheet Hover"},
    [",rn"] = {":lua vim.lsp.buf.rename()<CR>", "Rename"},
    [",sd"] = {":lua vim.lsp.buf.document_symbol()<CR>", "Document Symbol"},
    [",sw"] = {":lua vim.lsp.buf.workspace_symbol()<CR>", "Workspace Symbol"},
    [",wa"] = {":lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace Folder"},
    [",wr"] = {":lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Workspace Folder"},
    [",l"]  = {":lua vim.lsp.diagnostic.set_loclist()<CR>", "Diagnostic Set Loclist"},
    [",["]  = {":lua vim.lsp.diagnostic.goto_prev {wrap = false}<CR>", "Diagnostic Goto Prev"},
    [",]"]  = {":lua vim.lsp.diagnostic.goto_next {wrap = false}<CR>", "Diagnostic Goto Next"}
}
