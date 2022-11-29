--[[ Software Devel Tooling ]]

--[[ The overiding principle is to configure only what I
      currently use, not everything I might someday like
      to use.

     Using Mason as a 3rd party package manager (pm) when a server/tool
     is not provided by a package manager from the underlying environment,
     such as Pacman, Apt, Nix, Brew, SDKMAN, Cocolately, MSYS2, ...       ]]

local grsUtils = require 'grs.utilities.grsUtils'
local grsDevel = require 'grs.devel.core'
local grsLspconf = require 'grs.devel.core.lspconfig'
local grsMason = require 'grs.devel.core.mason'
local grsDap = require 'grs.devel.core.dap'
local grsNullLs = require 'grs.devel.core.nullLs'

local msg = grsUtils.msg_hit_return_to_continue
local keybindings = require 'grs.utilities.keybindings'
local cmd = vim.api.nvim_command

local default = grsDevel.conf.default_configuration
local manual = grsDevel.conf.manual_configuration
local noconfig = grsDevel.conf.do_not_directly_configure

--[[ The next 3 tables are the main auto lspconfig, dap, null-ls drivers ]]

local LspServers = {
   mason = {
      cssls = default,
      html = default,
      jsonls = default,
      marksman = default,
      zls = default,
   },
   system = {
      bashls = default,
      clangd = default,
      gopls = default,
      hls = default,
      pyright = noconfig,
      rust_analyzer = noconfig,
      rust_tools = manual,
      scala_metals = manual,
      sumneko_lua = manual,
      taplo = default,
      yamlls = default,
      zls = default,
   }
}

local DapServers = {
   mason = {
      bash = default,
      cppdbg = default,
   },
   system = {},
}

local NullLsBuiltinTools = {
   code_actions = {},
   completions = {},
   diagnostics = {
      mason = {
         markdownlint = manual,
      },
      system = {
         cppcheck = manual,
         cpplint = manual,
         mdl = manual,
      },
   },
   formatting = {
      mason = {},
      system = {
         stylua = manual,
      },
   },
   hover = {},
}

grsMason.setup(LspServers, DapServers, NullLsBuiltinTools)
grsNullLs.setup(NullLsBuiltinTools)
local dap, dap_ui_widgets = grsDap.setup(DapServers)

--[[ setup neovim/nvim-lspconfig to configure LSP servers ]]

-- hrsh7th/cmp-nvim-lsp integrates LSP for completions
local ok_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok_cmp then
   msg 'Problem in tooling.lua with cmp_nvim_lsp, PUNTING!!!'
   return
end
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconf = grsLspconf.setup(LspServers)
if not lspconf then
   msg 'Problem in tooling.lua with nvim-lspconfig, PUNTING!!!'
   return
end

--[[ Haskell Configuration ]]

if LspServers.hls.config == manual then
   if LspServers.hls.config == manual then
      lspconf['hls'].setup {
         capabilities = capabilities,
         on_attach = function(client, bufnr)
            keybindings.lsp_kb(client, bufnr)
            keybindings.haskell_kb(bufnr)
            cmd [[setlocal shiftwidth=2 softtabstop=2 expandtab]]
         end,
      }
   end
end

--[[ Lua Configuration - geared to Neovim configs ]]

-- Make runtime files discoverable by sumneko_lua
local sumneko_runtime_path = vim.split(package.path, ';')
table.insert(sumneko_runtime_path, 'lua/?.lua')
table.insert(sumneko_runtime_path, 'lua/?/init.lua')

if LspServers.sumneko_lua.config == manual then
   lspconf['sumneko_lua'].setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
         keybindings.lsp_kb(client, bufnr)
         cmd [[setlocal shiftwidth=3 softtabstop=3 expandtab]]
      end,
      settings = {
         Lua = {
            runtime = {
               version = 'LuaJIT',
               path = sumneko_runtime_path,
            },
            diagnostics = { globals = { 'vim' } },
            workspace = {
               library = vim.api.nvim_get_runtime_file('', true),
               checkThirdParty = false,
            },
            telemetry = { enable = false },
         },
      },
   }
end

--[[ Python Configuration - both pipenv and pynvim need to be installed. ]]

vim.g.python3_host_prog = os.getenv 'HOME' .. '/.local/share/pyenv/shims/python'

--[[ Rust-Tools directly configure lspconfig itselves

     Following: https://github.com/simrat39/rust-tools.nvim
                https://github.com/sharksforarms/neovim-rust ]]

local ok_rust, rust_tools = pcall(require, 'rust-tools')
if ok_rust and dap and LspServers.rust_tools.config == manual then
   dap.configurations.rust = {
      {
         type = 'rust',
         request = 'launch',
         name = 'rt_lldb',
      },
   }
   rust_tools.setup {
      runnables = {
         use_telescope = true,
      },
      server = {
         capabilities = capabilities,
         on_attach = function(client, bufnr)
            keybindings.lsp_kb(client, bufnr)
            keybindings.dap_kb(bufnr, dap, dap_ui_widgets)
         end,
         standalone = true,
      },
      dap = {
         adapter = {
            type = 'executable',
            command = 'lldb-vscode',
            name = 'rt_lldb',
         },
      },
   }
else
   if LspServers.rust_tools.config ~= manual then
      msg 'Problem in tooling.lua with rust-tools'
   end
end

--[[ Scala Metals directly configure lspconfig

     Latest Metals Server: https://scalameta.org/metals/docs
     Following: https://github.com/scalameta/nvim-metals/discussions/39
                https://github.com/scalameta/nvim-metals/discussions/279 ]]

local ok_metals, metals = pcall(require, 'metals')
if ok_metals and dap and LspServers.scala_metals.config == manual then
   local metals_config = metals.bare_config()

   metals_config.settings = {
      showImplicitArguments = true,
      serverVersion = '0.11.9',
   }
   metals_config.capabilities = capabilities
   metals_config.init_options.statusBarProvider = 'on'

   function metals_config.on_attach(client, bufnr)
      dap.configurations.scala = {
         {
            type = 'scala',
            request = 'launch',
            name = 'RunOrTest',
            metals = {
               runType = 'runOrTestFile',
               --args = { 'firstArg', 'secondArg, ...' }
            },
         },
         {
            type = 'scala',
            request = 'launch',
            name = 'Test Target',
            metals = {
               runType = 'testTarget',
            },
         },
      }
      metals.setup_dap()
      keybindings.lsp_kb(client, bufnr)
      keybindings.metals_kb(bufnr, metals)
      keybindings.dap_kb(bufnr, dap, dap_ui_widgets)
      cmd [[setlocal shiftwidth=2 softtabstop=2 expandtab]]
      cmd [[setlocal shiftwidth=2 softtabstop=2 expandtab]]
   end

   local scala_metals_group =
   vim.api.nvim_create_augroup('scala-metals', { clear = true })

   vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'scala', 'sbt' },
      callback = function() metals.initialize_or_attach(metals_config) end,
      group = scala_metals_group,
   })
else
   if LspServers.scala_metals.config ~= manual then
      msg 'Problem in tooling.lua with scala metals'
   end
end
