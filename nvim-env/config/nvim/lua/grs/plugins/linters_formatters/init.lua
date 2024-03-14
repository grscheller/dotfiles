--[[ Configure plugins to make Neovim a better text editor ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.linters_formatters.formatters',
   require 'grs.plugins.linters_formatters.linters',
}
