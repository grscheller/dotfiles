--[[ Colorschemes & other plugins needing to be loaded early ]]

local colors = require('grs.config.colors').tokyonight

return {

   -- Kanagawa colorscheme - with minor tweaks
   {
      'rebelot/kanagawa.nvim',
      lazy = false,
      priority = 1000,
      config = function()
         require('kanagawa').setup {
            colors = { bg = colors.bg },
            overrides = {
               ColorColumn = { bg = colors.ColorColumnBG },
            },
         }
         vim.cmd [[colorscheme kanagawa]]
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

   -- WebDevicons needs patched font,
   -- like Noto Mono Nerd Font,
   -- see https://github.com/ryanoasis/nerd-fonts
   {
      'kyazdani42/nvim-web-devicons',
      lazy = false,
      priority = 800,
      opts = {
         default = true
      },
   },

   -- Colorize color names, hexcodes, and other color formats
   {
      'norcalli/nvim-colorizer.lua',
      lazy = false,
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
                  a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
                  b = { fg = colors.green, bg = colors.bg },
                  c = { fg = colors.white, bg = colors.bg },
               },
               visual = {
                  a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
                  b = { fg = colors.yellow, bg = colors.gray },
               },
               inactive = {
                  a = { fg = colors.white, bg = colors.gray, gui = 'bold' },
                  b = { fg = colors.bg, bg = colors.blue },
               },
               replace = {
                  a = { fg = colors.bg, bg = colors.purple, gui = 'bold' },
                  b = { fg = colors.purple, bg = colors.bg },
                  c = { fg = colors.white, bg = colors.bg },
               },
               insert = {
                  a = { fg = colors.bg, bg = colors.blue, gui = 'bold' },
                  b = { fg = colors.blue, bg = colors.bg },
                  c = { fg = colors.white, bg = colors.bg },
               },
               command = {
                  a = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
                  b = { fg = colors.cyan, bg = colors.bg },
                  c = { fg = colors.white, bg = colors.bg },
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
