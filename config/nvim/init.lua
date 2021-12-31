-- Neovim configuration ~/.config/nvim/init.lua

--[[ Bootstrap Paq by cloning it to standard Neovim package location
       git clone https://github.com/savq/paq-nvim.git \
         ~/.local/share/nvim/site/pack/paqs/start/paq-nvim  ]]
require'paq' {
    -- Paq manages itself
    "savq/paq-nvim";
    -- Colorize hexcodes and names like Blue, Yellow or Green
    "norcalli/nvim-colorizer.lua";
    -- Tokyo Night colorscheme
    "folke/tokyonight.nvim";
    -- Statusline - fork of hoob3rt/lualine.nvim
    "nvim-lualine/lualine.nvim";
    -- define keybindings; show keybindings in popup
    "folke/which-key.nvim";
    -- Install language modules for built-in treesitter
    "nvim-treesitter/nvim-treesitter";
    -- Fuzzy finder over lists
    "nvim-telescope/telescope.nvim";
    "nvim-lua/plenary.nvim";
    "nvim-lua/popup.nvim";
    "sharkdp/fd";
    -- Configs for Neovim's built-in LSP client
    "neovim/nvim-lspconfig";  -- Provided by core neovim team
    "simrat39/rust-tools.nvim";  -- Extra functionality over rust analyzer
    "scalameta/nvim-metals";  -- Config for Scala Metals
    -- Completion support via nvim-cmp
    "hrsh7th/cmp-nvim-lsp";
    "hrsh7th/cmp-buffer";
    "hrsh7th/cmp-path";
    "hrsh7th/cmp-cmdline";
    "hrsh7th/nvim-cmp";
    "hrsh7th/cmp-nvim-lua";
    -- Snippets support
    "L3MON4D3/LuaSnip";
    "saadparwaiz1/cmp_luasnip";
    "rafamadriz/friendly-snippets";
}

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

--[[ Settings for LSP client ]]
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

--[[ Give visual feedback for yanked text ]]
vim.api.nvim_exec([[
    augroup highlight_yank
        au!
        au TextYankPost * silent! lua vim.highlight.on_yank{timeout=600, on_visual=false}
    augroup end
]], false)

--[[ Setup colorssceme ]]
vim.o.termguicolors = true
require'colorizer'.setup()

vim.g.tokyonight_style = "night"
vim.g.tokyonight_colors = {bg = "#000000"}
vim.g.tokyonight_italic_functions = 1
vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}

vim.cmd[[colorscheme tokyonight]]

