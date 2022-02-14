--[[ LSP Configurations ]]

local nvim_lsp = require'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)

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
        capabilities = capabilities
    }
end

--[[ Nvim LSP Installer ]]
require'nvim-lsp-installer'.on_server_ready(function(server)
    local opts = {
        settings = {capabilities = capabilities}
    }
    server:setup(opts)
end)

-- Python configuration
vim.g.python3_host_prog = '~/.pyenv/shims/python'

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

require('rust-tools').setup(rust_opts)

-- Scala Metals configuration
vim.g.metals_server_version = '0.11.1'  -- See https://scalameta.org/metals/docs/editors/overview.html
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
