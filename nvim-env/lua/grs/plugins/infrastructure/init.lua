--[[ Plugins needed early or by multiple other plugins ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.infrastructure.appearance',
   require 'grs.plugins.infrastructure.common',
   require 'grs.plugins.infrastructure.mason',
   require 'grs.plugins.infrastructure.telescope',
   require 'grs.plugins.infrastructure.treesitter',
   require 'grs.plugins.infrastructure.whichkey',
}
