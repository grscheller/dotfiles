vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = '+1,+21'
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.shiftround = true
-- We need to skip $VIMRUNTIME/ftplugin/markdown.vim. It does not respect
-- my settings and I am not smart enough to fix the damage it does with
-- an after/ftplugin/markdown.lua file.
-- vim.api.nvim_command('let b:did_ftplugin=1')
