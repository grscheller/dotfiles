--[[ Mason Related Infrastructure ]]

--[[
     Chore: Periodically update these next three tables,
     LspconfigToMasonPackage, DapToMasonPackage, and NullLsToMasonPackage,
     from these next three GitHub repos respectively:

  williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings/server.lua
  jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
  jay-babu/mason-null-ls.nvim/blob/main/lua/mason-null-ls/mappings/source.lua

     These Mason "add-on" configuration plugins seem only to work
     for LSP & DAP servers and Null-ls builtins installed by Mason.

--]]
local LspconfigToMasonPackage = {
   ["als"] = "ada-language-server",
   ["angularls"] = "angular-language-server",
   ["ansiblels"] = "ansible-language-server",
   ["apex_ls"] = "apex-language-server",
   ["arduino_language_server"] = "arduino-language-server",
   ["asm_lsp"] = "asm-lsp",
   ["astro"] = "astro-language-server",
   ["awk_ls"] = "awk-language-server",
   ["bashls"] = "bash-language-server",
   ["beancount"] = "beancount-language-server",
   ["bicep"] = "bicep-lsp",
   ["bsl_ls"] = "bsl-language-server",
   ["bufls"] = "buf-language-server",
   ["clangd"] = "clangd",
   ["clarity_lsp"] = "clarity-lsp",
   ["clojure_lsp"] = "clojure-lsp",
   ["cmake"] = "cmake-language-server",
   ["codeqlls"] = "codeql",
   ["crystalline"] = "crystalline",
   ["csharp_ls"] = "csharp-language-server",
   ["cssls"] = "css-lsp",
   ["cssmodules_ls"] = "cssmodules-language-server",
   ["cucumber_language_server"] = "cucumber-language-server",
   ["dagger"] = "cuelsp",
   ["denols"] = "deno",
   ["dhall_lsp_server"] = "dhall-lsp",
   ["diagnosticls"] = "diagnostic-languageserver",
   ["dockerls"] = "dockerfile-language-server",
   ["dotls"] = "dot-language-server",
   ["drools_lsp"] = "drools-lsp",
   ["efm"] = "efm",
   ["elixirls"] = "elixir-ls",
   ["elmls"] = "elm-language-server",
   ["ember"] = "ember-language-server",
   ["emmet_ls"] = "emmet-ls",
   ["erg_language_server"] = "erg-language-server",
   ["erlangls"] = "erlang-ls",
   ["esbonio"] = "esbonio",
   ["eslint"] = "eslint-lsp",
   ["flux_lsp"] = "flux-lsp",
   ["foam_ls"] = "foam-language-server",
   ["fortls"] = "fortls",
   ["fsautocomplete"] = "fsautocomplete",
   ["glint"] = "glint",
   ["golangci_lint_ls"] = "golangci-lint-langserver",
   ["gopls"] = "gopls",
   ["gradle_ls"] = "gradle-language-server",
   ["grammarly"] = "grammarly-languageserver",
   ["graphql"] = "graphql-language-service-cli",
   ["groovyls"] = "groovy-language-server",
   ["haxe_language_server"] = "haxe-language-server",
   ["hls"] = "haskell-language-server",
   ["hoon_ls"] = "hoon-language-server",
   ["html"] = "html-lsp",
   ["intelephense"] = "intelephense",
   ["jdtls"] = "jdtls",
   ["jedi_language_server"] = "jedi-language-server",
   ["jsonls"] = "json-lsp",
   ["jsonnet_ls"] = "jsonnet-language-server",
   ["julials"] = "julia-lsp",
   ["kotlin_language_server"] = "kotlin-language-server",
   ["lelwel_ls"] = "lelwel",
   ["lemminx"] = "lemminx",
   ["ltex"] = "ltex-ls",
   ["luau_lsp"] = "luau-lsp",
   ["marksman"] = "marksman",
   ["mm0_ls"] = "metamath-zero-lsp",
   ["neocmake"] = "neocmakelsp",
   ["nickel_ls"] = "nickel-lang-lsp",
   ["nil_ls"] = "nil",
   ["nimls"] = "nimlsp",
   ["ocamllsp"] = "ocaml-lsp",
   ["omnisharp"] = "omnisharp",
   ["omnisharp_mono"] = "omnisharp-mono",
   ["opencl_ls"] = "opencl-language-server",
   ["openscad_lsp"] = "openscad-lsp",
   ["perlnavigator"] = "perlnavigator",
   ["phpactor"] = "phpactor",
   ["powershell_es"] = "powershell-editor-services",
   ["prismals"] = "prisma-language-server",
   ["prosemd_lsp"] = "prosemd-lsp",
   ["psalm"] = "psalm",
   ["puppet"] = "puppet-editor-services",
   ["purescriptls"] = "purescript-language-server",
   ["pylsp"] = "python-lsp-server",
   ["pyright"] = "pyright",
   ["quick_lint_js"] = "quick-lint-js",
   ["r_language_server"] = "r-languageserver",
   ["raku_navigator"] = "raku-navigator",
   ["reason_ls"] = "reason-language-server",
   ["remark_ls"] = "remark-language-server",
   ["rescriptls"] = "rescript-lsp",
   ["rnix"] = "rnix-lsp",
   ["robotframework_ls"] = "robotframework-lsp",
   ["rome"] = "rome",
   ["ruby_ls"] = "ruby-lsp",
   ["ruff_lsp"] = "ruff-lsp",
   ["rust_analyzer"] = "rust-analyzer",
   ["salt_ls"] = "salt-lsp",
   ["serve_d"] = "serve-d",
   ["slint_lsp"] = "slint-lsp",
   ["smithy_ls"] = "smithy-language-server",
   ["solang"] = "solang",
   ["solargraph"] = "solargraph",
   ["solc"] = "solidity",
   ["solidity"] = "solidity-ls",
   ["sorbet"] = "sorbet",
   ["sourcery"] = "sourcery",
   ["spectral"] = "spectral-language-server",
   ["sqlls"] = "sqlls",
   ["sqls"] = "sqls",
   ["stylelint_lsp"] = "stylelint-lsp",
   ["sumneko_lua"] = "lua-language-server",
   ["svelte"] = "svelte-language-server",
   ["svlangserver"] = "svlangserver",
   ["svls"] = "svls",
   ["tailwindcss"] = "tailwindcss-language-server",
   ["taplo"] = "taplo",
   ["teal_ls"] = "teal-language-server",
   ["terraformls"] = "terraform-ls",
   ["texlab"] = "texlab",
   ["tflint"] = "tflint",
   ["theme_check"] = "shopify-theme-check",
   ["tsserver"] = "typescript-language-server",
   ["vala_ls"] = "vala-language-server",
   ["verible"] = "verible",
   ["vimls"] = "vim-language-server",
   ["visualforce_ls"] = "visualforce-language-server",
   ["vls"] = "vls",
   ["volar"] = "vue-language-server",
   ["vuels"] = "vetur-vls",
   ["wgsl_analyzer"] = "wgsl-analyzer",
   ["yamlls"] = "yaml-language-server",
   ["zk"] = "zk",
   ["zls"] = "zls",
}