--[[ Setup statusline ]]
vim.o.showcmd = false
vim.o.showmode = false
require'lualine'.setup {
    options = {
        icons_enabled = true,
        theme = 'moonfly',
        component_separators = {left = '', right = ''},
        section_separators = {left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', {'diagnostics', sources = {'nvim_diagnostic'}}},
        lualine_c = {'filename'},
        lualine_x = {'filetype', 'encoding'},
        lualine_y = {'location'},
        lualine_z = {'progress'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {'progress'},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
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

--[[ Setup folke/which-key.nvim ]]
local wk = require'which-key'  -- used to define all keybindings
wk.setup {                     -- except those for nvim-cmp
    plugins = {
        spelling = {
            enabled = true,
            suggestions = 36
        }
    }
}

--[[ Normal mode keybindings ]]
wk.register {
    -- Navigate between windows using CTRL+arrow-keys
    ["<C-h>"] = {"<C-W>h", "Goto Window Left" },
    ["<C-j>"] = {"<C-W>j", "Goto Window Down" },
    ["<C-k>"] = {"<C-W>k", "Goto Window Up"   },
    ["<C-l>"] = {"<C-W>l", "Goto Window Right"},
    -- Move windows around using CTRL-hjkl
    ["<M-Left>"]  = {"<C-W>H", "Move Window LHS"},
    ["<M-Down>"]  = {"<C-W>J", "Move Window BOT"},
    ["<M-Up>"]    = {"<C-W>K", "Move Window TOP"},
    ["<M-Right>"] = {"<C-W>L", "Move Window RHS"},
    -- Resize windows using ALT-hjkl for Linux
    ["<M-h>"] = {"2<C-W><", "Make Window Narrower"},
    ["<M-j>"] = {"2<C-W>-", "Make Window Shorter" },
    ["<M-k>"] = {"2<C-W>+", "Make Window Taller"  },
    ["<M-l>"] = {"2<C-W>>", "Make Window Wider"   }
}

wk.register {
    ["<Space>"] = {
        ["<Space>"] = {":nohlsearch<CR>", "Clear hlsearch"},
        b = {":enew<CR>", "New Unnamed Buffer"},
        h = {":TSBufToggle highlight<CR>", "Treesitter Highlight Toggle"},
        k = {":dig<CR>a<C-K>", "Pick & Enter Diagraph"},
        l = {":mode<CR>", "Clear & Redraw Screen"},  -- Lost <C-L> for this above
        n = {":lua myLineNumberToggle()<CR>", "Line Number Toggle"},
        s = {
            name = "+Spelling",
            t = {":set invspell<CR>", "Toggle Spelling"}
        },
        t = {":vsplit<CR>:term fish<CR>i", "Fish Shell in vsplit"},
        w = {
            name = "+Whitespace",
            t = {":%s/\\s\\+$//<CR>", "Trim Trailing Whitespace"}
        }
    },
    -- Telescope related keybindings
    t = {
	    name = "+Telescope",
        b = {":lua require'telescope.builtin'.buffers()<CR>", "Buffers"},
        f = {
            name = "Telescope Find",
            f = {":lua require'telescope.builtin'.find_files()<CR>", "Find File"},
            z = {":lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>", "Fuzzy Find Current Buffer"},
        },
        g = {
	        name = "+Telescope Grep",
            l = {":lua require'telescope.builtin'.live_grep()<CR>", "Live Grep"},
            s = {":lua require'telescope.builtin'.grep_string()<CR>", "Grep String"}
	    },
        r = {":lua require'telescope.builtin'.oldfiles()<CR>", "Open Recent File"},
        t = {
	        name = "+Telescope Tags",
            b = {":lua require'telescope.builtin'.tags{only_current_buffer() = true}<CR>", "Tags in Current Buffer"},
            h = {":lua require'telescope.builtin'.help_tags()<CR>", "Help Tags"},
            t = {":lua require'telescope.builtin'.tags()<CR>", "Tags"}
        }
    }
}

--[[ Setup nvim-treesitter ]]
require'nvim-treesitter.configs'.setup {
    ensure_installed = 'maintained',
    highlight = {enable = true}
}

--[[ Completions via hrsh7th/nvim-cmp ]]
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
        ['<C-Y>'] = cmp.config.disable,
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-E>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close() },
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true },
        ['<Tab>'] = cmp.mapping(
            function(fallback)
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
        ['<S-Tab>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, {"i", "s"}),
        ['<C-D>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-F>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'})
    },

--  Based on n3wborn/nvim config files.
    sources = {
        {name = 'nvim_lsp'},
        {name = 'luasnip'},
        {name = 'buffer',
         options = {
             get_bufnrs = function()
                 return vim.api.nvim_list_bufs()
             end
         }},
        {name = 'path'},
        {name = 'nvim_lua'}
    }
}

cmp.setup.cmdline('/', {
    sources = {
        {name = 'buffer'}
    }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources {
        {name = 'path'},
        {name = 'cmdline'},
        {name = 'nvim-lua'}      -- Not sure about this one?
    }
})

--[[ LSP Configurations ]]
local nvim_lsp = require'lspconfig'
local cmp_lsp = require'cmp_nvim_lsp'

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_capabilities = cmp_lsp.update_capabilities(lsp_capabilities)

local lsp_servers = {
    -- For list of language servers, follow first
    -- link of https://github.com/neovim/nvim-lspconfig
    "bashls", -- Bash-language-server (pacman or sudo npm i -g bash-language-server)
    "clangd", -- C and C++ - both clang and gcc
    "cssls",  -- vscode-css-language-servers
    "html",   -- vscode-html-language-servers
    "jsonls", -- vscode-json-language-servers
    "pyright" -- Pyright for Python (pacman or npm)
}

for _, lsp_server in ipairs(lsp_servers) do
    nvim_lsp[lsp_server].setup {
        capabilities = lsp_capabilities
    }
end

--[[ Rust configuration, rust-tools.nvim will call lspconfig itself ]]
local rust_opts = {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = ""
        },
    },
    -- Options to be sent to nvim-lspconfig
    -- overriding defaults set by rust-tools.nvim
    server = {
        settings = {capabilities = lsp_capabilities}
    }
}

require('rust-tools').setup(rust_opts)

--[[ Metals configuration ]]
vim.g.metals_server_version = '0.10.9'  -- See https://scalameta.org/metals/docs/editors/overview.html
metals_config = require'metals'.bare_config()

metals_config.settings = {showImplicitArguments = true}

vim.api.nvim_exec([[
    augroup metals_lsp
        au!
        au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
    augroup end
]], false)

--[[ LSP related keybindings - not sure what half of them really do ]]
wk.register {
    [","] = {
        name = "+lsp",
        F = {":lua vim.lsp.buf.formatting()<CR>", "Formatting"},
        g = {
            name = "+goto",
            d = {":lua vim.lsp.buf.definition()<CR>", "Goto Definition"},
            D = {":lua vim.lsp.buf.declaration()<CR>", "Goto Declaration"},
            i = {":lua vim.lsp.buf.implementation()<CR>", "Goto Implementation"},
            r = {":lua vim.lsp.buf.references()<CR>", "Goto References"}
        },
        h = {":lua vim.lsp.buf.signature_help()<CR>", "Signature Help"},
        H = {":lua vim.lsp.buf.hover()<CR>", "Hover"},
        K = {":lua vim.lsp.buf.worksheet_hover()<CR>", "Worksheet Hover"},
        l = {":lua vim.lsp.diagnostic.set_loclist()<CR>", "Diagnostic Set Loclist"},
        m = {":lua require'metals'.open_all_diagnostics()<CR>", "Metals Diagnostics"},
        r = {":lua vim.lsp.buf.rename()<CR>", "Rename"},
        s = {
            name = "+symbol",
            d = {":lua vim.lsp.buf.document_symbol()<CR>", "Document Symbol"},
            w = {":lua vim.lsp.buf.workspace_symbol()<CR>", "Workspace Symbol"}
        },
        w = {
            name = "+workspace folder",
            a = {":lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace Folder"},
            r = {":lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Workspace Folder"}
        },
        ["["] = {":lua vim.lsp.diagnostic.goto_prev({wrap = false})<CR>", "Diagnostic Goto Prev"},
        ["]"] = {":lua vim.lsp.diagnostic.goto_next({wrap = false})<CR>", "Diagnostic Goto Next"}
    }
}
