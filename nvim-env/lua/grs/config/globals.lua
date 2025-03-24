--[[ Globals - loaded before lazy takes control ]]

local km = require 'grs.config.keymaps'

-- First thing loaded in init.lua, most plugins only read these on startup.

-- Set leader keys once and for all
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd fonts need to be installed and configured in terminal emulator
vim.g.have_nerd_font = true

-- Neovim provider
vim.g.python3_host_prog = '~/devel/venvs/nvim/bin/python'

-- Perl had its day
vim.g.loaded_perl_provider = 0

-- rustaceanvim configuration
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
