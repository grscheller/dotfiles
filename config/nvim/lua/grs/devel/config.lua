--[[ Software Devel ??? ]]

--[[
     neoconf.nvim: Manage global & project level settings via JSON files.
     neodev.nvim: Setup for init.lua & plugin development, also setup
                  lua-language-server (sumneko_lua) via lspconfig.
--]]

local msg = require('grs.lib.libVim').msg_hit_return_to_continue

local ok_conf, neoconf = pcall(require, 'neoconf')
local ok_dev, neodev = pcall(require, 'neodev')

if not ok_conf or not ok_dev then
   if not ok_conf then msg 'Warning: Neoconf.nvim setup failed.' end
   if not ok_dev then msg 'Warning: Neodev.conf setup failed.' end
   return
end

neoconf.setup {}
neodev.setup {}
