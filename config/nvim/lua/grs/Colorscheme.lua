--[[ Setup colorizier, colorscheme & statusline ]]

--[[ Colorize hexcodes & names like #00dddd Blue Green ]]
local ok, colorizer = pcall(require, 'colorizer')
if ok then
  colorizer.setup(nil, { css= true; })
else
  print("Problem loading colorizer.")
end

--[[ Setup Tokyo Night colorscheme ]]
if pcall(require, 'tokyonight') then
  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_colors = {bg = "#0d0e13"}  -- default is "#1a1b26"
  vim.g.tokyonight_italic_functions = 1
  vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
  vim.cmd [[ colorscheme tokyonight ]]
else
  vim.cmd [[ colorscheme darkblue ]]
end

--[[ Provide icons and colorizes theme
     Needs a patched font like Noto Mono Nerd Font
     see https://github.com/ryanoasis/nerd-fonts  ]]
local ok, webDevicons = pcall(require, 'nvim-web-devicons')
if ok then
  webDevicons.setup { default = true }
else
  print('Problem loading nvim-web-devicons.')
end

--[[ Setup Lualine with Tokyo Night theme ]]
local ok, lualine = pcall(require, 'lualine')
if ok then
  lualine.setup {
    options = {
      icons_enabled = true,
      theme = 'tokyonight',
      component_separators = { left = ' ', right = ' ' },
      section_separators = { left = ' ', right = ' ' },
      disabled_filetypes = { },
      always_divide_middle = true
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' }}},
      lualine_c = { 'filename' },
      lualine_x = { 'filetype', 'encoding' },
      lualine_y = { 'location' },
      lualine_z = { 'progress' }
    },
    inactive_sections = {
      kualine_a = { },
      lualine_b = { },
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = { 'progress' },
      lualine_z = { }
    },
    tabline = { },
    extensions = { }
  }
else
  print('Problem loading lualine.')
end
