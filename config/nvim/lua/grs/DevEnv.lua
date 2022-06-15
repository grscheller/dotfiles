--[[ Setup Develoment Environment & LSP Configurations

       Module: grs
       File: ~/.config/nvim/lua/grs/DevEnv.lua

  ]]

-- Check if necessary LSP related plugins are installed
local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
local ok_nvimLspInstaller, nvimLspInstaller = pcall(require, 'nvim-lsp-installer')
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok_lspconfig or not ok_nvimLspInstaller or not ok_cmp_nvim_lsp then
  if not ok_lspconfig then print('Problem loading nvim-lspconfig: ' .. lspconfig) end
  if not ok_nvimLspInstaller then print('Problem loading nvim-lsp-installer: ' .. nvimLspInstaller) end
  if not ok_cmp_nvim_lsp then print('Problem loading cmp_nvim_lsp: ' .. cmp_nvim_lsp) end
  return
end

--[[ Nvim LSP Installer Configuration ]]

nvimLspInstaller.setup {} -- Must be called before interacting with lspconfig

-- For lang server list see 1st link https://github.com/neovim/nvim-lspconfig
local lsp_servers = {
  'bashls', -- Bash-language-server (pacman or sudo npm i -g bash-language-server)
  'clangd', -- C and C++ - both clang and gcc (pacman clang package)
  'cssls', -- vscode-css-language-servers
  'gopls', -- go language server
  'hls', -- haskell-language-server
  'html', -- vscode-html-language-server
  'jsonls', -- vscode-json-language-server
  'pyright', -- Pyright for Python (pacman or npm)
  'tsserver', -- typescript-language-server (pacman)
  'yamlls' -- yaml-language-server (pacman or yarn)
}

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local km = require('grs.KeyMappings')
local on_attach = function(client, bufnr)
  km.lsp_keybindings(bufnr)
end

for _, lsp_server in ipairs(lsp_servers) do
  lspconfig[lsp_server].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

--[[ Lua Lang Configuration ]]

-- Lua auto-indent configuration
vim.api.nvim_command [[ au FileType lua setlocal shiftwidth=2 softtabstop=2 expandtab ]]

-- lua-language-server configuration for editing Neovim configs
lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = 'vim' },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false }
    }
  }
}

--[[ Python Lang Configuration ]]
vim.g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/shims/python'

--[[ Rust Lang Configuration ]]
local ok_rt, rust_tools = pcall(require, 'rust-tools')
if ok_rt then
  rust_tools.setup {
    server = {
      settings = {
        on_attach = on_attach,
        capabilities = capabilities,
        standalone = true
      }
    }
  }
else
  print('Problem loading rust-tools: ' .. rust_tools)
end

--[[ Scala Lang Configuration ]]

-- Scala Metals Configuration
-- For latest Metals Server Version see: https://scalameta.org/metals/docs
-- Todo: Align with https://github.com/scalameta/nvim-metals/discussions/39
local ok_metals, metals = pcall(require, 'metals')
if ok_metals then

  local metals_config = metals.bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    serverVersion = '0.11.6'
  }
  metals_config.on_attach = on_attach

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*.scala', '*.sbt' },
    callback = function()
      metals.initialize_or_attach(metals_config)
    end,
    desc = 'Configure Scala Metals'
  })

else
  print('Problem loading metals: ' .. metals)
end

--[[ Zig Lang Configuration ]]
vim.g.zig_fmt_autosave = 0 -- Don't auto-format on save
