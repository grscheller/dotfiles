--[[ Plugins needed early or by multiple other plugins ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.infrasructure.common',
   require 'grs.plugins.infrasructure.early',
}
