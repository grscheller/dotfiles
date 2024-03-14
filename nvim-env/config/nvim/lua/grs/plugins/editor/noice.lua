--[[ Noice.nvim, replaces UI for messages, cmdline & popupmenu ]]

return {

   {
      'folke/noice.nvim',
      event = 'VeryLazy',
      dependencies = {
         'MunifTanjim/nui.nvim',
         {
            'rcarriga/nvim-notify',
            dependencies= {
               'nvim-treesitter/nvim-treesitter',
            },
         },
      },
      opts = {
         lsp = {
            -- override markdown rendering so that cmp uses Treesitter
            override = {
               ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
               ['vim.lsp.util.stylize_markdown'] = true,
               ['cmp.entry.get_documentation'] = true,
            },
         },
         presets = {
            bottom_search = false,  -- use "classic" bottom cmdline for search
            command_palette = true,  -- position the cmdline & poppupmenu together
            long_message_to_split = true,  -- long messages sent to a split
            inc_rename = false,  -- enable input dialog for inc-rename.nvim
            lsp_doc_border = true,  -- add borders to hover docs & signature help
         },
         routes = {
            {
               view = 'split',
               filter = { event = 'msg_show', min_height = 20 },
            },
         },
      },
   },

}
