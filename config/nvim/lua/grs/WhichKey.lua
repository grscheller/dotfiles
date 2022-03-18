local ok, wk = pcall(require, 'which-key')
if not ok then
  print('Problem loading which-key.nvim.')
  return
end

wk.setup {
  plugins = {
    spelling = {
      enabled = true,
      suggestions = 36
    }
  }
}
