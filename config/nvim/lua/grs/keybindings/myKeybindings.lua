--[[ Neovim keybindings

     Using WhickKey (folke/which-key.nvim) to manage
     keep track, consistency check, and provide
     popup guidance for my keybindings.

     My intension is to devide this file up. ]]

local ok, wk = pcall(require, 'which-key')
if not ok then
    print('Problem loading which-key.')
    return
end

-- Reselect visual region upon indention of text in visual mode
wk.register({
    ['<'] = {'<gv', 'Shift Left & Reselect'},
    ['>'] = {'>gv', 'Shift Right & Reselect'}
}, {mode = 'v'})

-- Window navigation/position/size related keybindings
wk.register {
    -- Navigate between windows using CTRL+arrow-keys
    ['<C-h>'] = {'<C-W>h', 'Goto Window Left' },
    ['<C-j>'] = {'<C-W>j', 'Goto Window Down' },
    ['<C-k>'] = {'<C-W>k', 'Goto Window Up'   },
    ['<C-l>'] = {'<C-W>l', 'Goto Window Right'},
    -- Move windows around using CTRL-hjkl
    ['<M-Left>']  = {'<C-W>H', 'Move Window LHS'},
    ['<M-Down>']  = {'<C-W>J', 'Move Window BOT'},
    ['<M-Up>']    = {'<C-W>K', 'Move Window TOP'},
    ['<M-Right>'] = {'<C-W>L', 'Move Window RHS'},
    -- Resize windows using ALT-hjkl for Linux
    ['<M-h>'] = {'2<C-W><', 'Make Window Narrower'},
    ['<M-j>'] = {'2<C-W>-', 'Make Window Shorter' },
    ['<M-k>'] = {'2<C-W>+', 'Make Window Taller'  },
    ['<M-l>'] = {'2<C-W>>', 'Make Window Wider'   }
}

-- Normal mode <Space> keybindings
wk.register {
    ['<Space>'] = {
        ['<Space>'] = {':nohlsearch<CR>', 'Clear hlsearch'},
        b = {':enew<CR>', 'New Unnamed Buffer'},
        h = {':TSBufToggle highlight<CR>', 'Treesitter Highlight Toggle'},
        k = {':dig<CR>a<C-K>', 'Pick & Enter Diagraph'},
        l = {':mode<CR>', 'Clear & Redraw Screen'},  -- Lost <C-L> for this above
        n = {':lua myLineNumberToggle()<CR>', 'Line Number Toggle'},
        s = {
            name = '+Spelling',
            t = {':set invspell<CR>', 'Toggle Spelling'}
        },
        t = {
            name = '+Fish Shell in Terminal',
            s = {':split<CR>:term fish<CR>i', 'Fish Shell in split'},
            v = {':vsplit<CR>:term fish<CR>i', 'Fish Shell in vsplit'}
        },
        w = {
            name = '+Whitespace',
            t = {':%s/\\s\\+$//<CR>', 'Trim Trailing Whitespace'}
        }
    }
}

    -- Telescope related keybindings
wk.register {
    t = {
	    name = '+Telescope',
        b = {":lua require('telescope.builtin').buffers()<CR>", 'Buffers'},
        f = {
            name = 'Telescope Find',
            f = {":lua require('telescope.builtin').find_files()<CR>", 'Find File'},
            z = {":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", 'Fuzzy Find Current Buffer'},
        },
        g = {
	        name = '+Telescope Grep',
            l = {":lua require('telescope.builtin').live_grep()<CR>", 'Live Grep'},
            s = {":lua require('telescope.builtin').grep_string()<CR>", 'Grep String'}
	    },
        r = {":lua require('telescope.builtin').oldfiles()<CR>", 'Open Recent File'},
        t = {
	        name = '+Telescope Tags',
            b = {":lua require('telescope.builtin').tags{only_current_buffer() = true}<CR>", 'Tags in Current Buffer'},
            h = {":lua require('telescope.builtin').help_tags()<CR>", 'Help Tags'},
            t = {":lua require('telescope.builtin').tags()<CR>", 'Tags'}
        }
    }
}

-- LSP related keybindings ( `\` to enter IDE World )
wk.register {
    ['\\'] = {
        name = '+lsp',
        F = {':lua vim.lsp.buf.formatting()<CR>', 'Formatting'},
        g = {
            name = '+goto',
            d = {':lua vim.lsp.buf.definition()<CR>', 'Goto Definition'},
            D = {':lua vim.lsp.buf.declaration()<CR>', 'Goto Declaration'},
            i = {':lua vim.lsp.buf.implementation()<CR>', 'Goto Implementation'},
            r = {':lua vim.lsp.buf.references()<CR>', 'Goto References'}
        },
        h = {':lua vim.lsp.buf.signature_help()<CR>', 'Signature Help'},
        H = {':lua vim.lsp.buf.hover()<CR>', 'Hover'},
        K = {':lua vim.lsp.buf.worksheet_hover()<CR>', 'Worksheet Hover'},
        l = {':lua vim.lsp.diagnostic.set_loclist()<CR>', 'Diagnostic Set Loclist'},
        m = {":lua require('metals').open_all_diagnostics()<CR>", 'Metals Diagnostics'},
        r = {':lua vim.lsp.buf.rename()<CR>', 'Rename'},
        s = {
            name = '+symbol',
            d = {':lua vim.lsp.buf.document_symbol()<CR>', 'Document Symbol'},
            w = {':lua vim.lsp.buf.workspace_symbol()<CR>', 'Workspace Symbol'}
        },
        w = {
            name = '+workspace folder',
            a = {':lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add Workspace Folder'},
            r = {':lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove Workspace Folder'}
        },
        ['['] = {':lua vim.lsp.diagnostic.goto_prev({wrap = false})<CR>', 'Diagnostic Goto Prev'},
        [']'] = {':lua vim.lsp.diagnostic.goto_next({wrap = false})<CR>', 'Diagnostic Goto Next'}
    }
}
