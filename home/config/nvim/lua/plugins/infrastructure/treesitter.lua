--[[ Config neovim built-in treesitter & install language modules to it ]]

local ensure_installed = {
   'awk',
   'bash',
   'c',
   'clojure',
   'cmake',
   'cpp',
   'css',
   'diff',
   'fish',
   'fortran',
   'git_rebase',
   'gitattributes',
   'gitcommit',
   'gitignore',
   'go',
   'haskell',
   'html',
   'java',
   'javascript',
   'json',
   'julia',
   'kotlin',
   'llvm',
   'lua',
   'make',
   'markdown',
   'markdown_inline',
   'ocaml',
   'python',
   'query',
   'r',
   'racket',
   'regex',
   'rust',
   'scala',
   'toml',
   'tsx',
   'typescript',
   'vim',
   'vimdoc',
   'yaml',
   'zig',
}

local config_treesitter = function()
   -- Install parsers (asynchronous, idempotent)
   require('nvim-treesitter').install(ensure_installed)

   -- Enable treesitter features per-buffer
   vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('_treesitter', {}),
      callback = function(args)
         if pcall(vim.treesitter.start, args.buf) then
            vim.wo[0][0].foldmethod = 'expr'
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo[args.buf].indentexpr =
               "v:lua.require'nvim-treesitter'.indentexpr()"
         end
      end,
   })
end

return {
   {
      [1] = 'nvim-treesitter/nvim-treesitter',
      branch = 'main',
      event = 'VeryLazy',
      config = config_treesitter,
      build = ':TSUpdate',
   },
}
