--[[ Load globals & options before plugins. Load autocmds & keymaps later. ]]

local function load(mod)
   local Util = require('lazy.core.util')
   -- always load lazyvim, then user file
   Util.try(function()
         require(mod)
      end, {
	 msg = 'Failed loading ' .. mod,
         on_error = function(msg)
            local modpath = require('lazy.core.cache').find(mod)
            if modpath then
               Util.error(msg)
            end
         end,
      })
end

-- Load globals & options here, before lazy init, while sourcing plugin modules.
load 'grs.config.globals'
load 'grs.config.options'

-- autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd('User', {
   pattern = 'VeryLazy',
   callback = function()
      load 'grs.config.autocmds'
      load 'grs.config.keymaps'
   end,
})

return {}
