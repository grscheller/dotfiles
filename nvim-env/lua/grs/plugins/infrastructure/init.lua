--[[ Plugins needed early or by multiple other plugins ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.infrastructure.common',
   require 'grs.plugins.infrastructure.early',
}
