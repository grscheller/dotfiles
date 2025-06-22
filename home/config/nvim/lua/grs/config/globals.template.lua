--[[ Globals - loaded before lazy takes control ]]

local km = require 'grs.config.keymaps_whichkey'

-- First thing loaded in init.lua, most plugins only read these on startup.

-- Define leader keys once and for all
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Define user's XDG directories (install scrips sed in actual locations)
vim.g.grs_xdg_config_home = '<xdg_config_home>'
vim.g.grs_xdg_cache_home = '<xdg_cache_home>'
vim.g.grs_xdg_data_home = '<xdg_data_home>'
vim.g.grs_xdg_state_home = '<xdg_data_home>'

-- Nerd fonts need to be installed and configured in terminal emulator
vim.g.have_nerd_font = true

-- Perl had its day - it had the best man pages ever
vim.g.loaded_perl_provider = 0

--{{ Globals for plugins ]]

vim.g.nvim_lastplace = {
    ignore_buftype = { 'quickfix', 'nofile', 'help' },
    ignore_filetype = { 'gitcommit', 'gitrebase' },
    open_folds = true,
}

vim.g.rustaceanvim = {
   tools = {},
   server = {
      on_attach = function(_, bufnr)
         km.set_lsp_keymaps(nil, bufnr)
         km.set_rust_keymaps(bufnr)
         km.set_dap_keymaps(bufnr)
      end,
      default_settings = {
         ['rust-analyzer'] = {},
      },
   },
   dap = {},
}
