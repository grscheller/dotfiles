--[[ Scala Metals Configuration ]]
--
-- Scala Metals directly configures the Neovim LSP client itself
-- and does not involke nvim-lspconfig at all.
--
--    Latest Metals Server: https://scalameta.org/metals/docs
--
--    Original setup based on:
--      https://github.com/scalameta/nvim-metals/discussions/39
--      https://github.com/scalameta/nvim-metals/discussions/279
--
-- TODO: Figure out why LSP completions are not working.
--
local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local km = require 'grs.config.keymaps'
local masonConf = require 'grs.config.masonConf'
local m = masonConf.MasonEnum

return {
   {
      'scalameta/nvim-metals',
      dependencies = {
         'nvim-lua/plenary.nvim',
         'hrsh7th/cmp-nvim-lsp',
         'mfussenegger/nvim-dap',
         'j-hui/fidget.nvim', -- metals currently does not send out progress notifications
      },
      enabled = masonConf.LspTbl.system.scala_metals == m.man,
      -- Have not yet decided whether to use Metals for pure Java projects. For
      -- now trigger for just Scala & SBT.  Once triggered, Metals will take
      -- control over Java code too.  This is for mixed Scala/Java projects.
      ft = { 'scala', 'sbt' },
      config = function()
         autogrp('GrsMetals', { clear = true })
         local metals = require 'metals'
         local metals_config = metals.bare_config()
         metals_config.settings = {
            showImplicitArguments = true,
            showImplicitConversionsAndClasses = true,
            excludedPackages = {
               'akka.actor.typed.javadsl',
               'com.github.swagger.akka.javadsl',
            },
         }
         -- TODO: find something to hook this, not necessarily the status bar
         metals_config.init_options.statusBarProvider = 'on'

         local dap = require 'dap'
         local dap_ui_widgets = require 'dap.ui.widgets'
         dap.configurations.scala = {
            {
               type = 'scala',
               request = 'launch',
               name = 'RunOrTest',
               metals = {
                  runType = 'runOrTestFile',
                  --args = { 'firstArg', 'secondArg, ...' }
               },
            },
            {
               type = 'scala',
               request = 'launch',
               name = 'Test Target',
               metals = {
                  runType = 'testTarget',
               },
            },
         }

         metals_config.on_attach = function(_, bufnr)
            metals.setup_dap()

            km.lsp(bufnr)
            km.metals(bufnr, metals)
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
               group = autogrp('GrsMetals', { clear = false }),
               desc = 'Open floating diagnostic window for Scala-Metals',
            })
         end

         -- Seems that Metals does not directly take an on_attach event.
         autocmd('FileType', {
            pattern = { 'scala', 'sbt', 'java' },
            callback = function()
               metals.initialize_or_attach(metals_config)
               vim.notify('Scala Metals initialize or attached.')
            end,
            group = autogrp('GrsMetals', { clear = false }),
         })
         -- The above autocmd cannot be defined until metals_config has been
         -- fully built. I verified that it indeed fires even for the first
         -- scala/sbt file edited.  Otherwise, InsertEnter & CmdlineEnter events
         -- which will trigger completions without full LSP support.
      end,
   },

}