local ok, km, bn
ok, km = pcall(require, 'grs.config.keymaps')
if ok then
   bn = vim.api.nvim_get_current_buf()
   km.set_lsp_keymaps(nil, bn)
   km.set_rust_keymaps(bn)
end

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.shiftround = true
