--[[zF Setup colorizier, colorscheme & statusline ]]

-- For Lualine, Kanagawa based colorscheme
local colors = {
   gray = '#33467C',
   magenta = '#957FB8',
   blue = '#7E9CD8',
   yellow = '#E0AF68',
   black = '#1F1F28',
   white = '#DCD7BA',
   green = '#76946A',
   cyan = '#7AA89F',
}

return {

   -- Kanagawa colorscheme - with minor tweaks
   {
      'rebelot/kanagawa.nvim',
      lazy = false,
      priority = 1000,
      config = function()
         require('kanagawa').setup {
            colors = { bg = '#090618' },
            overrides = { ColorColumn = { bg = '#16161D' } },
         }
         vim.cmd [[colorscheme kanagawa]]
      end,
   },

   -- Lualine statusline
   {
      'nvim-lualine/lualine.nvim',
      event = "VeryLazy",
      opts = {
         options = {
            icons_enabled = true,
            theme = {
               normal = {
                  a = { fg = colors.black, bg = colors.green, gui = 'bold' },
                  b = { fg = colors.green, bg = colors.black },
                  c = { fg = colors.white, bg = colors.black },
               },
               visual = {
                  a = { fg = colors.black, bg = colors.yellow, gui = 'bold' },
                  b = { fg = colors.yellow, bg = colors.gray },
               },
               inactive = {
                  a = { fg = colors.white, bg = colors.gray, gui = 'bold' },
                  b = { fg = colors.black, bg = colors.blue },
               },
               replace = {
                  a = { fg = colors.black, bg = colors.magenta, gui = 'bold' },
                  b = { fg = colors.magenta, bg = colors.black },
                  c = { fg = colors.white, bg = colors.black },
               },
               insert = {
                  a = { fg = colors.black, bg = colors.blue, gui = 'bold' },
                  b = { fg = colors.blue, bg = colors.black },
                  c = { fg = colors.white, bg = colors.black },
               },
               command = {
                  a = { fg = colors.black, bg = colors.cyan, gui = 'bold' },
                  b = { fg = colors.cyan, bg = colors.black },
                  c = { fg = colors.white, bg = colors.black },
               },
            },
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
               statusline = { 'help' },
               winbar = { 'help' },
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
         },
         sections = {
            lualine_a = { 'mode' },
            lualine_b = {
               'branch',
               'diff',
               {
                  'diagnostics',
                  sources = { 'nvim_diagnostic' },
               },
            },
            lualine_c = { 'filename' },
            lualine_x = {
               'encoding',
               'fileformat',
               'filetype',
            },
            lualine_y = { 'location' },
            lualine_z = { 'progress' },
         },
         tabline = {},
         winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'branch' },
            lualine_y = {},
            lualine_z = {},
         },
         inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'branch' },
            lualine_y = {},
            lualine_z = {},
         },
         extensions = {},
      },
   },

   -- WebDevicons needs patched font,
   -- like Noto Mono Nerd Font,
   -- see https://github.com/ryanoasis/nerd-fonts
   {
      'kyazdani42/nvim-web-devicons',
      opts = {
         default = true
      }
   },

}
