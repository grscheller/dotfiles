--[[ LSP support ]]

return {
   -- Give user feedback on LSP activity
   {
      'j-hui/fidget.nvim',
      event = 'LspAttach',
      opts = {
         progress = {
            ignore_empty_message = true,
         },
      },
   },
}
