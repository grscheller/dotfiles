--[[ Plugin manager and rocks for LuaRocks to load. ]]

return {
   { 'folke/lazy.nvim' }, -- Once bootstrapped, lazy.nvim will keep itself updated

   {
      -- it appears lazy.nvim and luarocks.nvim are transitioning from LuaRocks to Lux
      -- rocks are fetched from `https://nvim-neorocks.github.io/rocks-binaries/`
      -- the fzy plugin is one of the few plugins there
      'vhyrro/luarocks.nvim',
      priority = 1500, -- Must be first thing loaded
      -- here would be where you pin rock versions
      opts = {
         rocks = {
            'fzy',
         },
      },
      -- opts = {
      --    rocks = {
      --       'plenary.nvim',
      --       'nvim-lastplace',
      --       'nvim-web-devicons',
      --    },
      -- },
      config = true,
   },
}
