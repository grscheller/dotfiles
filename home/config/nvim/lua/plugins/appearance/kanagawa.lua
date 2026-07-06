--[[ Kanagawa colorscheme - with minor tweaks ]]

local kanagawa_opts = {
   compile = true,
   undercurl = true,
   colors = {
      theme = {
         dragon = {
            ui = {
               bg_dim = '#282727', -- dragonBlack4
               bg_gutter = '#12120f', -- dragonBlack1
               bg = '#12120f', -- dragonBlack1
            },
         },
      },
   },
   overrides = function(colors) -- add/modify highlights
      return {
         ColorColumn = { bg = colors.palette.dragonBlack3 },
      }
   end,
}

return {
   [1] = 'rebelot/kanagawa.nvim',
   priority = 1000,
   config = function()
      local kanagawa = require 'kanagawa'
      kanagawa.setup(kanagawa_opts)
      kanagawa.compile()
      kanagawa.load 'dragon'
   end,
}
