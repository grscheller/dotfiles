--[[ Setup Tokyo Night colorscheme ]]
if pcall(require, 'tokyonight') then
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_colors = {bg = "#0d0e13"}  -- default is "#1a1b26"
    vim.g.tokyonight_italic_functions = 1
    vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
    vim.cmd[[colorscheme tokyonight]]
else
    vim.cmd[[colorscheme darkblue]]
end
