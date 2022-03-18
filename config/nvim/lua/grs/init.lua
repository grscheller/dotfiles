--[[ Plugin configuration ]]

-- Speed up start times, impatient must be 1st plugin loaded
if not pcall(require, 'impatient') then
  print('Warning: Plugin "impatient" not loaded') 
end
require('grs.Packer')       -- Setup plugin manager
require('grs.WhichKey')     -- Setup keybinding tool, define bindings elsewhere
require('grs.Colorscheme')  -- Colorscheme & statusline
require('grs.Treesitter')   -- Install language modules for built in treesitter
require('grs.Telescope')    -- Configure telescope, an extendable fuzzy finder
require('grs.Cmp')          -- Setup completions & snippets
require('grs.DevEnv')       -- Development environment and LSP setup
