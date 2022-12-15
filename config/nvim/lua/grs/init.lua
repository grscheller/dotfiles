--[[ Flow of Neovim Configuration ]]

local libVim = require 'grs.lib.libVim'
local msg = libVim.msg_hit_return_to_continue
local version = libVim.nvim_version_str()

local tested_version = '0.8.1'
if version ~= tested_version then
   local message = string.format(
      'Untested nvim version: expected %s, got %s', tested_version, version
   )
   msg(message)
end

require 'grs.config.options' -- set options
require 'grs.util.packer'    -- plugin manager
require 'grs.theming'        -- colorscheme, statusline & zen-mode
require 'grs.textedit'       -- general text editing
require 'grs.devel'          -- LSP based software development environment
