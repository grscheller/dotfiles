--[[ Status line - configured with Kanagawa colorscheme ]]

local opts_for_kanagawa_colorscheme = function()
   local kanagawa_colors = require('kanagawa.colors').setup()
   local palette = kanagawa_colors.palette
   return {
      options = {
         icons_enabled = true,
         theme = {
            normal = {
               a = {
                  fg = palette.dragonBlack4,
                  bg = palette.autumnGreen,
                  gui = 'bold',
               },
               b = {
                  fg = palette.autumnGreen,
                  bg = palette.dragonBlack4,
               },
               c = {
                  fg = palette.fujiWhite,
                  bg = palette.dragonBlack4,
               },
            },
            visual = {
               a = {
                  fg = palette.dragonBlack4,
                  bg = palette.autumnYellow,
                  gui = 'bold',
               },
               b = {
                  fg = palette.autumnYellow,
                  bg = palette.waveBlue1,
               },
            },
            inactive = {
               a = {
                  fg = palette.fujiWhite,
                  bg = palette.waveBlue1,
                  gui = 'bold',
               },
               b = {
                  fg = palette.dragonBlack4,
                  bg = palette.crystalBlue,
               },
            },
            replace = {
               a = {
                  fg = palette.dragonBlack4,
                  bg = palette.oniViolet,
                  gui = 'bold',
               },
               b = {
                  fg = palette.oniViolet,
                  bg = palette.dragonBlack4,
               },
               c = {
                  fg = palette.fujiWhite,
                  bg = palette.dragonBlack4,
               },
            },
            insert = {
               a = {
                  fg = palette.dragonBlack4,
                  bg = palette.crystalBlue,
                  gui = 'bold',
               },
               b = {
                  fg = palette.crystalBlue,
                  bg = palette.dragonBlack4,
               },
               c = {
                  fg = palette.fujiWhite,
                  bg = palette.dragonBlack4,
               },
            },
            command = {
               a = {
                  fg = palette.dragonBlack4,
                  bg = palette.waveAqua1,
                  gui = 'bold',
               },
               b = {
                  fg = palette.waveAqua1,
                  bg = palette.dragonBlack4,
               },
               c = {
                  fg = palette.fujiWhite,
                  bg = palette.dragonBlack4,
               },
            },
         },
         component_separators = { left = '', right = '' },
         section_separators = { left = '', right = '' },
         disabled_filetypes = {
            statusline = { 'help' },
            winbar = {
               'dap-view',
               'dap-view-term',
               'dap-view-hover',
               'dap-view-help',
               'dap-repl',
            },
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
            {
               require('lazy.status').updates,
               cond = require('lazy.status').has_updates,
               color = { fg = palette.sakuraPink },
            },
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
   }
end

return {
   [1] = 'nvim-lualine/lualine.nvim',
   event = 'VeryLazy',
   dependencies = {
      'nvim-tree/nvim-web-devicons',
      'rebelot/kanagawa.nvim',
   },
   opts = opts_for_kanagawa_colorscheme,
}
