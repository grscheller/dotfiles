--[[ Install Language Modules for Neovim's built-in Treesitter ]]

local msg = require('grs.lib.Vim').msg_hit_return_to_continue

local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not ok then
   msg 'Problem in treesitter.lua with nvim-treesitter'
   return
end

treesitter.setup {
   ensure_installed = 'all',
   sync_install = false,
   highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
   },
}
