--[[ Mason related infrastructure to install external ide tooling

     Chore: Periodically update these next three tables,
     LspconfigToMasonPackage, DapToMasonPackage, and NullLsToMasonPackage,
     from these GitHub repos respectively:

        williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings/server.lua
        jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
        jay-babu/mason-null-ls.nvim/blob/main/lua/mason-null-ls/mappings/source.lua

     These above Mason "add-on" configuration plugins seem only to work
     for the LSP, DAP and Null-ls servers/builtins installed by Mason.

--]]

local LspconfigToMasonPackage = {
   ['als'] = 'ada-language-server',
   ['angularls'] = 'angular-language-server',
   ['ansiblels'] = 'ansible-language-server',
   ['antlersls'] = 'antlers-language-server',
   ['apex_ls'] = 'apex-language-server',
   ['arduino_language_server'] = 'arduino-language-server',
   ['asm_lsp'] = 'asm-lsp',
   ['astro'] = 'astro-language-server',
   ['awk_ls'] = 'awk-language-server',
   ['bashls'] = 'bash-language-server',
   ['beancount'] = 'beancount-language-server',
   ['bicep'] = 'bicep-lsp',
   ['bright_script'] = 'brighterscript',
   ['bsl_ls'] = 'bsl-language-server',
   ['bufls'] = 'buf-language-server',
   ['clangd'] = 'clangd',
   ['clarity_lsp'] = 'clarity-lsp',
   ['clojure_lsp'] = 'clojure-lsp',
   ['cmake'] = 'cmake-language-server',
   ['codeqlls'] = 'codeql',
   ['crystalline'] = 'crystalline',
   ['csharp_ls'] = 'csharp-language-server',
   ['cssls'] = 'css-lsp',
   ['cssmodules_ls'] = 'cssmodules-language-server',
   ['cucumber_language_server'] = 'cucumber-language-server',
   ['dagger'] = 'cuelsp',
   ['denols'] = 'deno',
   ['dhall_lsp_server'] = 'dhall-lsp',
   ['diagnosticls'] = 'diagnostic-languageserver',
   ['docker_compose_language_service'] = 'docker-compose-language-service',
   ['dockerls'] = 'dockerfile-language-server',
   ['dotls'] = 'dot-language-server',
   ['drools_lsp'] = 'drools-lsp',
   ['efm'] = 'efm',
   ['elixirls'] = 'elixir-ls',
   ['elmls'] = 'elm-language-server',
   ['ember'] = 'ember-language-server',
   ['emmet_ls'] = 'emmet-ls',
   ['erg_language_server'] = 'erg-language-server',
   ['erlangls'] = 'erlang-ls',
   ['esbonio'] = 'esbonio',
   ['eslint'] = 'eslint-lsp',
   ['fennel_language_server'] = 'fennel-language-server',
   ['flux_lsp'] = 'flux-lsp',
   ['foam_ls'] = 'foam-language-server',
   ['fortls'] = 'fortls',
   ['fsautocomplete'] = 'fsautocomplete',
   ['glint'] = 'glint',
   ['golangci_lint_ls'] = 'golangci-lint-langserver',
   ['gopls'] = 'gopls',
   ['gradle_ls'] = 'gradle-language-server',
   ['grammarly'] = 'grammarly-languageserver',
   ['graphql'] = 'graphql-language-service-cli',
   ['groovyls'] = 'groovy-language-server',
   ['haxe_language_server'] = 'haxe-language-server',
   ['hls'] = 'haskell-language-server',
   ['hoon_ls'] = 'hoon-language-server',
   ['html'] = 'html-lsp',
   ['intelephense'] = 'intelephense',
   ['jdtls'] = 'jdtls',
   ['jedi_language_server'] = 'jedi-language-server',
   ['jsonls'] = 'json-lsp',
   ['jsonnet_ls'] = 'jsonnet-language-server',
   ['julials'] = 'julia-lsp',
   ['kotlin_language_server'] = 'kotlin-language-server',
   ['lelwel_ls'] = 'lelwel',
   ['lemminx'] = 'lemminx',
   ['ltex'] = 'ltex-ls',
   ['lua_ls'] = 'lua-language-server',
   ['luau_lsp'] = 'luau-lsp',
   ['marksman'] = 'marksman',
   ['mm0_ls'] = 'metamath-zero-lsp',
   ['move_analyzer'] = 'move-analyzer',
   ['neocmake'] = 'neocmakelsp',
   ['nickel_ls'] = 'nickel-lang-lsp',
   ['nil_ls'] = 'nil',
   ['nimls'] = 'nimlsp',
   ['ocamllsp'] = 'ocaml-lsp',
   ['omnisharp'] = 'omnisharp',
   ['omnisharp_mono'] = 'omnisharp-mono',
   ['opencl_ls'] = 'opencl-language-server',
   ['openscad_lsp'] = 'openscad-lsp',
   ['perlnavigator'] = 'perlnavigator',
   ['phpactor'] = 'phpactor',
   ['powershell_es'] = 'powershell-editor-services',
   ['prismals'] = 'prisma-language-server',
   ['prosemd_lsp'] = 'prosemd-lsp',
   ['psalm'] = 'psalm',
   ['puppet'] = 'puppet-editor-services',
   ['purescriptls'] = 'purescript-language-server',
   ['pylsp'] = 'python-lsp-server',
   ['pyre'] = 'pyre',
   ['pyright'] = 'pyright',
   ['quick_lint_js'] = 'quick-lint-js',
   ['r_language_server'] = 'r-languageserver',
   ['raku_navigator'] = 'raku-navigator',
   ['reason_ls'] = 'reason-language-server',
   ['remark_ls'] = 'remark-language-server',
   ['rescriptls'] = 'rescript-lsp',
   ['rnix'] = 'rnix-lsp',
   ['robotframework_ls'] = 'robotframework-lsp',
   ['rome'] = 'rome',
   ['ruby_ls'] = 'ruby-lsp',
   ['ruff_lsp'] = 'ruff-lsp',
   ['rust_analyzer'] = 'rust-analyzer',
   ['salt_ls'] = 'salt-lsp',
   ['serve_d'] = 'serve-d',
   ['slint_lsp'] = 'slint-lsp',
   ['smithy_ls'] = 'smithy-language-server',
   ['solang'] = 'solang',
   ['solargraph'] = 'solargraph',
   ['solc'] = 'solidity',
   ['solidity'] = 'solidity-ls',
   ['sorbet'] = 'sorbet',
   ['sourcery'] = 'sourcery',
   ['spectral'] = 'spectral-language-server',
   ['sqlls'] = 'sqlls',
   ['sqls'] = 'sqls',
   ['standardrb'] = 'standardrb',
   ['stylelint_lsp'] = 'stylelint-lsp',
   ['svelte'] = 'svelte-language-server',
   ['svlangserver'] = 'svlangserver',
   ['svls'] = 'svls',
   ['tailwindcss'] = 'tailwindcss-language-server',
   ['taplo'] = 'taplo',
   ['teal_ls'] = 'teal-language-server',
   ['terraformls'] = 'terraform-ls',
   ['texlab'] = 'texlab',
   ['tflint'] = 'tflint',
   ['theme_check'] = 'shopify-theme-check',
   ['tsserver'] = 'typescript-language-server',
   ['unocss'] = 'unocss-language-server',
   ['vala_ls'] = 'vala-language-server',
   ['verible'] = 'verible',
   ['veryl_ls'] = 'veryl-ls',
   ['vimls'] = 'vim-language-server',
   ['visualforce_ls'] = 'visualforce-language-server',
   ['vls'] = 'vls',
   ['volar'] = 'vue-language-server',
   ['vtsls'] = 'vtsls',
   ['vuels'] = 'vetur-vls',
   ['wgsl_analyzer'] = 'wgsl-analyzer',
   ['yamlls'] = 'yaml-language-server',
   ['zk'] = 'zk',
   ['zls'] = 'zls',
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
   ['js'] = 'js-debug-adapter',
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

setmetatable(BuiltinsToMasonPackage, BuiltinsToMasonPackageMT)

local func = require('grs.lib.functional')
local getKeys = func.getKeys
local iFlatten = func.iFlatten

local message
local warn = vim.log.levels.WARN

local M = {}

-- Uses above tables to convert a list of lspconfig, dap,
-- and null-ls names to mason package names. Can be curried.
local function convertToMasonPkgs(mason_pkgs_names, names)
   local function convert(_names)
      local mason_names = {}
      local cnt = 0
      for k, _ in pairs(_names) do
         if mason_pkgs_names[k] then
            cnt = cnt + 1
            mason_names[cnt] = mason_pkgs_names[k]
         else
            message = string.format('Warning: No Mason package for %s found!', k)
            vim.notify(message, warn)
         end
      end
      return mason_names
   end

   if names then
      return convert(names)
   else
      return convert
   end
end

local convertLspconfToMason = convertToMasonPkgs(LspconfigToMasonPackage)
local convertDapToMason = convertToMasonPkgs(DapToMasonPackage)
local convertNullLsToMason = convertToMasonPkgs(BuiltinsToMasonPackage)

local tooling = require 'grs.config.tooling'
local LspMasonTbl = tooling.LspTbl.mason
local DapMasonTbl = tooling.DapTbl.mason
local BuiltinTbls = tooling.BuiltinTbls

local BuiltinMasonTbls = {}
for _, v in ipairs(getKeys(BuiltinTbls)) do
   table.insert(BuiltinMasonTbls, BuiltinTbls[v].mason)
end
local BuiltinMasonTbl = iFlatten(BuiltinMasonTbls)

M.masonPackages = function()
   return iFlatten {
      convertLspconfToMason(LspMasonTbl),
      convertDapToMason(DapMasonTbl),
      convertNullLsToMason(BuiltinMasonTbl),
   }
end

return M
