--[[ Software Devel Tooling ]]

--[[ The overiding principle is to configure only what I
      currently use, not everything I might someday like
      to use.

     Using Mason as a 3rd party package manager (pm) when a server/tool
     is not provided by a package manager from the underlying environment,
     such as Pacman, Apt, Nix, Brew, SDKMAN, Cocolately, MSYS2, ...       ]]

local coreTooling = require 'grs.devel.core.tooling'

local default = coreTooling.conf.use_default_configuration
local manual = coreTooling.conf.manually_configure
local no_config = coreTooling.conf.do_not_directly_configure
local ignore = coreTooling.conf.neither_install_nor_configure

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
      pyright = ignore,
      rust_analyzer = no_config,
      rust_tools = manual,
      scala_metals = manual,
      sumneko_lua = manual,
      taplo = default,
      yamlls = default,
      zls = default,
   },
}

local DapServers = {
   mason = {
      bash = default,
      cppdbg = default,
   },
   system = {},
}

local BuiltinTools = {
   code_actions = { mason = {}, system = {} },
   completions = { mason = {}, system = {} },
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
   hover = {
      mason = {},
      system = {},
   },
}

local libVim = require 'grs.lib.libVim'
local coreLspconf = require 'grs.devel.core.lspconfig'
local coreMason = require 'grs.devel.core.mason'
local coreDap = require 'grs.devel.core.dap'
local coreNullLs = require 'grs.devel.core.nullLs'

local msg = libVim.msg_hit_return_to_continue
local kb = require 'grs.core.keybindings'
local cmd = vim.api.nvim_command

coreMason.setup(LspServers, DapServers, BuiltinTools)
coreNullLs.setup(BuiltinTools)
local dap, dap_ui_widgets = coreDap.setup(DapServers)

--[[ setup neovim/nvim-lspconfig to configure LSP servers ]]

-- hrsh7th/cmp-nvim-lsp integrates LSP for completions
local ok_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok_cmp then
   msg 'Problem in tooling.lua with cmp_nvim_lsp, PUNTING!!!'
   return
end
local capabilities = cmp_nvim_lsp.default_capabilities()

local lspconf = coreLspconf.setup(LspServers)
if not lspconf then
   msg 'Problem in tooling.lua with nvim-lspconfig, PUNTING!!!'
   return
end

--[[ Lua Configuration - geared to Neovim configs ]]

-- This produces a template of the right form,
-- but containing many non-existing directories.
-- I think it is some sort of "default" to find
-- Lua and Luarocks infrastructure.
local runtime_path = vim.split(package.path, ';')

-- Below either an attempt to configure an nvim_get_runtime_file
-- generated table or locally be able to overide code in a plugin,
-- or local standalone code (especially for latter is put at end
-- of table instead of beginning).
table.insert(runtime_path, 1, '?.lua')
table.insert(runtime_path, 1, '?/init.lua')
table.insert(runtime_path, 1, '?/?.lua')

--[[ Grokking:

  local runtime_path = vim.api.nvim_get_runtime_file('', true)

     Above produces a list of the runtime directories in search order.

  local runtime_path = vim.api.nvim_get_runtime_file('*.lua', true)

     Produces a fairly short list of Lua files on runtime path:

  { "/home/grs/.config/nvim/init.lua",
    "/home/grs/.local/share/nvim/site/pack/packer/start/nvim-lspconfig/gleam.lua",
    "/usr/share/nvim/runtime/filetype.lua" }

  local runtime_path = vim.api.nvim_get_runtime_file('*.lua', true)
  local runtime_path = vim.api.nvim_get_runtime_file('*/*.lua', true)

      Above produce alot of hits, mostly in the plugin directories.

  local runtime_path = vim.api.nvim_get_runtime_file('lua/*/*.lua', true)

      In particular, above produces a massive amount of Lua files.

      TODO: Figure out the appropriate commands to find all the Lua
            entry points into the plugins (and luarocks?) and
            generate a template.

      TODO: Explore use of .luarc.json file to control sumneko_lua
            lsp server.  One got generated a while back an I don't
            how or why.
--]]

lspconf['sumneko_lua'].setup {
   capabilities = capabilities,
   on_attach = function(client, bufnr)
      kb.lsp_kb(client, bufnr)
      cmd [[setlocal shiftwidth=3 softtabstop=3 expandtab]]
   end,
   settings = {
      Lua = {
         runtime = {
            version = 'LuaJIT',
            path = runtime_path,
         },
         diagnostics = { globals = { 'vim' } },
         workspace = {
            library = runtime_path,
            checkThirdParty = false,
         },
         telemetry = { enable = false },
      },
   },
}

--[[ Haskell Configuration ]]

if LspServers.hls == manual then
   lspconf['hls'].setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
         kb.lsp_kb(client, bufnr)
         kb.haskell_kb(bufnr)
         cmd [[setlocal shiftwidth=2 softtabstop=2 expandtab]]
      end,
   }
end

--[[ Python Configuration - both pipenv and pynvim need to be installed. ]]

vim.g.python3_host_prog = os.getenv 'HOME' .. '/.local/share/pyenv/shims/python'

--[[ Rust-Tools directly configures lspconfig

     Following: https://github.com/simrat39/rust-tools.nvim
                https://github.com/sharksforarms/neovim-rust ]]

local ok_rust, rust_tools = pcall(require, 'rust-tools')
if ok_rust and dap then
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
            kb.lsp_kb(client, bufnr)
            kb.dap_kb(bufnr, dap, dap_ui_widgets)
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
   msg 'Problem in tooling.lua with rust-tools'
end

--[[ Scala Metals directly configures lspconfig

     Latest Metals Server: https://scalameta.org/metals/docs
     Following: https://github.com/scalameta/nvim-metals/discussions/39
                https://github.com/scalameta/nvim-metals/discussions/279 ]]

local ok_metals, metals = pcall(require, 'metals')
if ok_metals and dap then
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
      kb.lsp_kb(client, bufnr)
      kb.metals_kb(bufnr, metals)
      kb.dap_kb(bufnr, dap, dap_ui_widgets)
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
   if LspServers.scala_metals ~= manual then
      msg 'Problem in tooling.lua with scala metals'
   end
end
