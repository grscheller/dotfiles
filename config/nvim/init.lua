-- Neovim configuration ~/.config/nvim/init.lua

--[[ Packer - see ~/.config/nvim/lua/plugins.lua for details ]]
require'plugins'

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
vim.o.showmode = false  -- Redundant with Lualine
vim.o.showcmd = false   -- Partially redundant with Lualine

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

--[[ Settingup keybindings with folke/which-key.nvim ]]
local wk = require'which-key'

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
        t = {
            name = "+Fish Shell in Terminal",
            s = {":split<CR>:term fish<CR>i", "Fish Shell in split"},
            v = {":vsplit<CR>:term fish<CR>i", "Fish Shell in vsplit"}
        },
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
        ['<C-P>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
        ['<C-N>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
        ['<C-D>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-F>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-E>'] = cmp.mapping(cmp.mapping.close(), {'i', 'c'}),
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
            end, {"i", "s"})
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'luasnip'},
        {name = 'buffer'},
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
    sources = cmp.config.sources(
        {{name = 'path'}},
        {{name = 'cmdline'}},
        {{name = 'nvim-lua'}})
})

--[[ LSP Configurations ]]
local nvim_lsp = require'lspconfig'
local cmp_lsp = require'cmp_nvim_lsp'

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_capabilities = cmp_lsp.update_capabilities(lsp_capabilities)

local lsp_servers = {
    -- For list of language servers, follow first
    -- link of https://github.com/neovim/nvim-lspconfig
    "bashls",  -- Bash-language-server (pacman or sudo npm i -g bash-language-server)
    "clangd",  -- C and C++ - both clang and gcc
    "cssls",   -- vscode-css-language-servers
    "gopls",   -- go language server
    "html",    -- vscode-html-language-servers
    "jsonls",  -- vscode-json-language-servers
    "pyright"  -- Pyright for Python (pacman or npm)
}

for _, lsp_server in ipairs(lsp_servers) do
    nvim_lsp[lsp_server].setup {
        capabilities = lsp_capabilities
    }
end

-- Rust configuration, rust-tools.nvim will call lspconfig itself
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

-- Metals configuration
vim.g.metals_server_version = '0.11.0'  -- See https://scalameta.org/metals/docs/editors/overview.html
metals_config = require'metals'.bare_config()

metals_config.settings = {showImplicitArguments = true}

vim.api.nvim_exec([[
    augroup metals_lsp
        au!
        au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
    augroup end
]], false)

-- Zig Configurations
vim.g.zig_fmt_autosave = 0  -- Don't auto-format on save

--[[ Nvim LSP Installer ]]
local lsp_installer = require'nvim-lsp-installer'

lsp_installer.on_server_ready(function(server)
    local opts = {
        settings = {capabilities = lsp_capabilities}
    }
    server:setup(opts)
end)

--[[ LSP related keybindings ]]
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
