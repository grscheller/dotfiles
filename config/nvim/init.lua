--[[ Neovim configuration ~/.config/nvim/init.lua ]]

-- Speed up start times, impatient must be 1st Lua module loaded.
if not pcall(require, 'impatient') then
  print('Warning: Plugin "impatient" not loaded ') 
end

-- Using "wbthomason/packer.nvim" as plug-in manager
require('grs.Packer')

-- Configure an IDE like Neovim software development environment
require('grs')
