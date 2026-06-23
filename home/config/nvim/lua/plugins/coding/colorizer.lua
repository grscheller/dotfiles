return {
   -- Colorize color names, hexcodes,
   -- and other color formats.
   'norcalli/nvim-colorizer.lua',
   keys = {
      {
         '<leader>C',
         '<cmd>ColorizerToggle<cr>',
         desc = 'toggle colorizer',
      },
   },
   opts = {
      '*',
      RRGGBBAA = true,
      rgb_fn = true,
      hsb_fn = true,
      css = { names = false },
      html = { names = false },
      mode = 'background',
   },
}
