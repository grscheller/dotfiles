--[[ Neovim configuration ~/.config/nvim/init.lua ]]

require'myBehaviors'    -- Personnal Neovim tweaks

-- Bootstrap Packer if not already installed
local ok, _ = pcall(require, 'packer')
if not ok then
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    local packer_src = 'https://github.com/wbthomason/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        packerBootstrapped = vim.fn.system {
            'git',
            'clone',
            '--depth',
            '1',
            packer_src,
            install_path
        }
        print("Installing packer, close and reopen Neovim...")
        return
    end
else
    require'myPlugins'      -- Packer as the plugin manager
    require'myLSPsettings'  -- Language Server Protocol settings
    require'myKeybindings'  -- WhickKey to manage keybindings
end
