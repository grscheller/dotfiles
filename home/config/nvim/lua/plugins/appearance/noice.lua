--[[  ]]

local noice_opts = {
   lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
         ['vim.lsp.util.stylize_markdown'] = true,
      },
   },
   presets = {
      bottom_search = false, -- use "classic" bottom cmdline for search
      command_palette = true, -- position the cmdline & popup menu together
      long_message_to_split = true, -- long messages sent to a split
      inc_rename = false, -- enable input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add borders to hover docs & signature help
   },
   routes = {
      {
         view = 'split',
         filter = { event = 'msg_show', min_height = 20 },
      },
   },
}

return {
   -- Puts the cmdline at eye level
   [1] = 'folke/noice.nvim',
   event = 'VeryLazy',
   dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
   },
   opts = noice_opts,
}
