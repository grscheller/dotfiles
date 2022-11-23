--[[ Software Devel Tooling ]]

--[[ LSP, DAP, Null-ls configuration & package management infrastructure

        https://github.com/neovim/nvim-lspconfig
        https://github.com/mfussenegger/nvim-dap
        https://github.com/jose-elias-alvarez/null-ls.nvim
        https://github.com/williamboman/mason.nvim
        https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
        https://github.com/jayp0521/mason-null-ls.nvim
        https://github.com/RubixDev/mason-update-all
        https://github.com/jayp0521/mason-nvim-dap.nvim

     The overiding principle is to configure what I actually have 
     used and not everything that someday I might potentially use.
--]]

local lspconfig_names = {
   'bashls',        -- bash lang server
   'clangd',        -- C and C++ - for clang & gcc
   'cssls',     -- vscode-css-languageserver (mason uses npm)
   'gopls',         -- go language server
   'hls',           -- haskell language server
   'html',      -- vscode-html-languageserver (mason uses npm)
   'jsonls',    -- vscode-json-languageserver (mason uses npm)
   'marksman',  -- markdown language server
   'pyright',       -- pyright for Python
   'sumneko_lua',   -- lua-language-server???
   'taplo',     -- toml
   'yamlls',    -- Redhat yaml (mason uses npm)
   'zls'        -- zig
}

local dapSystem = {}
local dapMason = {
   'bash',
   'cppdbg'
}

local null_ls_mason = {
   'cpplint',
   'markdownlint',
   'selene',
   'stylua'
}

local grsMason = require('grs.devel.core.mason')
local dapWithMasonNames = grsMason.dap2mason(dapMason)

local cmd = vim.api.nvim_command
local msg = require('grs.utilities.grsUtils').msg_hit_return_to_continue

local ok, mason, mason_update_all, mason_tool_installer
local lspconf, cmp_nvim_lsp
local dap, dap_ui_widgets, mason_nvim_dap
local null_ls, mason_null_ls

-- williamboman/mason.nvim a package manager for LSP & DAP servers,
-- linters, and formatters
ok, mason = pcall(require, "mason")
if ok then
   mason.setup {
      ui = {
         icons = {
            package_installed = ' ',
            package_pending = ' ',
            package_uninstalled = ' ﮊ'
         }
      }
   }
else
   msg('Problem in tooling.lua with nvim package manager mason, PUNTING!!!')
end

-- RubixDev/mason-update-all used by my bsPacker shell script
ok, mason_update_all = pcall(require, "mason-update-all")
if ok then
   mason_update_all.setup()
   vim.api.nvim_create_autocmd('User', {
      pattern = 'MasonUpdateAllComplete',
      callback = function()
         print('ﮊ  Mason-Update-All has finished!')
      end
   })
else
   msg('Problem in tooling.lua with mason-update-all')
end

-- WhoIsSethDaniel/mason-tool-installer.nvim
-- used to install/upgrade 3rd party tools.
ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if ok then
   mason_tool_installer.setup {
      ensure_installed = dapWithMasonNames,  -- TODO: fix to include rest
      auto_update = false,
      start_delay = 3000 -- millisecondss
   }
else
   msg('Problem in tooling.lua with mason-update-all')
end

-- mfussenegger/nvim-dap for debugging tools
ok, dap = pcall(require, 'dap')
if ok then
   -- jayp0521/mason-nvim-dap.nvim for Mason DAP integration
   ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
   if ok then
      mason_nvim_dap.setup()
   else
      msg('Problem in tooling.lua with mason-nvim-dap')
   end
   dap_ui_widgets = require('dap.ui.widgets')
else
   msg('Problem in tooling.lua with nvim_dap, PUNTING!!!')
   return
end

-- jose-elias-alvarez/null-ls.nvim for linters & formatters
ok, null_ls = pcall(require, 'null-ls')
if ok then
   -- jayp0521/mason-null-ls.nvim for Mason integration
   ok, mason_null_ls = pcall(require, 'mason-null-ls')
   if ok then
      mason_null_ls.setup()
   else
      msg('Problem in tooling.lua with mason-null-ls')
   end

else
   msg('Problem in tooling.lua with null-ls, PUNTING!!!')
   return
end

-- setup neovim/nvim-lspconfig to configure LSP servers
ok, lspconf = pcall(require, 'lspconfig')
if not ok then
   msg('Problem in tooling.lua with nvim-lspconfig, PUNTING!!!')
   return
end

-- hrsh7th/cmp-nvim-lsp integrates LSP with completions
ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
   msg('Problem in tooling.lua with cmp_nvim_lsp, PUNTING!!!')
   return
end

local capabilities = cmp_nvim_lsp.default_capabilities()
local keybindings = require('grs.utilities.keybindings')

--[[ Lua LSP Configuration ]]
lspconf['sumneko_lua'].setup {
   capabilities = capabilities,
   on_attach = keybindings.lsp_kb,
   settings = {
      Lua = {
         runtime = { version = 'LuaJIT' },
         diagnostics = { globals = { 'vim' } },
         workspace = {
            library = vim.api.nvim_get_runtime_file('', true)
         },
         telemetry = { enable = false }
      }
   }
}

--[[ Haskell LSP Configuration ]]
lspconf['hls'].setup {
   capabilities = capabilities,
   on_attach = function(client, bufnr)
      keybindings.lsp_kb(client, bufnr)
      keybindings.haskell_kb(bufnr)
   end
}

--[[ Scala Metals & Rust-Tools directly configure lspconfig themselves ]]

-- Rust Lang Tooling - rust_tools & lldb
   -- Following: https://github.com/simrat39/rust-tools.nvim
   --            https://github.com/sharksforarms/neovim-rust
local rust_tools
ok, rust_tools = pcall(require, 'rust-tools')
if ok then
   dap.configurations.rust = {
      {
         type = 'rust';
         request = 'launch';
         name = 'rt_lldb';
      }
   }
   rust_tools.setup {
      runnables = {
         use_telescope = true
      },
      server = {
         capabilities = capabilities,
         on_attach = function(client, bufnr)
            keybindings.lsp_kb(client, bufnr)
            keybindings.dap_kb(bufnr, dap, dap_ui_widgets)
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

-- Scala Lang Tooling - Scala Metals
   -- Following: https://github.com/scalameta/nvim-metals/discussions/39
   -- Latest Metals Server: https://scalameta.org/metals/docs
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
      dap.configurations.scala = {
         {
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

--[[ Additional  Tooling Configurations ]]

-- Pointing python3_host_prog to the pyenv shim and running nvim
-- in that environment.  Both pipenv and pynvim need to be installed.
vim.g.python3_host_prog =
   os.getenv('HOME') .. '/.local/share/pyenv/shims/python'

-- Adjust auto-indent for different filetypes
cmd [[au FileType haskell setlocal shiftwidth=2 softtabstop=2 expandtab]]
cmd [[au FileType lua setlocal shiftwidth=3 softtabstop=3 expandtab]]
cmd [[au FileType scala setlocal shiftwidth=2 softtabstop=2 expandtab]]
cmd [[au FileType sbt setlocal shiftwidth=2 softtabstop=2 expandtab]]
