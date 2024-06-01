--[[ Colorschemes, status line, and other visual configurations ]]

return {

   {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      event = 'VeryLazy',
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
      end
   },

   {
      'folke/noice.nvim',
      event = 'VeryLazy',
      dependencies = {
         'MunifTanjim/nui.nvim',
         {
            'rcarriga/nvim-notify',
            dependencies= {
               'nvim-treesitter/nvim-treesitter',
            },
         },
      },
      opts = {
         lsp = {
            -- override markdown rendering so that cmp uses Treesitter
            override = {
               ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
               ['vim.lsp.util.stylize_markdown'] = true,
               ['cmp.entry.get_documentation'] = true,
            },
         },
         presets = {
            bottom_search = false,  -- use "classic" bottom cmdline for search
            command_palette = true,  -- position the cmdline & poppupmenu together
            long_message_to_split = true,  -- long messages sent to a split
            inc_rename = false,  -- enable input dialog for inc-rename.nvim
            lsp_doc_border = true,  -- add borders to hover docs & signature help
         },
         routes = {
            {
               view = 'split',
               filter = { event = 'msg_show', min_height = 20 },
            },
         },
      },
   },

   -- Folke Zen Mode
   {
      'folke/zen-mode.nvim',
      dependencies = {
         'folke/twilight.nvim',
      },
      keys = {
         { '<leader>tz', '<cmd>ZenMode<cr>', desc = 'toggle zen-mode' },
      },
      opts = {
         window = {
            backdrop = 1.0, -- shade backdrop, 1 to keep normal
            width = 0.85, -- abs num of cells when > 1, % of width when <= 1
            height = 1, -- abs num of cells when > 1, % of height when <= 1
            options = {
               number = false,
               relativenumber = false,
               colorcolumn = '',
            },
         },
         plugins = {
            options = {},
            twilight = { enable = true },
         },
         on_open = function(win)
            vim.api.nvim_set_option_value('scrolloff', 10, { win = win })
            vim.api.nvim_set_option_value('sidescrolloff', 8, { win = win })
         end,
         on_close = function() end,
      },
   },

}
