--[[ Plugin manager and rocks for LuaRocks to load. ]]

return {
   {
      --[[ On initial install or update?) of luarocks.nvim, an automatic install
           "should" take place to "prepare" the plugin. If this fails,

           - ensure Lua5.1 is on the System PATH
             - `sudo apt install liblua5.1-0-dev lua5.1 lua5.1-doc`
             - `sudo pacman -Syu lua51` or `sudo pacman -Syu luajit`
           - ensure git and make are on System PATH
           - then either
             - From within nvim `:Lazy build luarocks.nvim
             - From Lazy GUI, navigate to luarocks.nvim ans `gb`
             - Outside nvim `nvim --cmd ':Lazy build luarocks.nvim' -c 'qa'`

           It appears luarocks.nvim plugin is transitioning from LuaRocks to Lux.
           Rocks are fetched from `https://nvim-neorocks.github.io/rocks-binaries/`
           and the fzy plugin is one of the few plugins there.
      ]]

      'vhyrro/luarocks.nvim',
      priority = 1500, -- Must be first thing loaded
      -- here would be where you could pin rock versions
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
