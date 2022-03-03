--[[ Completions - using nvim-cmp and luasnip ]]

local ok_cmp, cmp = pcall(require, 'cmp')
local ok_snip, luasnip = pcall(require, 'luasnip')
if ok_cmp and ok_snip then
    local myHasWordsBefore = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    -- I think the "mappings" defined below are artifacts of
    -- popup completion windows and not true nvim keybindings.
    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        mapping = {
            ['<C-P>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
            ['<C-N>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
            ['<C-D>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
            ['<C-F>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<C-E>'] = cmp.mapping(cmp.mapping.close(), {'i', 'c'}),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true },
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
                end, {"i", "s"}),
            ['<S-Tab>'] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {"i", "s"})
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'luasnip'  }
        }, {
            { name = 'buffer'   },
            { name = 'path'     }
        })
    }

    cmp.setup.cmdline('/', {
        sources = cmp.config.sources(
            {{ name = 'buffer'  }},
            {{ name = 'cmdline' }})
    })

    cmp.setup.cmdline(':', {
        sources = cmp.config.sources(
            {{ name = 'path'     }},
            {{ name = 'cmdline'  }},
            {{ name = 'nvim-lua' }})
    })
end
