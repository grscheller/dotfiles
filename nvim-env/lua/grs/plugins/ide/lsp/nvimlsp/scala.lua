--[[ Scala Metals Configuration

     The nvim-metals plugin directly configures the Neovim LSP client itself
     and does not invoke nvim-lspconfig at all. It also uses Coursier to
     download & install the Scala Metals LSP server.

        See: https://scalameta.org/metals/docs

        Original setup based on
          https://github.com/scalameta/nvim-metals/discussions/39
        and
          https://github.com/scalameta/nvim-metals/discussions/279
        is out-of-date and broken. It predates managing a local Scala development
        environment with Coursier.
--]]

local km = require 'grs.config.keymaps_which_key'

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local message
local info = vim.log.levels.INFO

local config_metals = function()
   local metals = require 'metals'
   local metals_config = metals.bare_config()
   metals_config.settings = {
      serverVersion = 'SNAPSHOT',
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      excludedPackages = {
         'akka.actor.typed.javadsl',
         'com.github.swagger.akka.javadsl',
      },
   }
   metals_config.init_options.statusBarProvider = 'off'

   local dap = require 'dap'
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

   metals_config.on_attach = function(client, bufnr)
      metals.setup_dap()

      if km.set_lsp_keymaps(client, bufnr) then
         km.set_metals_keymaps(bufnr)
         km.set_dap_keymaps(bufnr)

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
end

return {
   {
      'scalameta/nvim-metals',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'mfussenegger/nvim-dap',
      },
      ft = { 'scala', 'sbt', 'java' },
      config = config_metals,
   },
}