local DapToMasonPackage = {
   ['python'] = 'debugpy',
   ['cppdbg'] = 'cpptools',
   ['delve'] = 'delve',
   ['node2'] = 'node-debug2-adapter',
   ['chrome'] = 'chrome-debug-adapter',
   ['firefox'] = 'firefox-debug-adapter',
   ['php'] = 'php-debug-adapter',
   ['coreclr'] = 'netcoredbg',
   ['codelldb'] = 'codelldb',
   ['bash'] = 'bash-debug-adapter',
   ['javadbg'] = 'java-debug-adapter',
   ['javatest'] = 'java-test',
   ['mock'] = 'mockdebug',
   ['puppet'] = 'puppet-editor-services',
   ['elixir'] = 'elixir-ls',
   ['kotlin'] = 'kotlin-debug-adapter',
   ['dart'] = 'dart-debug-adapter',
}

local BuiltinsToMasonPackage = {
   ['cmake_format'] = 'cmakelang',
   ['eslint_d'] = 'eslint_d',
   ['goimports_reviser'] = 'goimports_reviser',
   ['phpcsfixer'] = 'php-cs-fixer',
   ['verible_verilog_format'] = 'verible',
   ['lua_format'] = 'luaformatter',
}

local BuiltinsToMasonPackageMT = {}
BuiltinsToMasonPackageMT.__index = function(_, builtin_name)
   return builtin_name:gsub('_', '-')
end

setmetatable(BuiltinsToMasonPackage,BuiltinsToMasonPackageMT)

local util = require 'grs.util'
local iFlatten = util.iFlatten
local getFilteredKeys = util.getFilteredKeys

local function convertToMasonPkgs(names, package_names)
   local mason_names = {}
   local cnt = 0
   for _, v in pairs(names) do
      if package_names[v] then
         cnt = cnt + 1
         mason_names[cnt] = package_names[v]
      else
         local message = string.format(
            'Warning: No Mason package for %s found!"', v)
         vim.notify(message)
      end
   end
   return mason_names
end

local M = {}

M.lspconfig2mason = function(LspSvrTbl, pred)
   return convertToMasonPkgs(
      getFilteredKeys(LspSvrTbl.mason, pred),
      LspconfigToMasonPackage
   )
end

M.dap2mason = function(DapSrvrTbl, pred)
   return convertToMasonPkgs(
      getFilteredKeys(DapSrvrTbl.mason, pred),
      DapToMasonPackage
   )
end

M.nullLs2mason = function(BuiltinToolsTbl, pred)
   return convertToMasonPkgs(
      getFilteredKeys(BuiltinToolsTbl.mason, pred),
      BuiltinsToMasonPackage
   )
end

M.serverList = function(ServerTbl, masonEnum)
   local pred = function(_, v)
      return v == masonEnum
   end
   return iFlatten {
      getFilteredKeys(ServerTbl.mason, pred),
      getFilteredKeys(ServerTbl.system, pred),
   }
end

return M
