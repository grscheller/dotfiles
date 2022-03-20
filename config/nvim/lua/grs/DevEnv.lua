--[[ Setup Develoment Environment - LSP Configurations ]]

-- Check if LSP related plugins I use are installed
local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
local ok_nvimLspInstaller, nvimLspInstaller = pcall(require, 'nvim-lsp-installer')
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok_lspconfig or not ok_nvimLspInstaller or not ok_cmp_nvim_lsp then
  if not ok_lspconfig then print('Problem loading nvim-lspconfig: ') end
  if not ok_nvimLspInstaller then print('Problem loading nvim-lsp-installer: ') end
  if not ok_cmp_nvim_lsp then print('Problem loading cmp_nvim_lsp: ') end
  return
end

-- Punt LSP config if Which-Key not installed
local ok, wk = pcall(require, 'which-key')
if not ok then
  print('No Which-Key, punting on LSP config: ')
  return
end

local on_attach = function(client, bufnr)

  -- LSP related normal mode <leader> keymappings
  local mappings = {
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
  
  local opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = bufnr,
    silent = true,
    noremap = true,
    nowait = true
  }
  
  wk.register(mappings, opts)
  
end

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

--[[ Nvim LSP Installer ]]
nvimLspInstaller.on_server_ready(function(server)
  local opts = {
    settings = {
      on_attach = on_attach,
      capabilities = capabilities
    }
  }
  server:setup(opts)
end)

--[[ Rust configuration, rust-tools.nvim will call lspconfig itself ]]
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

--[[ Scala Metals configuration ]]
vim.g.metals_server_version = '0.11.2'  -- See https://scalameta.org/metals/docs/editors/overview.html

local ok, metals = pcall(require, 'metals')
if ok then
  local metals_config = metals.bare_config()
  metals_config.settings = {
    showImplicitArguments = true --,
    -- on_attach = on_attach,
    -- capabilities = capabilities
  }
  
  vim.cmd [[
    augroup metals_lsp
      au!
      au FileType scala,sbt lua metals.initialize_or_attach(metals_config)
    augroup end ]]
else
  print('Problem loading metals.')
end

--[[ Python configuration ]]
vim.g.python3_host_prog = os.getenv("HOME") .. '/.pyenv/shims/python'

--[[ Zig Configuration ]]
vim.g.zig_fmt_autosave = 0  -- Don't auto-format on save
