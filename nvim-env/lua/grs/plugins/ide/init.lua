--[[ Configure LSP, DAP and Completion plugins to make Neovim into a full IDE ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
--   require 'grs.plugins.ide.dap',
   require 'grs.plugins.ide.fidgit',
--   require 'grs.plugins.ide.lsp',
}
