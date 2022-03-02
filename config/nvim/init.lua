--[[ Neovim configuration ~/.config/nvim/init.lua ]]

--[[ Bootstrap Packer if not already installed ]]
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_src = 'https://github.com/wbthomason/packer.nvim'
local packerBootstrapped = nil
if vim.fn.empty(vim.fn.glob(install_path)) == 1 then
    packerBootstrapped = vim.fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        packer_src,
        install_path
    }
    print('Installing packer, close and reopen Neovim...')
end

require'myBehaviors'    -- Personnal Neovim tweaks
require'myPlugins'      -- Packer as the plugin manager

--[[ Automatically Sync Packer if just installed ]]
if packerBootstrapped then
    vim.cmd[[ :PackerSync ]]
    print('Packer installed.  Exit and restart Neovim...')
else
    require'myLSPsettings'  -- Language Server Protocol settings
    require'myKeybindings'  -- WhickKey to manage keybindings
end

