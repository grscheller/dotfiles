--[[ Nvim-Treesitter - language modules for built-in Treesitter

       Module: grs
       File: ~/.config/nvim/lua/grs/Treesitter.lua

  ]]

local ok, nv_ts_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('Problem loading nvim-treesitter.configs. ')
  return
end

nv_ts_configs.setup {
  ensure_installed = 'maintained',
  highlight = { enable = true }
}
