return {
   -- Colorize color names, hexcodes,
   -- and other color formats.
   [1] = 'norcalli/nvim-colorizer.lua',
   keys = {
      {
         [1] = '<leader>C',
         [2] = '<cmd>ColorizerToggle<cr>',
         desc = 'toggle colorizer',
      },
   },
   opts = {
      [1] = '*',
      RRGGBBAA = true,
      rgb_fn = true,
      hsb_fn = true,
      css = { names = false },
      html = { names = false },
      mode = 'background',
   },
}
