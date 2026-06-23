--[[ Plugins needed early or by multiple other plugins ]]

local flatten = require('lib.functional').flatten_array

return flatten {
   require 'plugins.infrastructure.appearance',
   require 'plugins.infrastructure.mason',
   require 'plugins.infrastructure.telescope',
   require 'plugins.infrastructure.treesitter',
   require 'plugins.infrastructure.whichkey',
}
