--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Speed up start times, impatient must be 1st Lua module loaded.
if not pcall(require, 'impatient') then
  print('Warning: Plugin "impatient" not loaded ') 
end

require('grs')
