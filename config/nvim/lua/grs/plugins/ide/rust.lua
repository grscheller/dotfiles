--[[ Rust-Tools and  Configuration ]]
-- Rust-Tools itself directly configures rust-analyzer with nvim-lspconfig 
--
--    Original setup based on:
--      https://github.com/simrat39/rust-tools.nvim
--      https://github.com/sharksforarms/neovim-rust
--
-- Todo: see https://davelage.com/posts/nvim-dap-getting-started/
--       and :help dap-widgets
--       

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local km = require 'grs.config.keymaps'

return {

   -- Crates, a neovim plugin that helps managing crates.io dependencies.
   {
      'saecki/crates.nvim',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'hrsh7th/nvim-cmp',
         'jose-elias-alvarez/null-ls.nvim',
      },
      event = { 'BufRead Cargo.toml', 'BufNewFile Cargo.toml' },
      config = function()
         require('crates').setup {
            null_ls = {
               enabled = true,
            },
         }
      end,
   },


   {
      'simrat39/rust-tools.nvim',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'hrsh7th/cmp-nvim-lsp',
         'mfussenegger/nvim-dap',
         'neovim/nvim-lspconfig',
      },
      ft = { 'rust' },
      init = function()
         autogrp('GrsRustTools', { clear = true })
      end,
      config = function()
         local dap = require 'dap'
         local dap_ui_widgets = require 'dap.ui.widgets'
         dap.configurations.rust = {
            { type = 'rust', request = 'launch', name = 'rt_lldb' },
         }
         local rt = require('rust-tools')
         rt.setup {
            tools = {
               runnables = { use_telescope = true },
               inlay_hints = {
                  show_parameter_hints = false,
                  parameter_hints_prefix = '',
                  other_hints_prefix = '',
               },
            },
            -- The server table contains nvim-lspconfig opts
            -- overriding the defaults set by rust-tools.nvim.
            server = {
               capabilities = require('cmp_nvim_lsp').default_capabilities(),
               on_attach = function(_, bufnr)
                  -- set up keymaps
                  km.lsp(bufnr)
                  km.rust(bufnr, rt)
                  km.dap(bufnr, dap, dap_ui_widgets)

                  -- show diagnostic popup when cursor lingers on line with errors
                  autocmd('CursorHold', {
                     buffer = bufnr,
                     callback = function()
                        vim.diagnostic.open_float {
                           bufnr = bufnr,
                           scope = 'line',
                           focusable = false,
                        }
                     end,
                     group = autogrp('GrsRustTools', { clear = false }),
                     desc = 'Open floating diagnostic window for Rust-Tools',
                  })
               end,
            },
         }
      end
   },

}
