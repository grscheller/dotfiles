---@brief
---
--- https://ast-grep.github.io/
---
--- ast-grep(sg) is a fast and polyglot tool for
--- code structural search, lint, rewriting at large scale.
---
--- ast-grep LSP only works in projects that have `sgconfig.yaml`
--- files in their root directories and `rules/*.yaml` files.
---
--- Tests for rules are found in `rule-tests/*.yaml` with
--- corresponding names. To run tests, a necessary step,
--- run from the commandline
---
--- ```
--- ast-grep test --update-all
--- ```

---@type vim.lsp.Config
return {
   cmd = { 'ast-grep', 'lsp' },
   workspace_required = true,
   reuse_client = function(client, config)
      return client.name == config.name and client.config.root_dir == config.root_dir
   end,
   filetypes = { -- https://ast-grep.github.io/reference/languages.html
      'bash',
      'c',
      'cpp',
      'cs',
      'css',
      'elixir',
      'go',
      'haskell',
      'html',
      'java',
      'javascript',
      'javascriptreact',
      'json',
      'kotlin',
      'lua',
      'nix',
      'php',
      'python',
      'ruby',
      'rust',
      'scala',
      'solidity',
      'swift',
      'typescript',
      'typescriptreact',
      'yaml',
   },
   root_markers = { 'sgconfig.yaml', 'sgconfig.yml' },
}
