--[[ Mason Utility Tables & Functions ]]

local M = {}

-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
M.lspconfig_to_package = {
   ['awk_ls']                 = 'awk-language-server',
   ['bashls']                 = 'bash_language_server',
   ['clangd']                 = 'clangd',
   ['clojure']                = 'clojure',
   ['cmake']                  = 'cmake-language-server',
   ['cssls']                  = 'css-lsp',
   ['eslint']                 = 'eslint-lsp',
   ['gopls']                  = 'gopls',
   ['gradle_ls']              = 'gradle-language-server',
   ['groovyls']               = 'groovy-language-server',
   ['hls']                    = 'haskell-language-server',
   ['html']                   = 'html-lsp',
   ['jdtls']                  = 'jdtls',
   ['jedi_language_server']   = 'jedi-language-server',
   ['jsonls']                 = 'json-lsp',
   ['julials']                = 'julia-lsp',
   ['kotlin_language_server'] = 'kotlin-language-server',
   ['marksman']               = 'marksman',
   ['powershell_es']          = 'powershell-editor-services',
   ['pylsp']                  = 'python-lsp-server',
   ['pyright']                = 'pyright',
   ['r_language_server']      = 'r-languageserver',
   ['ruby_ls']                = 'ruby-lsp',
   ['rust_analyzer']          = 'rust-analyzer',
   ['slint_lsp']              = 'slint-lsp',
   ['sumneko_lua']            = 'lua-language-server',
   ['taplo']                  = 'taplo',
   ['tsserver']               = 'typescript-language-server',
   ['vimls']                  = 'vim-language-server',
   ['yamlls']                 = 'yaml-language-server',
   ['zls']                    = 'zls'
}

M.lint_to_package = {
   ['eslint']        = 'eslint-lsp',
   ['quick_lint_js'] = 'quick-lint-js',
}

M.format_to_package = {
   ['eslint'] = 'eslint-lsp'
}

M.dap_to_package = {
   ['bash']     = 'bash-debug-adapter',
   ['chrome']   = 'chrome-debug-adapter',
   ['cppdbg']   = 'cpptools',
   ['coreclr']  = 'netcoredbg',
   ['delve']    = 'delve',
   ['elixir']   = 'elixir-ls',
   ['firefox']  = 'firefox-debug-adapter',
   ['javadbg']  = 'java-debug-adapter',
   ['javatest'] = 'java-test',
   ['js']       = 'js-debug-adapter',
   ['lldb']     = 'codelldb',
   ['mock']     = 'mockdebug',
   ['node2']    = 'node-debug2-adapter',
   ['php']      = 'php-debug-adapter',
   ['puppet']   = 'puppet-editor-services',
   ['python']   = 'debugpy'
}

M.dap2mason = function(dap_names)
   local mason_names = {}
   for i,v in ipairs(dap_names) do
      mason_names[i] = M.dap_to_package[v]
   end
   return mason_names
end

return M
