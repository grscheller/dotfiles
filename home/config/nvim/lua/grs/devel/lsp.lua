--[[ LSP and Tooling Configurations ]]

local ok
local cmd = vim.api.nvim_command

-- Nvim-Treesitter - language modules for built-in Treesitter
local treesitter_configs

ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if ok then
   treesitter_configs.setup {
      ensure_installed = 'all',
      highlight = { enable = true }
   }
end

-- Punt if necessary LSP related plugins are not installed
local lspconfig, nvim_lsp_installer, cmp_nvim_lsp

ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
   return
end

ok, nvim_lsp_installer = pcall(require, 'nvim-lsp-installer')
if not ok then
   return
end

ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
   return
end

-- Prepare to conditionally configure DAP
local ok_dap, dap, dap_ui_widgets
ok_dap, dap = pcall(require, 'dap')
if ok_dap then
   dap_ui_widgets = require('dap.ui.widgets')
end

--[[
     Nvim LSP Installer Configuration

     See https://github.com/neovim/nvim-lspconfig
     for a language server list.

     Install via pacman or sudo npm i -g <language-server>

     TODO: nvim-lsp-installer has been DEPRECATED!!!

           Need to replace
             - williamboman/nvim-lsp-installer
             - neovim/nvim-lspconfig

           with these

             - williamboman/mason.nvim
             - williamboman/mason-lspconfig.nvim

           These will also help with DAP configuraation.
--]]
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

nvim_lsp_installer.setup {} -- Must be called before interacting with lspconfig

for _, lsp_server in ipairs(lsp_servers) do
   lspconfig[lsp_server].setup {
      capabilities = capabilities,
      on_attach = keybindings.lsp_kb
   }
end

--[[ Haskell configuration - Lua auto-indent configuration ]]
cmd [[au FileType haskell setlocal shiftwidth=2 softtabstop=2 expandtab]]

lspconfig['hls'].setup {
   capabilities = capabilities,
   on_attach = function(client, bufnr)
      keybindings.lsp_kb(client, bufnr)
      keybindings.haskell_kb(bufnr)
   end
}

--[[ Lua configuration - geared towards editing Neovim configs ]]
cmd [[au FileType lua setlocal shiftwidth=3 softtabstop=3 expandtab]]

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

--[[
     Python Configuration

     Pointing python3_host_prog to the pyenv shim
     and running nvim in the virtual environment.

     Todo: Figure out where pipenv and pynvim 
           need to be installed.  Base python
           environment or each virtual environment?
--]]
vim.g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/shims/python'

--[[
     Rust Lang Configuration - rust_tools & lldb

     Following https://github.com/simrat39/rust-tools.nvim
           and https://github.com/sharksforarms/neovim-rust 

     Install the LLDB DAP server, a vscode extension. On
     Arch Linux, install the lldb pacman package from extra.
--]]
local rt
ok, rt = pcall(require, 'rust-tools')
if ok then
   if ok_dap then
      dap.configurations.rust = {{
         type = 'rust';
         request = 'launch';
         name = 'rt_lldb';
      }}
   end
   rt.setup {
      runnables = {
         use_telescope = true
      },
      server = {
         capabilities = capabilities,
         on_attach = function(client, bufnr)
            keybindings.lsp_kb(client, bufnr)
            if ok_dap then
               keybindings.dap_kb(bufnr, dap, dap_ui_widgets)
            end
         end,
         standalone = true
      },
      dap = {
         adapter = {
            type = 'executable',
            command = 'lldb-vscode',
            name = 'rt_lldb'
         }
      }
   }
end

--[[
     Scala Lang Configuration

     Following: https://github.com/scalameta/nvim-metals/discussions/39
     For latest Metals Server Version see: https://scalameta.org/metals/docs
--]]
local metals
ok, metals = pcall(require, 'metals')
if ok then
   local metals_config = metals.bare_config()

   metals_config.settings = {
      showImplicitArguments = true,
      serverVersion = '0.11.9'
   }
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
         keybindings.dap_kb(bufnr, dap, dap_ui_widgets)
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
