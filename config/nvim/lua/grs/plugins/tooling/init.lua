--[[ Tooling: Install 3rd party tools & Treesitter language modules ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.tooling.treesitter',
   require 'grs.plugins.tooling.mason',
}
