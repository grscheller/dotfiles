--[[ Nvim-Treesitter - language modules for built-in Treesitter ]]

local ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('Problem loading nvim-treesitter.configs: ' .. ts_configs)
  return
end

ts_configs.setup {
  ensure_installed = 'all',
  highlight = { enable = true }
}
