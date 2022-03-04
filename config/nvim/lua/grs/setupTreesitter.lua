--[[ Treesitter - install language modules ]]

local ok, tsConfigs = pcall(require, 'nvim-treesitter.configs')
if ok then
    tsConfigs.setup {
        ensure_installed = 'maintained',
        highlight = {enable = true}
    }
else
    print('Problem loading nvim-treesittr.configs ' .. tsConfigs)
end
