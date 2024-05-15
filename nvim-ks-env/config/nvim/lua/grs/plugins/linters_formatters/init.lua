--[[ Leverage command-line linters and formatters ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.linters_formatters.formatters',
   require 'grs.plugins.linters_formatters.linters',
}
