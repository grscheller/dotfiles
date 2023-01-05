--[[ Check if nvim version is same as one currently tested against ]]

local Vim = require 'grs.lib.Vim'

local tested = '0.8.2'
local version = Vim.nvim_version_str()
if version ~= tested then
   local message = string.format('Neovim version %s, currently testing on %s', version, tested)
   Vim.msg_return_to_continue(message)
end
