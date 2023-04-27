--[[ Colorschemes, also other plugins needing to be loaded early ]]

local grsColors = require('grs.config.colors')

return {

   -- Kanagawa colorscheme - with minor tweaks
   -- Needs to be loaded early to provide highlight groups to other pluggins
   {
      'rebelot/kanagawa.nvim',
      lazy = false,
      priority = 1000,
      config = function()
         local kanagawa = require('kanagawa')
         kanagawa.setup {
            compile = true,
            undercurl = true,
            colors = {
               theme = {
                  dragon = {
                     ui = {
                        bg_dim = grsColors.dragonBlack4,
                        bg_gutter = grsColors.dragonBlack1,
                        bg = grsColors.dragonBlack1,
                     },
                  },
               },
            },
            overrides = function(colors)
               return {
                  ColorColumn = { bg = colors.palette.dragonBlack3 },
               }
            end,
         }
         kanagawa.compile()
         kanagawa.load('dragon')
      end,
   },

   -- Replace vim.notify
   {
      'rcarriga/nvim-notify',
      lazy = false,
      priority = 900,
      opts = {},
      config = function()
         vim.notify = require 'notify'
      end,
   },

   -- Colorize color names, hexcodes, and other color formats
   {
      'norcalli/nvim-colorizer.lua',
      event = { 'BufReadPre', 'BufNewFile' },
      opts = {
         '*',
         css = { rgb_fn = true },
         html = { names = false },
      },
      keys = {
         { '<leader>C', '<cmd>ColorizerToggle<cr>', desc = 'toggle colorizer' },
      },
   },

   -- Lualine statusline
   {
      'nvim-lualine/lualine.nvim',
      dependencies = {
         'kyazdani42/nvim-web-devicons',
      },
      event = "VeryLazy",
      opts = {
         options = {
            icons_enabled = true,
            theme = {
               normal = {
                  a = { fg = grsColors.dragonBlack4, bg = grsColors.autumnGreen, gui = 'bold' },
                  b = { fg = grsColors.autumnGreen, bg = grsColors.dragonBlack4 },
                  c = { fg = grsColors.fujiWhite, bg = grsColors.dragonBlack4 },
               },
               visual = {
                  a = { fg = grsColors.dragonBlack4, bg = grsColors.autumnYellow, gui = 'bold' },
                  b = { fg = grsColors.autumnYellow, bg = grsColors.waveBlue1 },
               },
               inactive = {
                  a = { fg = grsColors.fujiWhite, bg = grsColors.waveBlue1, gui = 'bold' },
                  b = { fg = grsColors.dragonBlack4, bg = grsColors.crystalBlue },
               },
               replace = {
                  a = { fg = grsColors.dragonBlack4, bg = grsColors.oniViolet, gui = 'bold' },
                  b = { fg = grsColors.oniViolet, bg = grsColors.dragonBlack4 },
                  c = { fg = grsColors.fujiWhite, bg = grsColors.dragonBlack4 },
               },
               insert = {
                  a = { fg = grsColors.dragonBlack4, bg = grsColors.crystalBlue, gui = 'bold' },
                  b = { fg = grsColors.crystalBlue, bg = grsColors.dragonBlack4 },
                  c = { fg = grsColors.fujiWhite, bg = grsColors.dragonBlack4 },
               },
               command = {
                  a = { fg = grsColors.dragonBlack4, bg = grsColors.waveAqua1, gui = 'bold' },
                  b = { fg = grsColors.waveAqua1, bg = grsColors.dragonBlack4 },
                  c = { fg = grsColors.fujiWhite, bg = grsColors.dragonBlack4 },
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
            lualine_c = {
               {
                  'filename',
                  path = 1,
                  file_status = true,
                  newfile_status = true,
               },
            },
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
      },
   },

}
