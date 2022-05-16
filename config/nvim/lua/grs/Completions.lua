--[[ Completions using nvim-cmp and luasnip

       Module: grs
       File: ~/.config/nvim/lua/grs/Completions.lua

  ]]

local ok_cmp, cmp = pcall(require, 'cmp')
local ok_luasnip, luasnip = pcall(require, 'luasnip')
if not ok_cmp or not ok_luasnip then
  if not ok_cmp then print('Problem loading nvim-cmp. ') end
  if not ok_luasnip then print('Problem loading cmp_luasnip. ') end
  return
end

-- Have Luasnip lazy load snippets
require('luasnip.loaders.from_vscode').lazy_load()

local myHasWordsBefore = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup(
  {
    sources = cmp.config.sources(
      {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer',
          option = {
            get_bufnrs = function()
              return { vim.api.nvim_get_current_buf() }
            end
          }
        },
        { name = path }
      }),
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    -- I think the "mappings" defined below are artifacts of
    -- popup completion windows and not true nvim keybindings.
    mapping = {
      ['<C-P>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
      ['<C-N>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
      ['<C-B>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
      ['<C-F>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
      ['<C-E>'] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close()
      },
      ['<CR>'] = cmp.mapping.confirm { select = false },
      ['<Tab>'] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif myHasWordsBefore() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
      ['<S-Tab>'] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" })
    }
  })

cmp.setup.cmdline('/',
  {
    sources = cmp.config.sources(
      {
        { name = 'buffer'  }
      })
  })

cmp.setup.cmdline(':',
  {
    sources = cmp.config.sources(
      {
        { name = 'path' },
        { name = 'cmdline' }
      })
  })
