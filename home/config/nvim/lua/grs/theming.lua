--[[ Setup colorizier, colorscheme & statusline ]]

local kb = vim.keymap.set

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
end

--[[
     Setup WebDevicons

     Needs a patched font like Noto Mono Nerd Font,
     see https://github.com/ryanoasis/nerd-fonts
--]]
ok, webDevicons = pcall(require, 'nvim-web-devicons')
if ok then
   webDevicons.setup { default = true }
end

-- Setup Lualine using Kanagawa theme
ok, lualine = pcall(require, 'lualine')
if ok then
   lualine.setup {
      options = {
         icons_enabled = true,
         theme = 'codedark',
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
end

--- Setup folke/twilight.nvim
ok, twilight = pcall(require, 'twilight')
if ok then
   twilight.setup { context = 20 }
   kb('n', 'zT', '<Cmd>Twilight<CR>', { desc = 'twilight toggle' })
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
   vim.cmd [[colorscheme darkblue]]
end
