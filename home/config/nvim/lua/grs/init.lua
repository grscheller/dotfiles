--[[ Flow of Neovim Configuration ]]

local Vim = require 'grs.lib.Vim'

local msg = Vim.msg_hit_return_to_continue

local tested = '0.8.2'
local version = Vim.nvim_version_str()
if version ~= tested then
   local message = string.format(
      'Not current tested nvim version: expected %s, got %s', tested, version)
   msg(message)
end

require 'grs.conf.options' -- set options
require 'grs.conf.packer'  -- plugin manager
require 'grs.theming'      -- colorscheme, statusline & zen-mode
require 'grs.textedit'     -- general text editing
require 'grs.devel'        -- LSP based software development environment
