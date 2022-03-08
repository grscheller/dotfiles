--[[ Setup Tokyo Night colorscheme ]]
if pcall(require, 'tokyonight') then
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_colors = {bg = "#000000"}
    vim.g.tokyonight_italic_functions = 1
    vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
    vim.cmd[[colorscheme tokyonight]]
else
    vim.cmd[[colorscheme darkblue]]
end
