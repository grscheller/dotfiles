--[[ Configure plugins related to software development/refactoring ]]

return {
   -- GIT related
   require 'plugins.coding.gitsigns',
   -- Linting and Formatting
   require 'plugins.coding.conform',
   require 'plugins.coding.nvim_lint',
   -- Navigation
   require 'plugins.coding.nvim-lastplace',
   require 'plugins.coding.leap',
   -- Text visualization
   require 'plugins.coding.indent_blankline',
   require 'plugins.coding.colorizer',
   -- Text manipulation
   require 'plugins.coding.nvim-surround',
}
