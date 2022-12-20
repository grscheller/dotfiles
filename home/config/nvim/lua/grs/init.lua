--[[ Flow of Neovim Configuration ]]

local Vim = require 'grs.lib.Vim'

local msg = Vim.msg_hit_return_to_continue

local tested_version = '0.8.1'
local version = Vim.nvim_version_str()
if version ~= tested_version then
   local message = string.format(
      'Untested nvim version: expected %s, got %s', tested_version, version)
   msg(message)
end

require 'grs.conf.options' -- set options
require 'grs.conf.packer'  -- plugin manager
require 'grs.theming'      -- colorscheme, statusline & zen-mode
require 'grs.textedit'     -- general text editing
require 'grs.devel'        -- LSP based software development environment
