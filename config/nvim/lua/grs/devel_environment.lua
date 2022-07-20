--[[ Setup Develoment Environment & LSP Configurations ]]

--[[ Nvim-Treesitter - language modules for built-in Treesitter ]]
local ok_ts, ts_configs = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
   ts_configs.setup {
      ensure_installed = 'all',
      highlight = { enable = true }
   }
else
   print('Problem loading nvim-treesitter.configs: ' .. ts_configs)
end

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
local keymappings = require('grs.util.keymappings')

nvimLspInstaller.setup {} -- Must be called before interacting with lspconfig

for _, lsp_server in ipairs(lsp_servers) do
   lspconfig[lsp_server].setup {
      capabilities = capabilities,
      on_attach = keymappings.lsp_kb
   }
end

--[[ Lua Lang Configuration ]]
-- Lua auto-indent configuration
vim.api.nvim_command [[ au FileType lua setlocal shiftwidth=3 softtabstop=3 expandtab ]]

-- lua-language-server configuration for editing Neovim configs
lspconfig.sumneko_lua.setup {
   capabilities = capabilities,
   on_attach = keymappings.lsp_kb,
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

--[[ Rust Lang Configuration - rust_tools & lldb-vscode
--
-- Follow setup from https://github.com/simrat39/rust-tools.nvim
--
-- Install the LLDB DAP server, a vscode extension, from
--   https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb
-- The easiest way to install it is to install vscode and, through vscode's
-- GUI interface, install the CodeLLDB extension.
--
-- Todo: See https://github.com/sharksforarms/neovim-rust for 
--       example rust/dap configurations.
--]]
local ok_rt, rust_tools = pcall(require, 'rust-tools')
if ok_rt then
   local extension_path = vim.env.HOME .. '/.vscode-oss/extensions/vadimcn.vscode-lldb-1.7.0/'
   local codelldb_path = extension_path .. 'adapter/codelldb'
   local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
   rust_tools.setup {
      server = {
         capabilities = capabilities,
         on_attach = function(client, bufnr)
            keymappings.lsp_kb(client, bufnr)
            if ok_dap then
               keymappings.dap_kb(bufnr)
            end
         end,
         standalone = true,
         dap = {
            adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
         }
      }
   }
else
   print('Problem loading rust-tools: ' .. rust_tools)
end

--[[ Scala Lang Configuration
--
-- Following: https://github.com/scalameta/nvim-metals/discussions/39
-- For latest Metals Server Version see: https://scalameta.org/metals/docs
--
--]]
local ok_metals, metals = pcall(require, 'metals')
if ok_metals then
   local metals_config = metals.bare_config()

   metals_config.settings = {
      showImplicitArguments = true,
      serverVersion = '0.11.7'
   }

   metals_config.capabilities = capabilities

   metals_config.init_options.statusBarProvider = 'on'

   function metals_config.on_attach(client, bufnr)
      keymappings.lsp_kb(client, bufnr)
      keymappings.sm_kb(bufnr)
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
         metals.setup_dap()
         keymappings.dap_kb(bufnr)
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
