--[[ Software Devel Tooling and LSP Configuration ]]

local cmd = vim.api.nvim_command
local msg = require('grs.util.utils').msg_hit_return_to_continue

--[[
     Nvim LSP Configuration

     see: https://github.com/williamboman/mason.nvim
          https://github.com/williamboman/mason-lspconfig.nvim
          https://github.com/neovim/nvim-lspconfig
          https://github.com/jayp0521/mason-nvim-dap.nvim
          https://github.com/mfussenegger/nvim-dap

--]]

local ok, mason
local lspconfig, cmp_nvim_lsp, mason_lspconfig
local dap, dap_ui_widgets, mason_nvim_dap

--[[
     For now, do nothing with mason and continue
     doing what was previously done manually.

     Todo: Figure out what can be configured with Mason and what
           needs to be done manually.  Determine how well Mason
           plays with "natively" installed LSP & DAP servers.

--]]

-- mason.nvim - installes/manages LSP & DAP servers, linters, formatters 
ok, mason = pcall(require, "mason")
if ok then
   mason.setup()
else
   msg('Problem in tooling.lua with neovim package manager mason')
end

-- neovim/nvim-lspconfig - collection of LSP server configurations
-- williamboman/mason-lspconfig.nvim - integrate lspconfig with mason
ok, lspconfig = pcall(require, 'lspconfig')
if ok then
   ok, mason_lspconfig = pcall(require, "mason-lspconfig")
   if ok then
      mason_lspconfig.setup()
   else
      msg('Problem in tooling.lua with mason-lspconfig')
   end
else
   msg('Problem in tooling.lua with nvim-lspconfig, PUNTING!!!')
   return
end

-- mfussenegger/nvim-dap - debug adapter protocol client
-- jayp0521/mason-nvim-dap.nvim - integrates dap with mason
ok, dap = pcall(require, 'dap')
if ok then
   dap_ui_widgets = require('dap.ui.widgets')
   ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
   if ok then
      mason_nvim_dap.setup()
   else
      msg('Problem in tooling.lua with mason-nvim-dap')
   end
else
   msg('Problem in tooling.lua with nvim_dap, PUNTING!!!')
   return
end

ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
   msg('Problem in tooling.lua with cmp_nvim_lsp, PUNTING!!!')
   return
end

   local lsp_servers = {
      'bashls',   -- bash lang server (pacman or npm)
      'clangd',   -- C and C++ - both clang and gcc (pacman clang)
      'cssls',    -- vscode-css-languageserver (pacman)
      'gopls',    -- go language server (pacman gopls)
      'html',     -- vscode-html-languageserver (pacman)
      'jsonls',   -- vscode-json-languageserver (pacman)
      'pyright',  -- Pyright for Python (pacman or npm)
      'tsserver', -- typescript-language-server (pacman)
      'yamlls',   -- yaml-language-server (pacman)
      'zls'       -- zig language server (packer ziglang/zig.vim)
   }

local capabilities = cmp_nvim_lsp.default_capabilities()
local keybindings = require('grs.util.keybindings')

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
  dap.configurations.rust = {{
     type = 'rust';
     request = 'launch';
     name = 'rt_lldb';
      }}
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
else
   msg('Problem in tooling.lua with rust-tools')
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

   local scala_metals_group =
      vim.api.nvim_create_augroup('scala-metals', { clear = true })

   vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'scala', 'sbt' },
      callback = function()
         metals.initialize_or_attach(metals_config)
      end,
      group = scala_metals_group
   })
else
   msg('Problem in tooling.lua with scala metals')
end

--[[ Zig Lang Configuration ]]
vim.g.zig_fmt_autosave = 0 -- Don't auto-format on save
