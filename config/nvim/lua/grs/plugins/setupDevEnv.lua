--[[ Setup Develoment Environment - LSP Configurations ]]

local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
local ok_nvimLspInstaller, nvimLspInstaller = pcall(require, 'nvim-lsp-installer')
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok_lspconfig or not ok_nvimLspInstaller or not ok_cmp_nvim_lsp then
    if not ok_lspconfig then print('Problem loading nvim-lspconfig.') end
    if not ok_nvimLspInstaller then print('Problem loading nvim-lsp-installer.') end
    if not ok_cmp_nvim_lsp then print('Problem loading cmp_nvim_lsp.') end
    return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

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
    lspconfig[lsp_server].setup {
        capabilities = capabilities
    }
end

--[[ Nvim LSP Installer ]]
nvimLspInstaller.on_server_ready(function(server)
    local opts = {
        settings = {
            capabilities = capabilities
        }
    }
    server:setup(opts)
end)

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
        settings = { capabilities = capabilities }
    }
}

local ok, rust = pcall(require, 'rust-tools')
if ok then
    rust.setup(rust_opts)
else
    print('Problem loading rust_tools.')
end

--[[ Scala Metals configuration ]]
vim.g.metals_server_version = '0.11.1'  -- See https://scalameta.org/metals/docs/editors/overview.html

local ok, metals = pcall(require, 'metals')
if ok then
    metals_config = metals.bare_config()
    metals_config.settings = {
        showImplicitArguments = true
    }
    
    vim.cmd[[
      augroup metals_lsp
          au!
          au FileType scala,sbt lua metals.initialize_or_attach(metals_config)
      augroup end
    ]]
else
    print('Problem loading metals.')
end

--[[ Python configuration ]]
vim.g.python3_host_prog = os.getenv("HOME") .. '/.pyenv/shims/python'

--[[ Zig Configuration ]]
vim.g.zig_fmt_autosave = 0  -- Don't auto-format on save

-- Eetup keybindings - using '\' until I choose better names
ok, wk = pcall(require, 'which-key')
if not ok then return end

wk.register {
    ['\\'] = {
        name = '+lsp',
        F = {':lua vim.lsp.buf.formatting()<CR>', 'Formatting'},
        g = {
            name = '+goto',
            d = {':lua vim.lsp.buf.definition()<CR>', 'Goto Definition'},
            D = {':lua vim.lsp.buf.declaration()<CR>', 'Goto Declaration'},
            i = {':lua vim.lsp.buf.implementation()<CR>', 'Goto Implementation'},
            r = {':lua vim.lsp.buf.references()<CR>', 'Goto References'}
        },
        h = {':lua vim.lsp.buf.signature_help()<CR>', 'Signature Help'},
        H = {':lua vim.lsp.buf.hover()<CR>', 'Hover'},
        K = {':lua vim.lsp.buf.worksheet_hover()<CR>', 'Worksheet Hover'},
        l = {':lua vim.lsp.diagnostic.set_loclist()<CR>', 'Diagnostic Set Loclist'},
        m = {":lua require('metals').open_all_diagnostics()<CR>", 'Metals Diagnostics'},
        r = {':lua vim.lsp.buf.rename()<CR>', 'Rename'},
        s = {
            name = '+symbol',
            d = {':lua vim.lsp.buf.document_symbol()<CR>', 'Document Symbol'},
            w = {':lua vim.lsp.buf.workspace_symbol()<CR>', 'Workspace Symbol'}
        },
        w = {
            name = '+workspace folder',
            a = {':lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add Workspace Folder'},
            r = {':lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove Workspace Folder'}
        },
        ['['] = {':lua vim.lsp.diagnostic.goto_prev({wrap = false})<CR>', 'Diagnostic Goto Prev'},
        [']'] = {':lua vim.lsp.diagnostic.goto_next({wrap = false})<CR>', 'Diagnostic Goto Next'}
    }
}
