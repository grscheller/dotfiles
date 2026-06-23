--[[ Provides eye-candy - used by nvim-notify and indirectly noice.nvim ]]

return {
   'nvim-tree/nvim-web-devicons',
   enabled = vim.g.have_nerd_font,
   opts = {
      color_icons = true,
      default = true,
      strict = true,
   },
}
