--[[ Treesitter - install language modules ]]

local ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if ok then
    treesitter_configs.setup {
        ensure_installed = 'maintained',
        highlight = {enable = true}
    }
end
