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
         local my_colors = { bg = '#090618' }
         local my_overrides = { ColorColumn = { bg = '#16161D' } }
         require('kanagawa').setup {
            colors = my_colors,
            overrides = my_overrides,
         }
         vim.cmd [[colorscheme kanagawa]]
      end,
   },

   -- Lualine statusline
   {
      'nvim-lualine/lualine.nvim',
      event = "VeryLazy",
      config = function()
         require('lualine').setup {
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
         }
      end,
   },

-- WebDevicons needs a patched font like Noto Mono Nerd Font,
-- see https://github.com/ryanoasis/nerd-fonts
   {
      'kyazdani42/nvim-web-devicons',
      config = function()
         require('nvim-web-devicons').setup {
            default = true
         }
      end,
   },

   -- Colorize color names, hexcodes, and other color formats
   {
      'norcalli/nvim-colorizer.lua',
      config = function()
         require('colorizer').setup {
            '*',
            '!vim',
            css = { rgb_fn = true },
            html = { names = false },
         }
      end,
   },

   -- Setup folke/twilight.nvim
   {
      'folke/twilight.nvim',
      config = function()
         require('twilight').setup {
            { context = 20 },
         }
         vim.keymap.set('n', 'zT', '<Cmd>Twilight<CR>',
            { desc = 'twilight toggle' })
      end,
      keys = {
         { 'zT', '<Cmd>Twilight<CR>', desc = 'twilight toggle' },
      },
   },

   -- Folke Zen Mode
   {
      'folke/zen-mode.nvim',
      config = function()
         require('zen-mode').setup {
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
               twilght = { enable = true },
            },
            on_open = function(win)
               vim.api.nvim_win_set_option(win, 'scrolloff', 10)
               vim.api.nvim_win_set_option(win, 'sidescrolloff', 8)
            end,
            on_close = function() end,
         }
      end,
      keys = {
         { 'zZ', '<Cmd>ZenMode<CR>', desc = 'zen-mode toggle' },
      },
   },

}
