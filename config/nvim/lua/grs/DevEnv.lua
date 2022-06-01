--[[ Setup Develoment Environment & LSP Configurations

       Module: grs
       File: ~/.config/nvim/lua/grs/DevEnv.lua

  ]]

-- Punt LSP config if Which-Key not available
local whichkey = require('grs.WhichKey')
if not whichkey then
  print('Which-Key unavailable, punting on LSP config. ')
  return
end

-- Check if necessary LSP related plugins are installed
local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
local ok_nvimLspInstaller, nvimLspInstaller = pcall(require, 'nvim-lsp-installer')
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok_lspconfig or not ok_nvimLspInstaller or not ok_cmp_nvim_lsp then
  if not ok_lspconfig then print('Problem loading nvim-lspconfig. ') end
  if not ok_nvimLspInstaller then print('Problem loading nvim-lsp-installer. ') end
  if not ok_cmp_nvim_lsp then print('Problem loading cmp_nvim_lsp. ') end
  return
end

--[[ A minimal config for nvim LSP Installer ]]
nvimLspInstaller.on_server_ready(function(server)
  local opts = { }
  server:setup(opts)
end)

local lsp_servers = {
  -- For list of language servers, follow first
  -- link of https://github.com/neovim/nvim-lspconfig
  'bashls',    -- Bash-language-server (pacman or sudo npm i -g bash-language-server)
  'clangd',    -- C and C++ - both clang and gcc (pacman clang package)
  'cssls',     -- vscode-css-language-servers
  'gopls',     -- go language server
  'hls',       -- haskell-language-server
  'html',      -- vscode-html-language-server
  'jsonls',    -- vscode-json-language-server
  'pyright',   -- Pyright for Python (pacman or npm)
  'tsserver',  -- typescript-language-server (pacman)
  'yamlls'     -- yaml-language-server (pacman or yarn)
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local on_attach = function(client, bufnr)
  whichkey.lsp_on_attach(client, bufnr)
end

for _, lsp_server in ipairs(lsp_servers) do
  lspconfig[lsp_server].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

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

--[[ Lua lang configuration ]]
vim.cmd [[
  augroup lua_config
    au!
    au FileType lua setlocal shiftwidth=2 softtabstop=2 expandtab
  augroup end ]]

--[[ Python lang configuration ]]
vim.g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/shims/python'

--[[ Rust lang configuration ]]
local rust_opts = {
  -- Options sent to nvim-lspconfig overriding defaults set by rust-tools.nvim
  server = {
    settings = {
      on_attach = on_attach,
      capabilities = capabilities,
      standalone = true
    }
  }
}

local ok_rt, rust_tools = pcall(require, 'rust-tools')
if ok_rt then
  rust_tools.setup(rust_opts)
else
  print('Problem loading rust-tools.')
end

--[[ Scala lang configuration ]]
-- For latest Metals Server Version see: https://scalameta.org/metals/docs
-- Todo: Align with https://github.com/scalameta/nvim-metals/discussions/39

local ok_metals, l_metals = pcall(require, 'metals')
if ok_metals then
  G_METALS = l_metals                       -- Global for the augroup
  G_METALS_CONFIG = G_METALS.bare_config()  -- defined below.
  G_METALS_CONFIG.settings = {
    showImplicitArguments = true,
    serverVersion = '0.11.5'
  }
  G_METALS_CONFIG.on_attach = whichkey.lsp_on_attach

  vim.cmd [[
    augroup scala_metals_lsp
      au!
      au FileType scala,sbt setlocal shiftwidth=2 softtabstop=2 expandtab
      au FileType scala,sbt lua G_METALS.initialize_or_attach(G_METALS_CONFIG)
    augroup end
  ]]
else
  print('Problem loading metals: ' .. l_metals)
end

--[[ Zig lang Configuration ]]
vim.g.zig_fmt_autosave = 0  -- Don't auto-format on save
