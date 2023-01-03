--[[ Setup colorizier, colorscheme & statusline ]]

local kb = require('grs.config.keybindings').kb
local msg = require('grs.lib.Vim').msg_return_to_continue

local ok, kanagawa, lualine, twilight, zen, webDevicons, colorizer

--[[
     Setup Kanagawa colorscheme

     A colorschemen inspired by TokyoNight,
     Gruvbox, and the artwork of Kanagawa.
--]]
ok, kanagawa = pcall(require, 'kanagawa')
if ok then
   local my_colors = { bg = '#090618' }
   local my_overrides = { ColorColumn = { bg = '#16161D' } }
   kanagawa.setup {
      colors = my_colors,
      overrides = my_overrides,
   }
   vim.cmd [[colorscheme kanagawa]]
else
   vim.cmd [[colorscheme elflord]]
end

-- Setup Lualine with Kanagawa theme based colors
ok, lualine = pcall(require, 'lualine')
if ok then
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

   lualine.setup {
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
else
   msg 'Problem in theming.lua: lualine failed to load'
end

--- Setup folke/twilight.nvim
ok, twilight = pcall(require, 'twilight')
if ok then
   twilight.setup { context = 20 }
   kb('n', 'zT', '<Cmd>Twilight<CR>', { desc = 'twilight toggle' })
else
   msg 'Problem in theming.lua: twilight failed to load'
end

-- Setup folke/zen-mode.nvim
ok, zen = pcall(require, 'zen-mode')
if ok then
   zen.setup {
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
   kb('n', 'zZ', '<Cmd>ZenMode<CR>', { desc = 'zen-mode toggle' })
else
   msg 'Problem in theming.lua: zen-mode failed to load'
end

--[[
     WebDevicons needs a patched font like Noto Mono Nerd Font.
        see https://github.com/ryanoasis/nerd-fonts
--]]
ok, webDevicons = pcall(require, 'nvim-web-devicons')
if ok then
   webDevicons.setup { default = true }
else
   msg 'Problem in theming.lua: nvim-web-devicons failed to load'
end

-- Colorize color names, hexcodes, and other color formats
ok, colorizer = pcall(require, 'colorizer')
if ok then
   colorizer.setup {
      '*',
      '!vim',
      css = { rgb_fn = true },
      html = { names = false },
   }
else
   msg 'Problem in theming.lua, colorizer failed to load'
end
