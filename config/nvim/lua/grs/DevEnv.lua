--[[ Setup Develoment Environment - LSP Configurations ]]

-- Punt LSP config if Which-Key not installed
local ok, wk = pcall(require, 'which-key')
if not ok then
  print('No Which-Key, punting on LSP config: ')
  return
end

-- Check if necessary LSP related plugins are installed
local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
local ok_nvimLspInstaller, nvimLspInstaller = pcall(require, 'nvim-lsp-installer')
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok_lspconfig or not ok_nvimLspInstaller or not ok_cmp_nvim_lsp then
  if not ok_lspconfig then print('Problem loading nvim-lspconfig: ') end
  if not ok_nvimLspInstaller then print('Problem loading nvim-lsp-installer: ') end
  if not ok_cmp_nvim_lsp then print('Problem loading cmp_nvim_lsp: ') end
  return
end

--[[ Minimal Nvim LSP Installer ]]
nvimLspInstaller.on_server_ready(function(server)
  local opts = {}
  server:setup(opts)
end)

-- LSP related normal mode <localleader> keymappings
--
-- See: https://github.com/scalameta/nvim-metals/discussions/39
--      https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/lsp/handlers.lua
 
local lsp_mappings = {
  name = '+lsp',
  F = {':lua vim.lsp.buf.formatting()<CR>', 'Formatting'},
  g = {
    name = '+goto',
    d = {':lua vim.lsp.buf.definition()<CR>', 'Goto Definition'},
    D = {':lua vim.lsp.buf.declaration()<CR>', 'Goto Declaration'},
    i = {':lua vim.lsp.buf.implementation()<CR>', 'Goto Implementation'},
    r = {':lua vim.lsp.buf.references()<CR>', 'Goto References'} },
  h = {':lua vim.lsp.buf.signature_help()<CR>', 'Signature Help'},
  H = {':lua vim.lsp.buf.hover()<CR>', 'Hover'},
  K = {':lua vim.lsp.buf.worksheet_hover()<CR>', 'Worksheet Hover'},
  l = {':lua vim.diagnostic.setloclist()<CR>', 'Diagnostic Set Local list'},
  m = {":lua require('metals').open_all_diagnostics()<CR>", 'Metals Diagnostics'},
  r = {':lua vim.lsp.buf.rename()<CR>', 'Rename'},
  s = {
    name = '+symbol',
    d = {':lua vim.lsp.buf.document_symbol()<CR>', 'Document Symbol'},
    w = {':lua vim.lsp.buf.workspace_symbol()<CR>', 'Workspace Symbol'} },
  w = {
    name = '+workspace folder',
    a = {':lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add Workspace Folder'},
    r = {':lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove Workspace Folder'} }
}

local lsp_opts = {
  mode = 'n',
  prefix = '<Localleader>',
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true
}

local on_attach = function(client, bufnr)
  local mappings = lsp_mappings
  local opts = lsp_opts
  opts['buffer'] = bufnr
  wk.register(mappings, opts)
end

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

for _, lsp_server in ipairs(lsp_servers) do
  lspconfig[lsp_server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes =150  -- Default for Neovim 0.7+
    }
  }
end

--[[ Lua configuration ]]
vim.cmd [[
  augroup lua_config
    au!
    au FileType lua setlocal shiftwidth=2 softtabstop=2 expandtab
  augroup end ]]

--[[ Python configuration ]]
vim.g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/shims/python'

--[[ Rust configuration ]]
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

--[[ Scala configuration ]]
vim.cmd [[
  augroup scala_config
    au!
    au FileType scala,sbt setlocal shiftwidth=2 softtabstop=2 expandtab
  augroup end ]]

-- Scala Metals, see https://scalameta.org/metals/docs/editors/overview.html
vim.g.metals_server_version = '0.11.2'
local ok, metals_loc = pcall(require, 'metals')
if ok then
  metals = metals_loc  -- global!
  metals_config = metals.bare_config()  -- global!
  metals_config.settings = {
    showImplicitArguments = true,
  }
  
  vim.cmd [[
    augroup scala_metals_lsp
      au!
      au FileType scala,sbt lua metals.initialize_or_attach(metals_config)
    augroup end ]]
else
  print('Problem loading metals.')
end

--[[ Zig Configuration ]]
vim.g.zig_fmt_autosave = 0  -- Don't auto-format on save
