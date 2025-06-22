--[[ Colorschemes, status line, and other visual configurations ]]

local kanagawa_opts = {
   compile = true,
   undercurl = true,
   colors = {
      theme = {
         dragon = {
            ui = {
               bg_dim = '#282727', -- dragonBlack4
               bg_gutter = '#12120f', -- dragonBlack1
               bg = '#12120f', -- dragonBlack1
            },
         },
      },
   },
   overrides = function(colors) -- add/modify highlights
      return {
         ColorColumn = { bg = colors.palette.dragonBlack3 },
      }
   end,
}

local noice_opts = {
   lsp = {
     -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
     override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
     },
   },
   presets = {
      bottom_search = false, -- use "classic" bottom cmdline for search
      command_palette = true, -- position the cmdline & popup menu together
      long_message_to_split = true, -- long messages sent to a split
      inc_rename = true, -- enable input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add borders to hover docs & signature help
   },
   routes = {
      {
         view = 'split',
         filter = { event = 'msg_show', min_height = 20 },
      },
   },
}

return {
   {
      -- Kanagawa colorscheme - with minor tweaks, needs to be loaded early to provide
      -- highlight groups to other plugins. First thing loaded after vhyrro/luarocks.nvim.
      'rebelot/kanagawa.nvim',
      priority = 1000,
      config = function()
         local kanagawa = require 'kanagawa'
         require('kanagawa').setup(kanagawa_opts)
         kanagawa.setup(kanagawa_opts)
         kanagawa.compile()
         kanagawa.load 'dragon'
      end,
   },

   {
      -- Hijack vim.notify
      'rcarriga/nvim-notify',
      priority = 900,
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
         vim.notify = require("notify")
      end,
   },

   {
      -- Provides eye-candy
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
      opts = {
         color_icons = true,
         default = true,
         strict = true,
      },
   },

   {
      -- Puts the cmdline at eye level
      'folke/noice.nvim',
      event = 'VeryLazy',
      dependencies = {
         'MunifTanjim/nui.nvim',
         'rcarriga/nvim-notify',
         "smjonas/inc-rename.nvim",
      },
      opts = noice_opts,
   },

   {
      -- replace vim status line with something with more eye candy
      'nvim-lualine/lualine.nvim',
      event = 'VeryLazy',
      dependencies = {
         'nvim-tree/nvim-web-devicons',
         'rebelot/kanagawa.nvim',
      },
      opts = function()
         local kanagawa_colors = require('kanagawa.colors').setup()
         local palette = kanagawa_colors.palette
         return {
            options = {
               icons_enabled = true,
               theme = {
                  normal = {
                     a = { fg = palette.dragonBlack4, bg = palette.autumnGreen, gui = 'bold' },
                     b = { fg = palette.autumnGreen, bg = palette.dragonBlack4 },
                     c = { fg = palette.fujiWhite, bg = palette.dragonBlack4 },
                  },
                  visual = {
                     a = { fg = palette.dragonBlack4, bg = palette.autumnYellow, gui = 'bold' },
                     b = { fg = palette.autumnYellow, bg = palette.waveBlue1 },
                  },
                  inactive = {
                     a = { fg = palette.fujiWhite, bg = palette.waveBlue1, gui = 'bold' },
                     b = { fg = palette.dragonBlack4, bg = palette.crystalBlue },
                  },
                  replace = {
                     a = { fg = palette.dragonBlack4, bg = palette.oniViolet, gui = 'bold' },
                     b = { fg = palette.oniViolet, bg = palette.dragonBlack4 },
                     c = { fg = palette.fujiWhite, bg = palette.dragonBlack4 },
                  },
                  insert = {
                     a = { fg = palette.dragonBlack4, bg = palette.crystalBlue, gui = 'bold' },
                     b = { fg = palette.crystalBlue, bg = palette.dragonBlack4 },
                     c = { fg = palette.fujiWhite, bg = palette.dragonBlack4 },
                  },
                  command = {
                     a = { fg = palette.dragonBlack4, bg = palette.waveAqua1, gui = 'bold' },
                     b = { fg = palette.waveAqua1, bg = palette.dragonBlack4 },
                     c = { fg = palette.fujiWhite, bg = palette.dragonBlack4 },
                  },
               },
               component_separators = { left = '', right = '' },
               section_separators = { left = '', right = '' },
               disabled_filetypes = {
                  statusline = { 'help' },
                  winbar = {},
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
      end,
   },
}
