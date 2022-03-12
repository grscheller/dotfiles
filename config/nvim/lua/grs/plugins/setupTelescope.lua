--[[ Telescope - fuzzy finder over lists ]]

local ok, telescope = pcall(require, 'telescope')
if not ok then
    print('Problem loading telescope.')
    return
end

telescope.setup {
    ['ui-select'] = {
        require('telescope.themes').get_dropdown { }
    }
}
telescope.load_extension('ui-select')
