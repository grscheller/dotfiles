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
  local opts = {}
  server:setup(opts)
end)

local lsp_servers = {
  -- For list of language servers, follow first
  -- link of https://github.com/neovim/nvim-lspconfig
  'bashls',  -- Bash-language-server (pacman or sudo npm i -g bash-language-server)
  'clangd',  -- C and C++ - both clang and gcc
  'cssls',   -- vscode-css-language-servers
  'gopls',   -- go language server
  'html',    -- vscode-html-language-servers
  'jsonls',  -- vscode-json-language-servers
  'pyright'  -- Pyright for Python (pacman or npm)
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local on_attach = function(client, bufnr)
  whichkey.lsp_on_attach(client, bufnr)
end

for _, lsp_server in ipairs(lsp_servers) do
  lspconfig[lsp_server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes =150  -- Default for Neovim 0.7+
    }
  }
end

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

local ok, rust_tools = pcall(require, 'rust-tools')
if ok then
  rust_tools.setup(rust_opts)
else
  print('Problem loading rust-tools.')
end

--[[ Scala lang configuration ]]
-- Todo: fix keybindings
-- Todo: Align with https://github.com/scalameta/nvim-metals/discussions/39
vim.cmd [[
  augroup scala_config
    au!
    au FileType scala,sbt setlocal shiftwidth=2 softtabstop=2 expandtab
  augroup end ]]

local ok, metals_local = pcall(require, 'metals')
if ok then
  g_metals = metals_local                   -- Global for the augroup
  g_metals_config = g_metals.bare_config()  -- defined below.
  g_metals_config.settings = {
    showImplicitArguments = true
  }
  
  vim.cmd [[
    augroup scala_metals_lsp
      au!
      au FileType scala,sbt lua g_metals.initialize_or_attach(g_metals_config)
    augroup end ]]
else
  print('Problem loading metals.')
end

--[[ Zig lang Configuration ]]
vim.g.zig_fmt_autosave = 0  -- Don't auto-format on save
