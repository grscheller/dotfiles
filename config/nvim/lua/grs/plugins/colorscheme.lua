--[[ Colorschemes, also other plugins needing to be loaded early ]]

local grs_colors = require('grs.config.colors')

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
            colors = {
               palette = {},
               theme = {
                  wave = {},
                  lotus = {},
                  dragon = {
                     ui = {
                        bg_dim = grs_colors.dragonBlack0,
                        bg_gutter = grs_colors.dragonBlack0,
                        bg = grs_colors.dragonBlack0,
                     },
                  },
                  all = {},
               },
            },
            overrides = function(colors)
               return {
                  ColorColumn = { bg = colors.palette.dragonBlack1 },
               }
            end,
         }
         kanagawa.load('dragon')
         kanagawa.compile()
      end,
   },

   -- WebDevicons needs patched font,
   -- like Noto Mono Nerd Font,
   -- see https://github.com/ryanoasis/nerd-fonts
   {
      'kyazdani42/nvim-web-devicons',
      lazy = false,
      priority = 900,
      opts = {
         default = true
      },
   },

   -- Replace vim.notify
   {
      'rcarriga/nvim-notify',
      lazy = false,
      priority = 800,
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
                  a = { fg = grs_colors.dragonBlack4, bg = grs_colors.autumnGreen, gui = 'bold' },
                  b = { fg = grs_colors.autumnGreen, bg = grs_colors.dragonBlack4 },
                  c = { fg = grs_colors.fujiWhite, bg = grs_colors.dragonBlack4 },
               },
               visual = {
                  a = { fg = grs_colors.dragonBlack4, bg = grs_colors.autumnYellow, gui = 'bold' },
                  b = { fg = grs_colors.autumnYellow, bg = grs_colors.waveBlue1 },
               },
               inactive = {
                  a = { fg = grs_colors.fujiWhite, bg = grs_colors.waveBlue1, gui = 'bold' },
                  b = { fg = grs_colors.dragonBlack4, bg = grs_colors.crystalBlue },
               },
               replace = {
                  a = { fg = grs_colors.dragonBlack4, bg = grs_colors.oniViolet, gui = 'bold' },
                  b = { fg = grs_colors.oniViolet, bg = grs_colors.dragonBlack4 },
                  c = { fg = grs_colors.fujiWhite, bg = grs_colors.dragonBlack4 },
               },
               insert = {
                  a = { fg = grs_colors.dragonBlack4, bg = grs_colors.crystalBlue, gui = 'bold' },
                  b = { fg = grs_colors.crystalBlue, bg = grs_colors.dragonBlack4 },
                  c = { fg = grs_colors.fujiWhite, bg = grs_colors.dragonBlack4 },
               },
               command = {
                  a = { fg = grs_colors.dragonBlack4, bg = grs_colors.waveAqua1, gui = 'bold' },
                  b = { fg = grs_colors.waveAqua1, bg = grs_colors.dragonBlack4 },
                  c = { fg = grs_colors.fujiWhite, bg = grs_colors.dragonBlack4 },
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

}
