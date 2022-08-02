--[[ Setup colorizier, colorscheme & statusline ]]

local setKM = require('grs.util.keymappings').setKM

local ok, colorizer, webDevicons, lualine, twilight, zen

-- Colorize color names, hexcodes, and other color formats
ok, colorizer = pcall(require, 'colorizer')
if ok then
   colorizer.setup(nil, { css = true; })
else
   print('Problem loading colorizer: ' .. colorizer)
end

-- Setup & tweak Tokyo Night colorscheme
if pcall(require, 'tokyonight') then
   vim.g.tokyonight_style = 'night'
   vim.g.tokyonight_colors = {
      bg_dark = '#000000',
      bg = '#0c010a',
      bg_highlight = '#12141d',
      comment = '#818ecd',
      cyan = '#0cb4c0'
   }
   vim.g.tokyonight_italic_functions = 1
   vim.cmd [[colorscheme tokyonight]]
else
   vim.cmd [[colorscheme darkblue]]
end

-- Setup WebDevicons
   -- Needs a patched font like Noto Mono Nerd Font
   -- see https://github.com/ryanoasis/nerd-fonts
ok, webDevicons = pcall(require, 'nvim-web-devicons')
if ok then
   webDevicons.setup { default = true }
else
   print('Problem loading nvim-web-devicons: ' .. webDevicons)
end

-- Setup Lualine with Tokyo Night theme
ok, lualine = pcall(require, 'lualine')
if ok then
   lualine.setup {
      options = {
         icons_enabled = true,
         theme = 'tokyonight',
         component_separators = { left = ' ', right = ' ' },
         section_separators = { left = ' ', right = ' ' },
         disabled_filetypes = {},
         always_divide_middle = true,
         globalstatus = true
      },
      sections = {
         lualine_a = { 'mode' },
         lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
         lualine_c = { 'filename' },
         lualine_x = { 'filetype', 'encoding' },
         lualine_y = { 'location' },
         lualine_z = { 'progress' }
      },
      inactive_sections = {
         kualine_a = {},
         lualine_b = {},
         lualine_c = { 'filename' },
         lualine_x = { 'location' },
         lualine_y = { 'progress' },
         lualine_z = {}
      },
      tabline = {},
      extensions = {}
   }
else
   print('Problem loading lualine: ' .. lualine)
end

--- Setup folke/twilight.nvim
ok, twilight = pcall(require, 'twilight')
if ok then
   twilight.setup {
      context = 20
   }
else
   print('Problem loading twilight: ' .. twilight)
end

-- Setup folke/zen-mode.nvim
ok, zen = pcall(require, 'zen-mode')
if ok then
   zen.setup {
      window = {
         backdrop = 0.4, -- shade backdrop, 1 to keep normal
         width = 0.85, -- abs num of cells when > 1, % of width when <= 1
         height = 1, -- abs num of cells when > 1, % of height when <= 1
         options = {} -- by default, not options are changed
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
   setKM('n', 'zen-mode toggle', 'zZ', '<Cmd>ZenMode<CR>')
   setKM('n', 'twilight toggle', 'zT', '<Cmd>Twilight<CR>')
else
   print('Problem loading zen-mode: ' .. zen)
end
