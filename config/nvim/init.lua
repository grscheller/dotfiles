--[[ Neovim configuration file

       ~/.config/nvim/init.lua

     Written by Geoffrey Scheller
     See https://github.com/grscheller/dotfiles ]]

--[[ Preliminaries ]]

-- Set default encoding, localizations, and file formats
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.spelllang = "en_us"
vim.o.fileformats = "unix,mac,dos"

vim.o.modeline = false -- Remove Vim vulnerability
vim.o.shell = "/bin/sh"  -- Some packages need a POSIX compatible shell

vim.o.backspace = "indent,eol,start"  -- More powerful backspacing in insert mode

-- Make tab completion in command mode more useful
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"

vim.o.path = vim.o.path .. ".,**"  -- Allow gf and :find to use recursive sub-folders
vim.o.hidden = true                -- and do not save when switching buffers.

--[[ Personnal preferences ]]

-- Configure features and behaviors
vim.o.history = 10000    -- Number lines of command history to keep
vim.o.mouse = "a"        -- Enable mouse for all modes
vim.o.scrolloff = 2      -- Keep cursor away from top/bottom of window
vim.o.wrap = false       -- Don't wrap lines
vim.o.sidescroll = 1     -- Horizontally scroll nicely
vim.o.sidescrolloff = 5  -- Keep cursor away from side of window
vim.o.splitbelow = true  -- Horizontally split below
vim.o.splitright = true  -- Vertically split to right
vim.o.hlsearch = true        -- Highlight / search results after <CR>
vim.o.incsearch = true       -- Highlight / search matches as you type
vim.o.ignorecase = true      -- Case insensitive search,
vim.o.smartcase = true       -- ... unless query has caps
vim.o.showcmd = true         -- Show partial normal mode commands in lower right corner
vim.o.nrformats = "bin,hex,octal,alpha"  -- bases and single letters
                                         -- used for <C-A> & <C-X>

-- Set default tabstops and replace tabs with spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

-- Setup key mappings, define <Leader> explicitly as a space
vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', { noremap = true })
vim.g.mapleader = ' '

-- Clear search highlighting
vim.api.nvim_set_keymap('n', '<Leader><Space>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Trim all trailing whitespace
vim.api.nvim_set_keymap('n', '<Leader>w', ':%s/\\s\\+$//<CR>', { noremap = true })

-- Toggle spell checking
vim.api.nvim_set_keymap('n', '<Leader>sp', ':set invspell<CR>', { noremap = true, silent = true })

-- Fix an old vi inconsistancy between Y and D & C
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Open a vertical terminal running fish shell
vim.api.nvim_set_keymap('n', '<Leader>f', ':vsplit<CR>:term fish<CR>i', { noremap = true })

-- Reduce keystrokes and memmory load from :dig to entering digraph
   -- position cursor on char before you want to insert digraph
   -- type <Leader>k
   -- use q to exit digraph table
   -- type digraph
vim.api.nvim_set_keymap('n', '<Leader>k', ':dig<CR>a<C-K>', { noremap = true })

-- Clear & redraw screen, lost <C-L> for this below
vim.api.nvim_set_keymap('n', '<Leader>l', ':mode<CR>', { noremap = true, silent = true })

-- Move windows around using CTRL-hjkl in normal mode
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>H', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>J', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>K', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>L', { noremap = true })

-- Resize windows using ALT-hjkl in normal mode
vim.api.nvim_set_keymap('n', '<M-h>', '2<C-W><', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-j>', '2<C-W>-', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-k>', '2<C-W>+', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-l>', '2<C-W>>', { noremap = true })

-- Navigate between windows using CTRL+arrow-keys in normal mode
vim.api.nvim_set_keymap('n', '<C-Left>',  '<C-W>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Down>',  '<C-W>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Up>',    '<C-W>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-W>l', { noremap = true })

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

vim.api.nvim_set_keymap('n', '<Leader>n', '<Cmd>lua MyLineNumberToggle()<CR>', { noremap = true, silent = true })

-- Use <Tab> and <S-Tab> to navigate through popup menus
vim.api.nvim_set_keymap('i', '<Tab>', 'vim.fn.pumvisible() ? \'<C-n>\' : \'<Tab>\'', { noremap = true, expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'vim.fn.pumvisible() ? \'<C-p>\' : \'<Tab>\'', { noremap = true, expr = true })

-- For a better completion experience.
vim.o.completeopt = "menuone,noinsert,noselect"

vim.cmd([[
  set shortmess-=F
  set shortmess+=c
]])

--[[ Paq package manager configuration

     To bootstrap, clone into an initial "right place":

       git clone https://github.com/savq/paq-nvim.git \
           ~/.local/share/nvim/site/pack/paqs/opt/paq-nvim

     and then from command mode run

       :PaqInstall

     Paq Commands:
       :PaqInstall  <- Install all packages listed in configuration below
       :PaqUpdate   <- Update packages already on system
       :PaqClean    <- Remove packages not in configuration
       :PaqSync     <- Execute all three operations above ]]

local paq = require('paq')

paq {
    "savq/paq-nvim";          -- Let Paq manage itself.

    "neovim/nvim-lspconfig";  -- Collection of common configurations for built-in LSP client

    "scalameta/nvim-metals";     -- Install packages to
    "nvim-lua/completion-nvim";  -- manage Scala with Metals.

    "simrat39/rust-tools.nvim";  -- configuration & extra tools for rust-analyzer

    "dag/vim-fish";        -- Provide Fish syntax highlighting support.

    "tpope/vim-surround";  -- Surrond text objects with matching (). {}. '', etc.
                           --     ds delete surronding - ds"
                           --     cs change surronding - cs[{
                           --     ys surround text object or motion - ysiw)
                           --   Works on various markup tags and in visual line mode.

    "tpope/vim-repeat";        -- Repeat last action via "." for supported packages.

    "junegunn/vim-peekaboo";   -- Shows what is in registers, extends " and @
                               -- in normal mode and <C-R> in insert mode.

    "vim-airline/vim-airline";      -- Used to configure statusline.

    "norcalli/nvim-colorizer.lua";  -- Colorize hexcodes and names like Blue.

    "grscheller/tokyonight.nvim";   -- Install my hacked version of Tokyo Night colorschemes.
}

--[[ Nvim-lspconf Configurations ]]

local lspconfig = require'lspconfig'

-- Use pyright for Python
lspconfig.pyright.setup{}

--[[ Rust configuration 

     Config from: https://github.com/simrat39/rust-tools.nvim ]]

local rust_opts = {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        runnables = {
            use_telescope = false
        },
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = '<- ',
            other_hints_prefix = '=> ',
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            rigt_align_padding = 7
        },
        hover_actions = {
            {"╭", "FloatBorder"}, {"─", "FloatBorder"},
            {"╮", "FloatBorder"}, {"│", "FloatBorder"},
            {"╯", "FloatBorder"}, {"─", "FloatBorder"},
            {"╰", "FloatBorder"}, {"│", "FloatBorder"}
        },
        auto_focus = false
    },
    server = {} -- rust-analyzer options
}

require('rust-tools').setup(rust_opts)

--[[ Metals configuration

     Modified from https://github.com/scalameta/nvim-metals/discussions/39

     See https://scalameta.org/metals/docs/editors/overview.html for what
     is the current bloody edge version. ]]

-- Comment out for latest stable server
vim.g.metals_server_version = '0.10.4+145-14c56ef6-SNAPSHOT'

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

-- No Lua interface for autogroups yet
vim.api.nvim_exec([[
  augroup lsp
    au!
    au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
  augroup end
]], false)

-- Nvim-LSP Mappings
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gds', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gws', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>K', '<Cmd>lua vim.lsp.buf.worksheet_hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>F', '<Cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'mca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ma', '<Cmd>lua require\'metals\'.open_all_diagnostics()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>d', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>[', '<Cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>]', '<Cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>', { noremap = true, silent = true })

--[[ Setup colors ]]

-- Nvim colorizer setup (create autocmds for filetypes)
vim.o.termguicolors = true
require'colorizer'.setup()

-- Configure Tokyo Night Colorscheme
vim.g.tokyonight_style = 'night'
vim.g.tokyonight_italic_functions = 1
vim.g.tokyonight_sidebars = { 'qf', 'vista_kind', 'terminal', 'packer' }
vim.cmd('colorscheme tokyonight')
