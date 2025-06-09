--[[ LSP support ]]

return {
   -- Give user feedback on LSP activity
   {
      'j-hui/fidget.nvim',
      tag = 'v1.6.1',
      event = 'VeryLazy',
      opts = {
         progress = {
            ignore_empty_message = true,
         },
      },
   },
}
