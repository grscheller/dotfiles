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

-- Check if DAP for debugging is available
local ok_dap, dap = pcall(require, 'dap')
if not ok_dap then
  print('Problem loading nvim-dap: ' .. dap)
end

--[[ Nvim LSP Installer Configuration ]]

-- For lang server list see 1st link https://github.com/neovim/nvim-lspconfig
local lsp_servers = {
  'bashls', -- bash-language-server (pacman or sudo npm i -g bash-language-server)
  'clangd', -- C and C++ - both clang and gcc (pacman clang)
  'cssls', -- vscode-css-language-servers (pacman + symlink name tweak)
  'gopls', -- go language server (pacman gopls)
  'hls', -- haskell-language-server (pacman)
  'html', -- vscode-html-language-server (pacman + symlink name tweak)
  'jsonls', -- vscode-json-language-server (pacman + symlink name tweak)
  'pyright', -- Pyright for Python (pacman or npm)
  'tsserver', -- typescript-language-server (pacman)
  'yamlls', -- yaml-language-server (pacman yaml-language-server)
  'zls' -- zig language server (packer ziglang/zig.vim)
}

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
local km = require('grs.KeyMappings')

nvimLspInstaller.setup { } -- Must be called before interacting with lspconfig

for _, lsp_server in ipairs(lsp_servers) do
  lspconfig[lsp_server].setup {
    on_attach = km.lsp_kb,
    capabilities = capabilities
  }
end

--[[ Lua Lang Configuration ]]

-- Lua auto-indent configuration
vim.api.nvim_command [[ au FileType lua setlocal shiftwidth=2 softtabstop=2 expandtab ]]

-- lua-language-server configuration for editing Neovim configs
lspconfig.sumneko_lua.setup {
  on_attach = km.lsp_kb,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = 'vim' },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      telemetry = { enable = false }
    }
  }
}

--[[ Python Aditional Configurations ]]
vim.g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/shims/python'

--[[ Rust Lang Configuration ]]
local ok_rt, rust_tools = pcall(require, 'rust-tools')
if ok_rt then
  rust_tools.setup {
    server = {
      on_attach = km.lsp_kb,
      capabilities = capabilities,
      standalone = true
    }
  }
else
  print('Problem loading rust-tools: ' .. rust_tools)
end

--[[ Scala Lang Configuration ]]
-- Following: https://github.com/scalameta/nvim-metals/discussions/39
-- For latest Metals Server Version see: https://scalameta.org/metals/docs
local ok_metals, metals = pcall(require, 'metals')
if ok_metals then
  local metals_config = metals.bare_config()

  metals_config.settings = {
    showImplicitArguments = true,
    serverVersion = 'SNAPSHOT'
  }

  metals_config.init_options.statusBarProvider = 'on'

  metals_config.capabilities = capabilities

  if ok_dap then
    dap.configurations.scala = {
      {
        type = 'scala',
        request = 'launch',
        name = 'RunOrTest',
        metals = {
          runType = 'runOrTestFile'
          --args = { 'firstArg', 'secondArg, ...' }
        }
      },
      {
        type = 'scala',
        request = 'launch',
        name = 'Test Target',
        metals = {
          runType = 'testTarget'
        }
      }
    }
  end

  metals_config.on_attach = function(client, bufnr)
    km.lsp_kb(client, bufnr)
    km.sm_kb(bufnr, metals)
    if ok_dap then
      km.dap_kb(bufnr, dap)
      metals.setup_dap()
    end
  end

  local scala_metals_group = vim.api.nvim_create_augroup('scala-metals', {
    clear = true
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'scala', 'sbt' },
    callback = function()
      metals.initialize_or_attach(metals_config)
    end,
    group = scala_metals_group
  })
else
  print('Problem loading metals: ' .. metals)
end

--[[ Zig Lang Configuration ]]
vim.g.zig_fmt_autosave = 0 -- Don't auto-format on save
