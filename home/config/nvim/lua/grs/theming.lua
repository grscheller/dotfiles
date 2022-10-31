--[[ Setup colorizier, colorscheme & statusline ]]

local kb = vim.keymap.set
local msg = require('grs.util.utils').msg_hit_return_to_continue

local ok, colorizer, webDevicons, lualine, twilight, zen, kanagawa

-- Colorize color names, hexcodes, and other color formats
ok, colorizer = pcall(require, 'colorizer')
if ok then
   colorizer.setup {
      '*',
      '!vim',
      css = { rgb_fn = true },
      html = { names = false }
   }
else
   msg('Problem in theming.lua: colorizer failed to load')
end

--[[
     Setup WebDevicons

     Needs a patched font like Noto Mono Nerd Font,
     see https://github.com/ryanoasis/nerd-fonts
--]]
ok, webDevicons = pcall(require, 'nvim-web-devicons')
if ok then
   webDevicons.setup { default = true }
else
   msg('Problem in theming.lua: nvim-web-devicons failed to load')
end

-- Setup Lualine using Kanagawa theme
ok, lualine = pcall(require, 'lualine')
if ok then
   local colors = {
      gray     = '#3C3C3C',
      lightred = '#D16969',
      blue     = '#569CD6',
      pink     = '#C586C0',
      black    = '#262626',
      white    = '#D4D4D4',
      green    = '#608B4E',
   }
   lualine.setup {
      options = {
         icons_enabled = true,
         theme = {
            normal = {
               b = { fg = colors.green, bg = colors.black },
               a = { fg = colors.black, bg = colors.green, gui = 'bold' },
               c = { fg = colors.white, bg = colors.black }
            },
            visual = {
               b = { fg = colors.pink, bg = colors.black },
               a = { fg = colors.black, bg = colors.gray, gui = 'bold' },
            },
            inactive = {
               b = { fg = colors.black, bg = colors.blue },
               a = { fg = colors.white, bg = colors.gray, gui = 'bold' },
            },
            replace = {
               b = { fg = colors.lightred, bg = colors.black },
               a = { fg = colors.black, bg = colors.lightred, gui = 'bold' },
               c = { fg = colors.white, bg = colors.black }
            },
            insert = {
               b = { fg = colors.blue, bg = colors.black },
               a = { fg = colors.black, bg = colors.blue, gui = 'bold' },
               c = { fg = colors.white, bg = colors.black }
            }
         },
         component_separators = { left = '', right = '' },
         section_separators = { left = '', right = '' },
         disabled_filetypes = {
            statusline = { 'help' },
            winbar = { 'help' }
         },
         ignore_focus = {},
         always_divide_middle = true,
         globalstatus = true
      },
      sections = {
         lualine_a = { 'mode' },
         lualine_b = {
            'branch',
            'diff',
            {
               'diagnostics',
               sources = { 'nvim_diagnostic' }
            }
         },
         lualine_c = {'filename'},
         lualine_x = {
            'encoding',
            'fileformat',
            'filetype'
         },
         lualine_y = { 'location' },
         lualine_z = { 'progress' }
      },
      tabline = {},
      winbar = {
         lualine_a = {},
         lualine_b = {},
         lualine_c = { 'filename' },
         lualine_x = { 'branch' },
         lualine_y = {},
         lualine_z = {}
      },
      inactive_winbar = {
         lualine_a = {},
         lualine_b = {},
         lualine_c = { 'filename' },
         lualine_x = { 'branch' },
         lualine_y = {},
         lualine_z = {}
      },
      extensions = {}
   }
else
   msg('Problem in theming.lua: lualine failed to load')
end

--- Setup folke/twilight.nvim
ok, twilight = pcall(require, 'twilight')
if ok then
   twilight.setup { context = 20 }
   kb('n', 'zT', '<Cmd>Twilight<CR>', { desc = 'twilight toggle' })
else
   msg('Problem in theming.lua: twilight failed to load')
end

-- Setup folke/zen-mode.nvim
ok, zen = pcall(require, 'zen-mode')
if ok then
   zen.setup {
      window = {
         backdrop = 0.4, -- shade backdrop, 1 to keep normal
         width = 0.85, -- abs num of cells when > 1, % of width when <= 1
         height = 1, -- abs num of cells when > 1, % of height when <= 1
         options = {
            number = false,
            relativenumber = false
         }
      },
      plugins = {
         options = {},
         twilght = { enable = true }
      },
      on_open = function(win)
         vim.api.nvim_win_set_option(win, 'scrolloff', 10)
         vim.api.nvim_win_set_option(win, 'sidescrolloff', 8)
      end,
      on_close = function()
      end
   }
   kb('n', 'zZ', '<Cmd>ZenMode<CR>', { desc = 'zen-mode toggle' })
else
   msg('Problem in theming.lua: zen-mode failed to load')
end

--[[
     Setup Kanagawa colorscheme

     A colorschemen inspired by TokyoNight,
     Gruvbox, and the painting by Kanagawa.
--]]
ok, kanagawa = pcall(require, 'kanagawa')
if ok then
   local my_colors = {
      bg = '#090618'
   }
   kanagawa.setup { colors = my_colors }
   vim.cmd [[colorscheme kanagawa]]
else
   vim.cmd [[colorscheme elflord]]
end
