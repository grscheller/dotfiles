--[[ Config neovim built-in treesitter & install language modules to it ]]

local parsers = require('grs.config.ensure_install').treesitter_parsers

return {
   {
      'nvim-treesitter/nvim-treesitter',
      event = { 'BufReadPre', 'BufNewFile' },
      build = ':TSUpdate',
      opts = {
         ensure_installed = parsers,
         auto_install = true,
         ignore_install = {},
         highlight = {
            enable = true,
            additional_vim_regex_highlighting = { 'ruby' },
         },
         indent = { enable = true, disable = { 'ruby' } },
      },
      -- config = function(_, opts)
      --    require('nvim-treesitter.install').prefer_git = true
      --    require('nvim-treesitter.configs').setup(opts)
      --
      --    -- Check out these nvim-treesitter modules:
      --    --   - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    --   - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    --   - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      -- end,
   },
}
