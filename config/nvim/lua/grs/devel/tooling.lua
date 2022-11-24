--[[ Software Devel Tooling ]]

--[[ The overiding principle is to configure only what I
     currently use, not everything I might like to use someday. ]]

local lspconfig_servers = {
   'bashls',       -- bash-language-server
   'clangd',       -- C and C++ - for clang & gcc
   'cssls',        -- vscode-css-languageserver (mason uses npm)
   'gopls',        -- go language server
   'html',         -- vscode-html-languageserver (mason uses npm)
   'jsonls',       -- vscode-json-languageserver (mason uses npm)
   'marksman',     -- markdown language server
   'pyright',      -- pyright for Python
   'taplo',        -- toml
   'yamlls',       -- Redhat yaml-language-server
   'zls'           -- zig
}
local mason_lspconfig_servers = {
   'cssls',
   'html',
   'jsonls',
   'marksman',
   'zls'
}

local dap_servers = {
   'bash',
   'cppdbg'
}
local mason_dap_servers = {
   'bash',
   'cppdbg'
}

local null_ls_builtins = {
   'cppcheck',
   'cpplint',
   'markdownlint',
   'mdl',
   'selene',
   'stylua'
}
local mason_null_ls_builtins = {
   'markdownlint'
}

local msg = require('grs.utilities.grsUtils').msg_hit_return_to_continue

-- jose-elias-alvarez/null-ls.nvim for linters & formatters
-- TODO: Create sources table from above info.
local ok_null, null_ls = pcall(require, 'null-ls')
if ok_null then
   null_ls.setup {
      sources = {
         null_ls.builtins.diagnostics.cppcheck,
         null_ls.builtins.diagnostics.cpplint,
         null_ls.builtins.diagnostics.markdownlint,
         null_ls.builtins.diagnostics.mdl,
         null_ls.builtins.diagnostics.selene,
         null_ls.builtins.formatting.stylua
      }
   }
else
   msg('Problem in tooling.lua with null-ls, PUNTING!!!')
   return
end

-- williamboman/mason.nvim a package manager for LSP & DAP servers,
-- linters, and formatters
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
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

-- WhoIsSethDaniel/mason-tool-installer.nvim
-- used to install/upgrade 3rd party tools.
local ok_mti, mason_tool_installer = pcall(require, "mason-tool-installer")
if ok_mti then
   local grsMason = require('grs.devel.core.mason')
   local dapWithMasonNames = grsMason.dap2mason(mason_dap_servers)
   mason_tool_installer.setup {
      ensure_installed = dapWithMasonNames,
      auto_update = false,
      start_delay = 3000 -- millisecondss
   }
   vim.api.nvim_create_autocmd('User', {
      pattern = 'MasonToolsUpdateCompleted',
      callback = function()
         vim.schedule(function()
            print('ﮊ  mason-tool-installer has finished!')
         end)
      end
   })
else
   msg('Problem in tooling.lua with mason-tool-installer')
end

-- mfussenegger/nvim-dap for debugging tools
local dap_ui_widgets
local ok_dap, dap = pcall(require, 'dap')
if ok_dap then
   dap_ui_widgets = require('dap.ui.widgets')
else
   msg('Problem in tooling.lua with nvim_dap, PUNTING!!!')
   return
end

-- setup neovim/nvim-lspconfig to configure LSP servers
local ok, lspconf = pcall(require, 'lspconfig')
if not ok then
   msg('Problem in tooling.lua with nvim-lspconfig, PUNTING!!!')
   return
end

-- hrsh7th/cmp-nvim-lsp integrates LSP with completions
local cmp_nvim_lsp
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
local cmd = vim.api.nvim_command
cmd [[au FileType haskell setlocal shiftwidth=2 softtabstop=2 expandtab]]
cmd [[au FileType lua setlocal shiftwidth=3 softtabstop=3 expandtab]]
cmd [[au FileType scala setlocal shiftwidth=2 softtabstop=2 expandtab]]
cmd [[au FileType sbt setlocal shiftwidth=2 softtabstop=2 expandtab]]
