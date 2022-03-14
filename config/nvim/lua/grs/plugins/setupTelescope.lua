--[[ Telescope - fuzzy finder over lists ]]

local ok, telescope, wk

ok, telescope = pcall(require, 'telescope')
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

--[[ Eetup keybindings ]]
ok, wk = pcall(require, 'which-key')
if not ok then return end

wk.register {
    t = {
	    name = '+Telescope',
        b = {":lua require('telescope.builtin').buffers()<CR>", 'Buffers'},
        f = {
            name = 'Telescope Find',
            f = {":lua require('telescope.builtin').find_files()<CR>", 'Find File'},
            z = {":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", 'Fuzzy Find Current Buffer'},
        },
        g = {
	        name = '+Telescope Grep',
            l = {":lua require('telescope.builtin').live_grep()<CR>", 'Live Grep'},
            s = {":lua require('telescope.builtin').grep_string()<CR>", 'Grep String'}
	    },
        r = {":lua require('telescope.builtin').oldfiles()<CR>", 'Open Recent File'},
        t = {
	        name = '+Telescope Tags',
            b = {":lua require('telescope.builtin').tags{only_current_buffer() = true}<CR>", 'Tags in Current Buffer'},
            h = {":lua require('telescope.builtin').help_tags()<CR>", 'Help Tags'},
            t = {":lua require('telescope.builtin').tags()<CR>", 'Tags'}
        }
    }
}
