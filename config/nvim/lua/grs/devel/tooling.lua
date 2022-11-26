--[[ Software Devel Tooling ]]

--[[ The overiding principle is to configure only what I
     currently use, not everything I might like to use someday. ]]

local grsDevel = require('grs.devel.core')
local pm = grsDevel.pm

local mason = pm.mason   -- Using mason as 3rd party tool package manager.
local system = pm.system -- Pacman, Apt, Nix, Brew, Cocolately, MSYS2, ...

local LspconfigServers = {
   bashls =   system,
   clangd =   system,
   cssls =    mason,
   gopls =    system,
   html =     mason,
   jsonls =   mason,
   marksman = mason,
   pyright =  system,
   taplo =    system,
   yamlls =   system,
   zls =      mason
}

local DapServers = {
   bash =   mason,
   cppdbg = mason
}

local NullLsBuiltinTools = {
   code_actions = {},
   completions = {},
   diagnostics = {
      cppcheck =     system,
      cpplint =      system,
      markdownlint = mason,
      mdl =          system,
      selene =       system
   },
   formatting = {
      stylua = system
   },
   hover = {}
}

local grsUtils = require('grs.utilities.grsUtils')
local grsMason = require('grs.devel.core.mason')
local grsNullLs = require('grs.devel.core.nullLs')
local grsDap = require('grs.devel.core.dap')

grsMason.setup(LspconfigServers, DapServers, NullLsBuiltinTools)
grsNullLs.setup(NullLsBuiltinTools)
local dap, dap_ui_widgets = grsDap.setup(DapServers)

local msg = grsUtils.msg_hit_return_to_continue
local cmd = vim.api.nvim_command

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
cmd [[au FileType lua setlocal shiftwidth=3 softtabstop=3 expandtab]]

--[[ Haskell LSP Configuration ]]
lspconf['hls'].setup {
   capabilities = capabilities,
   on_attach = function(client, bufnr)
      keybindings.lsp_kb(client, bufnr)
      keybindings.haskell_kb(bufnr)
   end
}
cmd [[au FileType haskell setlocal shiftwidth=2 softtabstop=2 expandtab]]

--[[ Scala Metals & Rust-Tools directly configure lspconfig themselves ]]

-- Rust Lang Tooling - rust_tools & lldb
   -- Following: https://github.com/simrat39/rust-tools.nvim
   --            https://github.com/sharksforarms/neovim-rust
local rust_tools
ok, rust_tools = pcall(require, 'rust-tools')
if ok and dap then
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
if ok and dap then
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
cmd [[au FileType scala setlocal shiftwidth=2 softtabstop=2 expandtab]]
cmd [[au FileType sbt setlocal shiftwidth=2 softtabstop=2 expandtab]]

--[[ Additional  Tooling Configurations ]]

-- Pointing python3_host_prog to the pyenv shim and running nvim
-- in that environment.  Both pipenv and pynvim need to be installed.
vim.g.python3_host_prog =
   os.getenv('HOME') .. '/.local/share/pyenv/shims/python'
