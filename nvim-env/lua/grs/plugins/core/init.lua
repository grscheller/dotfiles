--[[ Plugins needed early or by multiple other plugins ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.core.appearance',
   require 'grs.plugins.core.common',
   require 'grs.plugins.core.early',
   require 'grs.plugins.core.mason',
   require 'grs.plugins.core.telescope',
   require 'grs.plugins.core.treesitter',
   require 'grs.plugins.core.whichkey',
}
