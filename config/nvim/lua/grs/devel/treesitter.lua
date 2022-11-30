--[[ Install Language Modules for Built-in Treesitter ]]

local msg = require('grs.utilities.grsUtils').msg_hit_return_to_continue

local ok, ntree = pcall(require, 'nvim-treesitter.configs')
if ok then
   ntree.setup {
      ensure_installed = 'all',
      highlight = { enable = true },
   }
else
   msg 'Problem in treesitter.lua with nvim-treesitter'
end
