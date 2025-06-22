--[[ Configure plugins making Neovim a full IDE ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {
   require 'grs.plugins.ide.ide',
}
