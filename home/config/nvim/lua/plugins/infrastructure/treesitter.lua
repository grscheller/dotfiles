--[[ Config neovim built-in treesitter & install language modules to it ]]

local config_treesitter = function()
   -- Install parsers (asynchronous, idempotent)
   require('nvim-treesitter').install(require('config.treesitter').ensure_installed)

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
