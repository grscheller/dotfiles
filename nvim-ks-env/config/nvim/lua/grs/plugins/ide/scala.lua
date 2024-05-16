--[[ Scala Metals Configuration ]]
--
-- The nvim-metals plugin directly configures the Neovim LSP client itself
-- and does not invoke nvim-lspconfig at all.  It also uses Coursier to
-- download & install the Scala Metals LSP server.
--
--    See: https://scalameta.org/metals/docs
--
--    Original setup based on:
--      https://github.com/scalameta/nvim-metals/discussions/39
--      https://github.com/scalameta/nvim-metals/discussions/279
--
local km = require 'grs.config.keymaps'

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local message
local info = vim.log.levels.INFO

return {

   {
      'scalameta/nvim-metals',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'mfussenegger/nvim-dap',
      },
      ft = { 'scala', 'sbt', 'java' },
      config = function()
         local metals = require 'metals'
         local metals_config = metals.bare_config()
         metals_config.settings = {
            serverVersion = 'latest.release',
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

         local grsMetalsGrp = autogrp('GrsMetals', { clear = true })

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
               group = grsMetalsGrp,
               desc = 'Open floating diagnostic window for Scala-Metals',
            })
         end

         autocmd('FileType', {
            pattern = { 'scala', 'sbt', 'java' },
            callback = function()
               metals.initialize_or_attach(metals_config)
               message = 'Scala Metals initialize or attached.'
               vim.notify(message, info)
            end,
            group = grsMetalsGrp,
         })
      end,
   },

}
