--[[ Software Devel Tooling and LSP Configuration ]]

--[[
     Nvim LSP Configuration

     see: https://github.com/neovim/nvim-lspconfig
          https://github.com/mfussenegger/nvim-dap
          https://github.com/williamboman/mason.nvim
          https://github.com/RubixDev/mason-update-all
          https://github.com/williamboman/mason-lspconfig.nvim
          https://github.com/jayp0521/mason-nvim-dap.nvim
          https://github.com/jayp0521/mason-null-ls.nvim

     Overiding principle is to configure what I actually
     use, not what I might like to use someday.

--]]

local cmd = vim.api.nvim_command
local msg = require('grs.util.utils').msg_hit_return_to_continue

local ok
local ok_mason = false
local lspconf, cmp_nvim_lsp
local dap, dap_ui_widgets
local null_ls
local mason, mason_update_all, mason_lspconf, mason_nvim_dap, mason_null_ls

-- williamboman/mason.nvim
--   package manager for LSP & DAP servers, linters, and formatters
ok, mason = pcall(require, "mason")
if ok then
   ok_mason = true
   mason.setup {
      ui = {
         icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
         }
      }
   }
   -- RubixDev/mason-update-all
   ok, mason_update_all = pcall(require, "mason-update-all")
   if ok then
      mason_update_all.setup()
      vim.api.nvim_create_autocmd('User', {
         pattern = 'MasonUpdateAllComplete',
         callback = function()
            print('  Mason-Update-All has finished!')
         end
      })
   else
      msg('Problem in tooling.lua with mason-update-all')
   end
else
   msg('Problem in tooling.lua with neovim package manager mason')
end

-- neovim/nvim-lspconfig to configure LSP servers
ok, lspconf = pcall(require, 'lspconfig')
if ok then
   -- williamboman/mason-lspconfig.nvim for Mason lspconfig integration
   ok, mason_lspconf = pcall(require, "mason-lspconfig")
   if ok and ok_mason then
      mason_lspconf.setup {
         ensure_installed = {
            'cssls',
            'html',
            'jsonls',
            'marksman',
            'sumneko_lua',
            'taplo',
            'yamlls',
            'zls'
         },
         automatic_installation = false
      }
   else
      msg('Problem in tooling.lua with mason-lspconfig')
   end
else
   msg('Problem in tooling.lua with nvim-lspconfig, PUNTING!!!')
   return
end

-- mfussenegger/nvim-dap for debugging tools
ok, dap = pcall(require, 'dap')
if ok then
   -- jayp0521/mason-nvim-dap.nvim for Mason DAP integration
   ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
   if ok and ok_mason then
      mason_nvim_dap.setup {
         ensure_installed = {},
         automatic_installation = false,
         automatic_setup = false
      }
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
   if ok and ok_mason then
      mason_null_ls.setup {
         ensure_installed = {
            'markdownlint'
         },
         automatic_installation = false,
         automatic_setup = true
      }
      null_ls.setup {
         sources = {
            null_ls.builtins.diagnostics.markdownlint
         }
      }
   else
      msg('Problem in tooling.lua with mason-null-ls')
   end
else
   msg('Problem in tooling.lua with null-ls')
end

-- hrsh7th/cmp-nvim-lsp to integrate LSP with completions
ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
   msg('Problem in tooling.lua with cmp_nvim_lsp, PUNTING!!!')
   return
end

local lsp_servers = {
   'bashls',    -- bash lang server (pacman)
   'clangd',    -- C and C++ - for clang & gcc (pacman clang)
   'cssls',     -- vscode-css-languageserver (mason with npm)
   'gopls',     -- go language server (pacman gopls)
   'html',      -- vscode-html-languageserver (mason with npm)
   'jsonls',    -- vscode-json-languageserver (mason with npm)
   'marksman',  -- markdown language server (mason)
   'pyright',   -- pyright for Python (pacman)
   'taplo',     -- toml (mason)
   'yamlls',    -- Redhat yaml (mason with npm)
   'zls'        -- zig (mason)
}

local capabilities = cmp_nvim_lsp.default_capabilities()
local keybindings = require('grs.util.keybindings')

for _, lsp_server in ipairs(lsp_servers) do
   lspconf[lsp_server].setup {
      capabilities = capabilities,
      on_attach = keybindings.lsp_kb
   }
end

--[[ Haskell configuration - Lua auto-indent configuration ]]
cmd [[au FileType haskell setlocal shiftwidth=2 softtabstop=2 expandtab]]

lspconf['hls'].setup {
   capabilities = capabilities,
   on_attach = function(client, bufnr)
      keybindings.lsp_kb(client, bufnr)
      keybindings.haskell_kb(bufnr)
   end
}

--[[ Lua configuration - geared towards editing Neovim configs ]]
cmd [[au FileType lua setlocal shiftwidth=3 softtabstop=3 expandtab]]

lspconf['sumneko_lua'].setup {
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
vim.g.python3_host_prog =
   os.getenv('HOME') .. '/.local/share/pyenv/shims/python'

--[[
     Rust Lang Configuration - rust_tools & lldb

     Following https://github.com/simrat39/rust-tools.nvim
           and https://github.com/sharksforarms/neovim-rust

     Install the LLDB DAP server, a vscode extension. On
     Arch Linux, install the lldb pacman package from extra.

--]]
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
