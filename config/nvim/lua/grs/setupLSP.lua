--[[ LSP Configurations ]]

local ok_lsp, lsp = pcall(require, 'lspconfig')
local ok_lspInstall, lspInstall = pcall(require, 'nvim-lsp-installer')
local ok_cmpLsp, cmpLsp = pcall(require, 'cmp_nvim_lsp')
if not ok_lsp or not ok_lspInstall or not ok_cmpLsp then
    if not ok_lsp then print('Problem loading lspconfig:' .. lsp) end
    if not ok_lspInstall then print('Problem loading nvim-lsp-installer' .. lspInstall) end
    if not ok_cmpLsp then print('Problem loading cmp_nvim_lsp' .. cmpLsp) end
    return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmpLsp.update_capabilities(capabilities)

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
    lsp[lsp_server].setup {
        capabilities = capabilities
    }
end

--[[ Nvim LSP Installer ]]
lspInstall.on_server_ready(function(server)
    local opts = {
        settings = { capabilities = capabilities }
    }
    server:setup(opts)
end)

-- Python configuration
vim.g.python3_host_prog = os.getenv("HOME") .. '/.pyenv/shims/python'

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
        settings = {capabilities = capabilities}
    }
}

local ok, rust = pcall(require, 'rust-tools')
if ok then
    rust.setup(rust_opts)
else
    if not ok then print('Problem loading rust_tools' .. rust) end
end

--[[ Scala Metals configuration ]]
vim.g.metals_server_version = '0.11.1'  -- See https://scalameta.org/metals/docs/editors/overview.html

local ok, metals = pcall(require, 'metals')
if ok then
    metals_config = metals.bare_config()
    metals_config.settings = { showImplicitArguments = true }
    
    vim.cmd[[
        augroup metals_lsp
            au!
            au FileType scala,sbt lua metals.initialize_or_attach(metals_config)
        augroup end
    ]]
else
    if not ok then print('Problem loading metals' .. metals) end
end

-- Zig Configurations
vim.g.zig_fmt_autosave = 0  -- Don't auto-format on save
