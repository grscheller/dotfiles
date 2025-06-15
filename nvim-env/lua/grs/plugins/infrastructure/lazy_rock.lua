--[[ Plugin manager and rocks for LuaRocks to load. ]]

return {
   { 'folke/lazy.nvim' }, -- Once bootstrapped, lazy.nvim will keep itself updated

-- {
--   'vhyrro/luarocks.nvim',
--   priority = 1500, -- Must be first thing loaded
--   opts = {
--     rocks = {
--       'plenary.nvim',
--       'mrcjkb/nvim-lastplace',
--       'nvim-web-devicons', -- configured in plugins.infrastructure.appearance
--     },
--     -- Use LuaRocks I manually installed
--     luarocks_build_args = { '--sysconfig' },
--   },
-- },
}
