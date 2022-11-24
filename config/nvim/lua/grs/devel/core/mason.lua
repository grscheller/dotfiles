--[[ Mason Core Functions & Associated Tables ]]

local M = {}

--[[ Chore: Periodically update these next three tables (lsp_to_package,
            null_ls_to_package, dap_to_package) from these three GitHub
            sources respectively:

  williamboman/mason-lspconfig.nvim/lua/mason-lspconfig/mappings/server.lua
  jayp0521/mason-null-ls.nvim/lua/mason-null-ls/mappings/source.lua
  jayp0521/mason-nvim-dap.nvim/lua/mason-nvim-dap/mappings/source.lua

     These 3 Mason "add-on" configuration plugins only seem to work
     for LSP & DAP servers and Null-ls sources installed by Mason. ]]

local lsp_to_package = {
   ['als'] = 'ada-language-server',
   ['angularls'] = 'angular-language-server',
   ['ansiblels'] = 'ansible-language-server',
   ['apex_ls'] = 'apex-language-server',
   ['arduino_language_server'] = 'arduino-language-server',
   ['asm_lsp'] = 'asm-lsp',
   ['astro'] = 'astro-language-server',
   ['awk_ls'] = 'awk-language-server',
   ['bashls'] = 'bash-language-server',
   ['beancount'] = 'beancount-language-server',
   ['bicep'] = 'bicep-lsp',
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
   ['dockerls'] = 'dockerfile-language-server',
   ['dotls'] = 'dot-language-server',
   ['efm'] = 'efm',
   ['elixirls'] = 'elixir-ls',
   ['elmls'] = 'elm-language-server',
   ['ember'] = 'ember-language-server',
   ['emmet_ls'] = 'emmet-ls',
   ['erg_language_server'] = 'erg-language-server',
   ['erlangls'] = 'erlang-ls',
   ['esbonio'] = 'esbonio',
   ['eslint'] = 'eslint-lsp',
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
   ['luau_lsp'] = 'luau-lsp',
   ['marksman'] = 'marksman',
   ['mm0_ls'] = 'metamath-zero-lsp',
   ['nickel_ls'] = 'nickel-lang-lsp',
   ['nimls'] = 'nimlsp',
   ['ocamllsp'] = 'ocaml-lsp',
   ['omnisharp'] = 'omnisharp',
   ['omnisharp_mono'] = 'omnisharp-mono',
   ['opencl_ls'] = 'opencl-language-server',
   ['perlnavigator'] = 'perlnavigator',
   ['phpactor'] = 'phpactor',
   ['powershell_es'] = 'powershell-editor-services',
   ['prismals'] = 'prisma-language-server',
   ['prosemd_lsp'] = 'prosemd-lsp',
   ['psalm'] = 'psalm',
   ['puppet'] = 'puppet-editor-services',
   ['purescriptls'] = 'purescript-language-server',
   ['pylsp'] = 'python-lsp-server',
   ['pyright'] = 'pyright',
   ['quick_lint_js'] = 'quick-lint-js',
   ['r_language_server'] = 'r-languageserver',
   ['reason_ls'] = 'reason-language-server',
   ['remark_ls'] = 'remark-language-server',
   ['rescriptls'] = 'rescript-lsp',
   ['rnix'] = 'rnix-lsp',
   ['robotframework_ls'] = 'robotframework-lsp',
   ['rome'] = 'rome',
   ['ruby_ls'] = 'ruby-lsp',
   ['rust_analyzer'] = 'rust-analyzer',
   ['salt_ls'] = 'salt-lsp',
   ['serve_d'] = 'serve-d',
   ['slint_lsp'] = 'slint-lsp',
   ['solang'] = 'solang',
   ['solargraph'] = 'solargraph',
   ['solc'] = 'solidity',
   ['solidity'] = 'solidity-ls',
   ['sorbet'] = 'sorbet',
   ['sourcery'] = 'sourcery',
   ['spectral'] = 'spectral-language-server',
   ['sqlls'] = 'sqlls',
   ['sqls'] = 'sqls',
   ['stylelint_lsp'] = 'stylelint-lsp',
   ['sumneko_lua'] = 'lua-language-server',
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
   ['vala_ls'] = 'vala-language-server',
   ['verible'] = 'verible',
   ['vimls'] = 'vim-language-server',
   ['visualforce_ls'] = 'visualforce-language-server',
   ['vls'] = 'vls',
   ['volar'] = 'vue-language-server',
   ['vuels'] = 'vetur-vls',
   ['wgsl_analyzer'] = 'wgsl-analyzer',
   ['yamlls'] = 'yaml-language-server',
   ['zk'] = 'zk',
   ['zls'] = 'zls'
}

