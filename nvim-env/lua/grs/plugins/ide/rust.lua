--[[ Rust-Tools and  Configuration ]]

-- local autogrp = vim.api.nvim_create_augroup
-- local autocmd = vim.api.nvim_create_autocmd

-- local keymaps = require 'grs.config.keymaps'

-- local config_crates = function()
--    require('crates').setup {
--       null_ls = {
--          enabled = false,
--       },
--    }
-- end

-- local config_rust_tools = function()
--    local dap = require 'dap'
--    dap.configurations.rust = {
--       { type = 'rust', request = 'launch', name = 'rt_lldb' },
--    }
--    local rt = require('rust-tools')
--    rt.setup {
--       tools = {
--          runnables = { use_telescope = true },
--          inlay_hints = {
--             show_parameter_hints = true,
--             parameter_hints_prefix = '',
--             other_hints_prefix = '',
--          },
--       },
--       server = {
--          capabilities = vim.tbl_deep_extend('force',
--             vim.lsp.protocol.make_client_capabilities(),
--             require('cmp_nvim_lsp').default_capabilities()),
--          on_attach = function(client, bufnr)
--             if keymaps.set_lsp_keymaps(client, bufnr) then
--                keymaps.set_rust_keymaps(bufnr)
--                keymaps.set_dap_keymaps(bufnr)
--             end
-- 
--             -- show diagnostic popup when cursor lingers on line with errors
--             autocmd('CursorHold', {
--                buffer = bufnr,
--                callback = function()
--                   vim.diagnostic.open_float {
--                      bufnr = bufnr,
--                      scope = 'line',
--                      focusable = false,
--                   }
--                end,
--                group = autogrp('GrsRustTools', { clear = false }),
--                desc = 'Open floating diagnostic window for Rust-Tools',
--             })
--          end,
--       },
--    }
-- end

return {

   -- {
   --    -- Crates, neovim plugin to help manage crates.io dependencies.
   --    'saecki/crates.nvim',
   --    dependencies = {
   --       'hrsh7th/nvim-cmp',
   --    },
   --    event = { 'BufReadPre Cargo.toml', 'BufNewFile Cargo.toml' },
   --    config = config_crates,
   -- },

   {
      'mrcjkb/rustaceanvim',
      version = '^5', -- Recommended
      lazy = false,  -- This plugin is already lazy
   },

}
