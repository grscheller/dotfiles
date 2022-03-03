--[[ Telescope - highly extendable fuzzy finder over lists ]]

local ok, telescope = pcall(require, 'telescope')
if ok then
    telescope.setup {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown { }
        }
    }
    telescope.load_extension('ui-select')
end
