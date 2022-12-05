--[[ Software Devel Tooling ]]

--[[
     Using Mason as a 3rd party package manager (pm).

     When a server/tool is not provided in the underlying
     os/environment by some package manager such as
     Pacman, Apt, Nix, Brew, SDKMAN, Cocolately, MSYS2, ...
     or by Packer (packer.nvim).

     The overiding principle is to configure only what I
     actually use, not to install and configure everything
     I might possibly like to use someday.

--]]

local coreTooling = require 'grs.devel.core.tooling'

local m = coreTooling.configure_choices -- (auto, manual, install, ignore)

--[[ The next 3 tables are the main auto lspconfig, dap, null-ls drivers ]]

local LspServerTbl = {
   -- Lspconfig uses default configurations for items marked m.auto. 
   -- Mason installs packages in the mason tables not marked m.ignore.
   -- Both lists use the LSP module (lspconfig) names, not Mason package names.
   mason = {
      cssls = m.auto,
      groovyls = m.ignore,
      html = m.auto,
      jsonls = m.auto,
      marksman = m.auto,
      rust_analyzer = m.manual,
      zls = m.auto,
   },
   -- For system table, anything not m.auto is really just informational only.
   system = {
      bashls = m.auto,
      clangd = m.auto,
      gopls = m.auto,
      hls = m.manual,
      pyright = m.ignore,
      rust_tools = m.manual,   -- uses lspconfig and dap
      scala_metals = m.manual, -- uses lspconfig and dap
      sumneko_lua = m.manual,  -- right now geared to editing Neovim configs
      taplo = m.auto,
      yamlls = m.auto,
   },
}

local DapServerTbl = {
   -- TODO: Nvim-dap uses default configurations for items marked m.auto. 
   -- Mason installs packages in the mason tables not marked m.ignore.
   -- Lists use DAP (nvim-dap) names, not Mason package names.
   mason = {
      bash = m.auto,
      cppdbg = m.auto,
   },
   -- For system table, anything not m.auto is really just informational only.
   system = {
      rust_tools = m.manual,
      scala_metals = m.manual,
   },
}

local BuiltinToolTbls = {
   -- Null-ls uses default configurations for items marked m.auto. 
   -- Mason installs packages in the mason tables not marked m.ignore.
   -- For system tables, anything not m.auto is really just informational only.
   -- Lists use Null-ls (null-ls.nvim) names, not Mason package names.
   code_actions = {
      mason = {},
      system = {}
   },
   completions = {
      mason = {},
      system = {}
   },
   diagnostics = {
      mason = {
         markdownlint = m.auto,
         commitlint = m.auto,
      },
      system = {
         cppcheck = m.auto,
         cpplint = m.auto,
      },
   },
   formatting = {
      mason = {},
      system = {
         stylua = m.auto,
      },
   },
   hover = {
      mason = {},
      system = {},
   },
}

local coreLspconf = require 'grs.devel.core.lspconfig'
local coreMason = require 'grs.devel.core.mason'
local coreDap = require 'grs.devel.core.dap'
local coreNullLs = require 'grs.devel.core.nullLs'
local keymaps = require 'grs.core.keybindings'
local libVim = require 'grs.lib.libVim'

local msg = libVim.msg_hit_return_to_continue
local cmd = vim.api.nvim_command

-- Fetch select LSP & DAP Servers and Null-ls Builtins using Mason
coreMason.setup(LspServerTbl, DapServerTbl, BuiltinToolTbls)

-- Auto-configure select LSP & DAP Servers and Null-ls Builtins
local lspconf, capabilities = coreLspconf.setup(LspServerTbl)
local dap, dap_ui_widgets = coreDap.setup(DapServerTbl)
local nullLs = coreNullLs.setup(BuiltinToolTbls)

if not lspconf then
   msg 'Problem in tooling.lua setting up nvim-lspconfig servers, PUNTING!!!'
   return
elseif not dap then
   msg 'Problem in tooling.lua setting up nvim-dap servers, PUNTING!!!'
   return
elseif not nullLs then
   msg 'Problem in tooling.lua setting up null-ls builtins, PUNTING!!!'
   return
elseif not capabilities then
   msg 'Problem in tooling.lua setting up cmp-nvim-lsp builtins, PUNTING!!!'
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
-- or local standalone code.
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

      TODO: May have to figure out how to configure for multiple Lua
            versons.
--]]

lspconf['sumneko_lua'].setup {
   capabilities = capabilities,
   on_attach = function(client, bufnr)
      keymaps.lsp_kb(client, bufnr)
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

if LspServerTbl.hls == m.manual then
   lspconf['hls'].setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
         keymaps.lsp_kb(client, bufnr)
         keymaps.haskell_kb(bufnr)
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
if ok_rust and dap and LspServerTbl.rust_tools == m.manual then
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
            keymaps.lsp_kb(client, bufnr)
            keymaps.dap_kb(bufnr, dap, dap_ui_widgets)
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
   if LspServerTbl.rust_tools == m.manual then
      msg 'Problem in tooling.lua with rust-tools'
   end
end

--[[ Scala Metals directly configures lspconfig

     Latest Metals Server: https://scalameta.org/metals/docs
     Following: https://github.com/scalameta/nvim-metals/discussions/39
                https://github.com/scalameta/nvim-metals/discussions/279

--]]
local ok_metals, metals = pcall(require, 'metals')
if ok_metals and dap and LspServerTbl.scala_metals == m.manual then
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
      keymaps.lsp_kb(client, bufnr)
      keymaps.metals_kb(bufnr, metals)
      keymaps.dap_kb(bufnr, dap, dap_ui_widgets)
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
   if LspServerTbl.scala_metals == m.manual then
      msg 'Problem in tooling.lua with scala metals'
   end
end
