--[[ Setup Develoment Environment & LSP Configurations ]]

local ok
local treesitter_configs
local lspconfig, nvimLspInstaller, cmp_nvim_lsp
local rust_tools, metals
local ok_dap, dap, dap_widgits

--[[ Nvim-Treesitter - language modules for built-in Treesitter ]]
ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if ok then
   treesitter_configs.setup {
      ensure_installed = 'all',
      highlight = { enable = true }
   }
end

--[[ Punt if necessary LSP related plugins are not installed ]]
ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
   return
end

ok, nvimLspInstaller = pcall(require, 'nvim-lsp-installer')
if not ok then
   return
end

ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
   return
end

--[[ Set flag ok_dap if DAP debugging is available ]]
ok_dap, dap = pcall(require, 'dap')
ok, dap_widgits = pcall(require, 'dap.ui.widgits')

--[[ Python Configuration

     Pointing python3_host_prog to the pyenv shim,
     then run nvim in the virtual environment.

     Will need to install pynvim into each virtual
     environment.  I am not sure the pyright LSP server
     will use the correct virtual environment when nvim
     itself is using the base pyenv python environment. ]]

vim.g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/shims/python'

--[[ Nvim LSP Installer Configuration

     For lang server list see the 1st link
     of https://github.com/neovim/nvim-lspconfig

     Install via pacman or sudo npm i -g <language-server> ]]

local lsp_servers = {
   'bashls', -- bash lang server (pacman or npm)
   'clangd', -- C and C++ - both clang and gcc (pacman clang)
   'cssls', -- vscode-css-languageserver (pacman)
   'gopls', -- go language server (pacman gopls)
   'html', -- vscode-html-languageserver (pacman)
   'jsonls', -- vscode-json-languageserver (pacman)
   'pyright', -- Pyright for Python (pacman or npm)
   'tsserver', -- typescript-language-server (pacman)
   'yamlls', -- yaml-language-server (pacman)
   'zls' -- zig language server (packer ziglang/zig.vim)
}

local capabilities = cmp_nvim_lsp.default_capabilities()
local keybindings = require('grs.util.keybindings')

nvimLspInstaller.setup {} -- Must be called before interacting with lspconfig

for _, lsp_server in ipairs(lsp_servers) do
   lspconfig[lsp_server].setup {
      capabilities = capabilities,
      on_attach = keybindings.lsp_kb
   }
end

--[[ Lua Lang Configuration ]]

local cmd = vim.api.nvim_command

-- Lua auto-indent configuration
cmd [[au FileType lua setlocal shiftwidth=3 softtabstop=3 expandtab]]

-- lua-language-server configuration for editing Neovim configs
lspconfig['sumneko_lua'].setup {
   capabilities = capabilities,
   on_attach = keybindings.lsp_kb,
   settings = {
      Lua = {
         runtime = { version = 'LuaJIT' },
         diagnostics = { globals = { 'vim' } },
         workspace = { library = vim.api.nvim_get_runtime_file('', true) },
         telemetry = { enable = false }
      }
   }
}

--[[ Haskell Lang Configuration ]]

-- Lua auto-indent configuration
cmd [[au FileType haskell setlocal shiftwidth=2 softtabstop=2 expandtab]]

-- haskell-language-server (hls) configuration - install via pacman
lspconfig['hls'].setup {
   capabilities = capabilities,
   on_attach = function(client, bufnr)
      keybindings.lsp_kb(client, bufnr)
      keybindings.haskell_kb(bufnr)
   end
}

--[[ Rust Lang Configuration - rust_tools & lldb-vscode

     Follow setup from https://github.com/simrat39/rust-tools.nvim

     Install the LLDB DAP server, a vscode extension, from
       https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb
     The easiest way to install it is to install vscode and, through vscode's
     GUI interface, install the CodeLLDB extension.

     See https://github.com/sharksforarms/neovim-rust

     TODO: Below paths are BROKEN!!! Whole section may be out of date!!! ]]

ok, rust_tools = pcall(require, 'rust-tools')
if ok then
   local extension_path = vim.env.HOME ..
                           '/.vscode-oss/extensions/vadimcn.vscode-lldb-1.7.4'
   local codelldb_path = extension_path .. '/adapter/codelldb'
   local liblldb_path = extension_path .. '/lldb/lib/liblldb.so'
   rust_tools.setup {
      server = {
         capabilities = capabilities,
         on_attach = function(client, bufnr)
            keybindings.lsp_kb(client, bufnr)
            if ok_dap then
               keybindings.dap_kb(bufnr, dap, dap_widgits)
            end
         end,
         standalone = true,
         dap = {
            adapter = require('rust-tools.dap').get_codelldb_adapter(
               codelldb_path,
               liblldb_path
            )
         }
      }
   }
end

--[[ Scala Lang Configuration

     Following: https://github.com/scalameta/nvim-metals/discussions/39
     For latest Metals Server Version see: https://scalameta.org/metals/docs ]]

ok, metals = pcall(require, 'metals')
if ok then
   local metals_config = metals.bare_config()

   metals_config.settings = { showImplicitArguments = true }
   metals_config.capabilities = capabilities
   metals_config.init_options.statusBarProvider = 'on'

   function metals_config.on_attach(client, bufnr)
      keybindings.lsp_kb(client, bufnr)
      keybindings.metals_kb(bufnr, metals)
      if ok_dap then
         dap.configurations.scala = {{
               type = 'scala',
               request = 'launch',
               name = 'RunOrTest',
               metals = {
                  runType = 'runOrTestFile'
                  --args = { 'firstArg', 'secondArg, ...' }
               }
            }, {
               type = 'scala',
               request = 'launch',
               name = 'Test Target',
               metals = {
                  runType = 'testTarget'
               }
            }
         }
         metals.setup_dap()
         keybindings.dap_kb(bufnr, dap, dap_widgits)
      end
   end

   local scala_metals_group = vim.api.nvim_create_augroup(
      'scala-metals', {
         clear = true
      }
   )
   vim.api.nvim_create_autocmd(
      'FileType', {
         pattern = { 'scala', 'sbt' },
         callback = function()
            metals.initialize_or_attach(metals_config)
         end,
         group = scala_metals_group
      }
   )
end

--[[ Zig Lang Configuration ]]
vim.g.zig_fmt_autosave = 0 -- Don't auto-format on save
