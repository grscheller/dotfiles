--[[ Configure plugins related to software development/refactoring ]]

return {
   -- Colorscheme and status line related
   require 'plugins.appearance.kanagawa',
   require 'plugins.appearance.lualine',
   -- Notification manager
   require 'plugins.appearance.notify',
   -- Plugin to replace messages, cmdline, and popup menus
   require 'plugins.appearance.noice',
   -- Nerd font icons
   require 'plugins.appearance.nvim-web-devicons'
}
