--[[ Colorschemes, status line, and other visual configurations ]]

return {

   -- Kanagawa colorscheme - with minor tweaks, needs to be loaded early to
   -- provide highlight groups to other plugins.
   {
      'rebelot/kanagawa.nvim',
      lazy = false,
      priority = 1000,
      opts = {
         compile = true,
         undercurl = true,
         colors = {
            theme = {
               dragon = {
                  ui = {
                     bg_dim = '#282727',     -- dragonBlack4
                     bg_gutter = '#12120f',  -- dragonBlack1
                     bg = '#12120f',         -- dragonBlack1
                  },
               },
            },
         },
         overrides = function(colors)  -- add/modify highlights
            return {
               ColorColumn = { bg = colors.palette.dragonBlack3 },
            }
         end,
      },
      config = function(_, opts)
         local kanagawa = require 'kanagawa'
         kanagawa.setup(opts)
         kanagawa.compile()
         kanagawa.load('dragon')
      end
   },


}
