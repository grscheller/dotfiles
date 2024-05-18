--[[ Configure plugins to make Neovim a better text editor ]]

local iFlatten = require('grs.lib.functional').iFlatten

return iFlatten {

   -- Nvim-web-devicons needs patched a font.
   -- See https://github.com/ryanoasis/nerd-fonts
   {
      'kyazdani42/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
      opts = {
         color_icons = true,
         default = true,
         strict = true,
      },
   },

   require 'grs.plugins.editor.colorscheme',
   -- require 'grs.plugins.editor.telescope',
   require 'grs.plugins.editor.textedit',
   -- require 'grs.plugins.editor.whichkey',
}
