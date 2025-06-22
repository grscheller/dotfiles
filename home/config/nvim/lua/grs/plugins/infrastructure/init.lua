--[[ Plugins needed early or by multiple other plugins ]]

local flatten = require('grs.lib.functional').flattenArray

return flatten {
   require 'grs.plugins.infrastructure.appearance',
   require 'grs.plugins.infrastructure.luarocks',
   require 'grs.plugins.infrastructure.mason',
   require 'grs.plugins.infrastructure.telescope',
   require 'grs.plugins.infrastructure.treesitter',
   require 'grs.plugins.infrastructure.whichkey',
}
