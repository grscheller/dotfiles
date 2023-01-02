--[[ Manage project level settings ]]

local msg = require('grs.lib.Vim').msg_return_to_continue

local ok_conf, neoconf = pcall(require, 'neoconf')
local ok_dev, neodev = pcall(require, 'neodev')

if not ok_conf or not ok_dev then
   if not ok_conf then
      msg 'Warning: folke/neoconf.nvim setup failed.'
   end
   if not ok_dev then
      msg 'Warning: folke/neodev.nvim setup failed.'
   end
   return
end

-- Manage global & project level settings via JSON files
neoconf.setup {}
--
-- Setup for editting nvim configs & plugin development
neodev.setup {}