local null_ls_to_package = {
   ['actionlint'] = 'actionlint',
   ['alex'] = 'alex',
   ['autopep8'] = 'autopep8',
   ['beautysh'] = 'beautysh',
   ['black'] = 'black',
   ['blade_formatter'] = 'blade-formatter',
   ['blue'] = 'blue',
   ['buf'] = 'buf',
   ['buildifier'] = 'buildifier',
   ['cbfmt'] = 'cbfmt',
   ['cfn_lint'] = 'cfn-lint',
   ['clang_format'] = 'clang-format',
   ['cmake_format'] = 'cmakelang',
   ['codespell'] = 'codespell',
   ['commitlint'] = 'commitlint',
   ['cpplint'] = 'cpplint',
   ['csharpier'] = 'csharpier',
   ['cspell'] = 'cspell',
   ['curlylint'] = 'curlylint',
   ['djlint'] = 'djlint',
   ['dprint'] = 'dprint',
   ['editorconfig_checker'] = 'editorconfig-checker',
   ['elm_format'] = 'elm-format',
   ['erb_lint'] = 'erb-lint',
   ['eslint_d'] = 'eslint_d',
   ['fixjson'] = 'fixjson',
   ['flake8'] = 'flake8',
   ['gersemi'] = 'gersemi',
   ['gitlint'] = 'gitlint',
   ['gofumpt'] = 'gofumpt',
   ['goimports'] = 'goimports',
   ['goimports_reviser'] = 'goimports_reviser',
   ['golangci_lint'] = 'golangci-lint',
   ['golines'] = 'golines',
   ['hadolint'] = 'hadolint',
   ['haml_lint'] = 'haml-lint',
   ['isort'] = 'isort',
   ['joker'] = 'joker',
   ['jq'] = 'jq',
   ['jsonlint'] = 'jsonlint',
   ['ktlint'] = 'ktlint',
   ['luacheck'] = 'luacheck',
   ['markdownlint'] = 'markdownlint',
   ['misspell'] = 'misspell',
   ['mypy'] = 'mypy',
   ['phpcbf'] = 'phpcbf',
   ['phpcsfixer'] = 'php-cs-fixer',
   ['prettier'] = 'prettier',
   ['prettierd'] = 'prettierd',
   ['proselint'] = 'proselint',
   ['protolint'] = 'protolint',
   ['psalm'] = 'psalm',
   ['pylama'] = 'pylama',
   ['pylint'] = 'pylint',
   ['pyproject_flake8'] = 'pyproject-flake8',
   ['revive'] = 'revive',
   ['rome'] = 'rome',
   ['rubocop'] = 'rubocop',
   ['rustfmt'] = 'rustfmt',
   ['selene'] = 'selene',
   ['shellcheck'] = 'shellcheck',
   ['shellharden'] = 'shellharden',
   ['shfmt'] = 'shfmt',
   ['solhint'] = 'solhint',
   ['sql_formatter'] = 'sql-formatter',
   ['sqlfluff'] = 'sqlfluff',
   ['standardrb'] = 'standardrb',
   ['staticcheck'] = 'staticcheck',
   ['stylelint'] = 'stylelint-lsp',
   ['stylua'] = 'stylua',
   ['taplo'] = 'taplo',
   ['textlint'] = 'textlint',
   ['vale'] = 'vale',
   ['vint'] = 'vint',
   ['vulture'] = 'vulture',
   ['write_good'] = 'write-good',
   ['xo'] = 'xo',
   ['yamlfmt'] = 'yamlfmt',
   ['yamllint'] = 'yamllint',
   ['yapf'] = 'yapf'
}

local dap_to_package = {
   ['cppdbg'] = 'cpptools',
   ['delve'] = 'delve',
   ['node2'] = 'node-debug2-adapter',
   ['chrome'] = 'chrome-debug-adapter',
   ['firefox'] = 'firefox-debug-adapter',
   ['php'] = 'php-debug-adapter',
   ['coreclr'] = 'netcoredbg',
   ['js'] = 'js-debug-adapter',
   ['lldb'] = 'codelldb',
   ['bash'] = 'bash-debug-adapter',
   ['javadbg'] = 'java-debug-adapter',
   ['javatest'] = 'java-test',
   ['mock'] = 'mockdebug',
   ['puppet'] = 'puppet-editor-services',
   ['elixir'] = 'elixir-ls'
}

local msg = require('grs.utilities.grsUtils').msg_hit_return_to_continue

local convert_to_mason_names = function(names, package_names)
   local mason_names = {}
   local cnt = 0
   for _,v in ipairs(names) do
      if package_names[v] then
         cnt = cnt + 1
         mason_names[cnt] = package_names[v]
      else
         local message = 'Warning: No Mason package for "' .. v .. '" found!'
         msg(message)
      end
   end
   return mason_names
end

M.lsp2mason = function(lsp_names)
   return convert_to_mason_names(lsp_names, lsp_to_package)
end

M.linter2mason = function(null_ls_names)
   return convert_to_mason_names(null_ls_names, null_ls_to_package)
end

M.dap2mason = function(dap_names)
   return convert_to_mason_names(dap_names, dap_to_package)
end

return M
