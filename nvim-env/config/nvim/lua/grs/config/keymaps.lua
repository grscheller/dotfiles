--[[ Define keymappings/keybindings - loaded on VeryLazy event ]]

-- loaded on "VeryLazy" event

local M = {}
local km = vim.keymap.set
local wk = require('which-key')
local scroll = require 'grs.lib.scroll'

--[[ Window/Tabpage related mappings/bindings ]]

-- Navigating windows
km('n', '<m-h>', '<c-w>h', { noremap = true, silent = true, desc = 'goto window left' })
km('n', '<m-j>', '<c-w>j', { noremap = true, silent = true, desc = 'goto window below' })
km('n', '<m-k>', '<c-w>k', { noremap = true, silent = true, desc = 'goto window above' })
km('n', '<m-l>', '<c-w>l', { noremap = true, silent = true, desc = 'goto window right' })
km('n', '<m-p>', '<c-w>p', { noremap = true, silent = true, desc = 'goto previous window' })

-- Creating new windows
km('n', '<m-s>', '<c-w>s', { noremap = true, silent = true, desc = 'split current window' })
km('n', '<m-d>', '<c-w>v', { noremap = true, silent = true, desc = 'vsplit current window' })
km('n', '<m-f>', '<cmd>split<bar>term fish<cr>i', {
   noremap = true,
   silent = true,
   desc = 'split fish term',
})
km('n', '<m-g>', '<cmd>vsplit<bar>term fish<cr>i', {
   noremap = true,
   silent = true,
   desc = 'vsplit fish term',
})

-- closing windows
km('n', '<m-c>', '<c-w>c', { noremap = true, silent = true, desc = 'close current window' })
km('n', '<m-v>', '<c-w>o', { noremap = true, silent = true, desc = 'close all other windows' })

-- Changing window layout
km('n', '<m-s-h>', '<c-w>H', { noremap = true, silent = true, desc = 'move window lhs' })
km('n', '<m-s-j>', '<c-w>J', { noremap = true, silent = true, desc = 'move window bottom' })
km('n', '<m-s-k>', '<c-w>K', { noremap = true, silent = true, desc = 'move window top' })
km('n', '<m-s-l>', '<c-w>L', { noremap = true, silent = true, desc = 'move window rhs' })
km('n', '<m-e>', '<c-w>=', { noremap = true, silent = true, desc = 'equalize windows' })

-- Resizing windows
km('n', '<m-left>', '2<c-w><', { noremap = true, silent = true, desc = 'make window narrower' })
km('n', '<m-right>', '2<c-w>>', { noremap = true, silent = true, desc = 'make window wider' })
km('n', '<m-down>', '2<c-w>-', { noremap = true, silent = true, desc = 'make window shorter' })
km('n', '<m-up>', '2<c-w>+', { noremap = true, silent = true, desc = 'make window taller' })

-- Move view in window, only move cursor to keep on screen
km('n', '<c-h>', 'z4h', { noremap = true, silent = true, desc = 'move view left 4 columns' })
km('n', '<c-j>', '3<c-e>', { noremap = true, silent = true, desc = 'move view down 3 lines' })
km('n', '<c-k>', '3<c-y>', { noremap = true, silent = true, desc = 'move view up 3 lines' })
km('n', '<c-l>', 'z4l', { noremap = true, silent = true, desc = 'move view right 4 columns' })

-- Managing tabpages - use gt & gT to move between tabpages
km('n', '<m-t>', '<c-w>T', { noremap = true, silent = true, desc = 'breakout window to new tab' })
km('n', '<m-y>', '<cmd>tabnew<cr>', { noremap = true, silent = true, desc = 'create new tab' })
km('n', '<m-u>', '<cmd>tabclose<cr>', { noremap = true, silent = true, desc = 'close current tab' })

-- Autoscroll window with focus
km('n', '<c-up>', scroll.up, { noremap = true, silent = true, desc = 'autoscroll up' })
km('n', '<c-down>', scroll.down, { noremap = true, silent = true, desc = 'autoscroll down' })
km('n', '<c-right>', scroll.faster, { noremap = true, silent = true, desc = 'autoscroll faster' })
km('n', '<c-left>', scroll.slower, { noremap = true, silent = true, desc = 'autoscroll slower' })
km('n', '<c-s>', scroll.reset, { noremap = true, silent = true, desc = 'autoscroll reset' })
km('n', '<c- >', scroll.pause, { noremap = true, silent = true, desc = 'autoscroll pause' })

--[[ Text editing keymaps not related to any specific plugins ]]

-- Toggle line numbering schemes
local function toggle_line_numbering()
   if not vim.wo.number and not vim.wo.relativenumber then
      vim.wo.number = true
      vim.wo.relativenumber = false
   elseif vim.wo.number and not vim.wo.relativenumber then
      vim.wo.relativenumber = true
   else
      vim.wo.number = false
      vim.wo.relativenumber = false
   end
end

km('n', '<leader>n', toggle_line_numbering, {
   noremap = true,
   silent = true,
   desc = 'toggle line numbering',
})

-- Delete & change text without affecting default register
wk.register({ name = 'system clipboard' }, { prefix = '<bslash>s', mode = {'n', 'v'} })

km({ 'n', 'x' }, '<bslash>d', '"_d', {
   noremap = true,
   silent = true,
   desc = 'delete text to blackhole register',
})
km({ 'n', 'x' }, '<bslash>c', '"_c', {
   noremap = true,
   silent = true,
   desc = 'change text to blackhole register',
})
km('n', '<bslash>D', '"_D', {
   noremap = true,
   silent = true,
   desc = 'delete to eol blackhole register',
})
km('n', '<bslash>C', '"_C', {
   noremap = true,
   silent = true,
   desc = 'change to eol blackhole register',
})
km('n', '<bslash>sD', '"+D', {
   noremap = true,
   silent = true,
   desc = 'delete to eol blackhole register',
})
km('n', '<bslash>sC', '"+C', {
   noremap = true,
   silent = true,
   desc = 'change to eol blackhole register',
})

-- Yank, delete, change & paste with system clipboard
km({ 'n', 'x' }, '<bslash>sy', '"+y', {
   noremap = true,
   silent = true,
   desc = 'yank to system clipboard',
})
km({ 'n', 'x' }, '<bslash>sd', '"+d', {
   noremap = true,
   silent = true,
   desc = 'delete to system clipboard',
})
km({ 'n', 'x' }, '<bslash>sc', '"+c', {
   noremap = true,
   silent = true,
   desc = 'change with system clipboard',
})
km({ 'n', 'x' }, '<bslash>sp', '"+p', {
   noremap = true,
   silent = true,
   desc = 'paste after cursor from system clipboard',
})
km({ 'n', 'x' }, '<bslash>sP', '"+P', {
   noremap = true,
   silent = true,
   desc = 'paste before cursor from system clipboard',
})

-- Keep next pattern match center of screen (normal mode only)
km('n', 'n', 'nzz', { noremap = true, silent = true, desc = 'find next and center' })

-- Shift line and reselect
km('x', '<', '<gv', { noremap = true, silent = true, desc = 'shift left & reselect' })
km('x', '>', '>gv', { noremap = true, silent = true, desc = 'shift right & reselect' })

-- Move visual selection up or down a line
km('x', 'J', ":m '>+1<cr>gv=gv", {
   noremap = true,
   silent = true,
   desc = 'move selection down a line',
})
km('x', 'K', ":m '<-2<cr>gv=gv", {
   noremap = true,
   silent = true,
   desc = 'move selection up a line',
})

-- Visually select what was just pasted
km('n', 'gV', "`[v`]", { noremap = true, silent = true, desc = 'select what was just pasted' })

-- Cleanup related keymaps
km('n', '<leader>w', '<cmd>%s/<bslash>s<bslash>+$//<cr><c-o>', {
   noremap = true,
   silent = true,
   desc = 'trim trailing whitespace',
})
km('n', '<esc>', '<cmd>noh<bar>mode<cr><esc>', {
   noremap = true,
   silent = true,
   desc = 'rm hlsearch & redraw on ESC',
})

-- Buffer related keymaps
km('n', '<leader>b', '<cmd>enew<cr>', {
   noremap = true,
   silent = true,
   desc = 'new unnamed buffer',
})

-- Spelling related keymaps
km('n', 'z ', '<cmd>set invspell<cr>', {
   noremap = true,
   silent = true,
   desc = 'toggle spelling',
})

--[[ Which-key prefix-keys]]

-- Leader & leader-like prefix-keys
wk.register(
   {
      name = 'space key',
   },
   {
      prefix = '<space>',
      mode = {'n', 'v'},
   }
)

wk.register(
   {
      name = 'clipboard, blackhole, LSP, DAP',
   },
   {
      prefix = '<bslash>',
      mode = 'n',
   }
)

wk.register(
   {
      name = 'clipboard, blackhole, LSP',
   },
   {
      prefix = '<bslash>',
      mode = 'v',
   }
)

-- Lazy GUI prefix-key & keymap
wk.register(
   {
      name = 'lazy',
   },
   {
      prefix = '<leader>l',
      mode = 'n',
   }
)

km('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'lazy gui' })

-- Telescope prefix-key & additional keymap
wk.register(
   {
      name = 'telescope',
   },
   {
      prefix = '<leader>t',
      mode = 'n',
   }
)

km('n', '<leader>tt', '<cmd>Telescope<cr>', {
   noremap = true,
   silent = true,
   desc = 'telescope',
})

-- Treesitter related keymap
km('n', '<leader>H', '<cmd>TSBufToggle highlight<cr>', {
   noremap = true,
   silent = true,
   desc = 'toggle treesitter highlighting',
})

-- Harpoon prefix-key
wk.register(
   {
      name = 'harpoon',
   },
   {
      prefix = '<leader>h',
      mode = 'n',
   }
)

-- Refactoring prefix-key
wk.register(
   {
      name = 'refactoring',
   },
   {
      prefix = '<leader>r',
      mode = {'n', 'v'},
   }
)

--[[ LSP related keymaps ]]
km('n', '<bslash>|', vim.diagnostic.setloclist, {
   noremap = true,
   silent = true,
   desc = 'buffer diagnostics',
})
km('n', '<bslash>[', vim.diagnostic.goto_prev, {
   noremap = true,
   silent = true,
   desc = 'goto prev diagostic',
})
km('n', '<bslash>]', vim.diagnostic.goto_next, {
   noremap = true,
   silent = true,
   desc = 'goto next diagostic',
})

function M.lsp(bufnr)
   km('n', '<bslash>H', vim.lsp.buf.hover, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'hover',
   })
   km('n', '<bslash>K', vim.lsp.buf.signature_help, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'signature help',
   })
   km('n', '<bslash>gd', vim.lsp.buf.definition, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto definition',
   })
   km('n', '<bslash>gD', vim.lsp.buf.declaration, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto declaration',
   })
   km('n', '<bslash>gI', vim.lsp.buf.implementation, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto implementation',
   })
   km('n', '<bslash>gr', vim.lsp.buf.references, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto references',
   })
   km('n', '<bslash>gt', vim.lsp.buf.type_definition, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'goto type definition',
   })
   km('n', '<bslash>gW', vim.lsp.buf.workspace_symbol, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'workspace symbol',
   })
   km('n', '<bslash>gS', vim.lsp.buf.document_symbol, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'document symbol',
   })
   km('n', '<bslash>a', vim.lsp.buf.code_action, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'code action',
   })
   km('n', '<bslash>h', vim.lsp.codelens.refresh, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'code lens refresh',
   })
   km('n', '<bslash>l', vim.lsp.codelens.run, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'code lens run',
   })
   km('n', '<bslash>r', vim.lsp.buf.rename, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'rename',
   })
   km('n', '<bslash>wa', vim.lsp.buf.add_workspace_folder, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'add workspace folder',
   })
   km('n', '<bslash>wr', vim.lsp.buf.remove_workspace_folder, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'remove workspace folder',
   })
   km({ 'n', 'v' }, '<bslash>F', vim.lsp.buf.format, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'lsp format',
   })

   wk.register(
      {
         name = 'goto',
      },
      {
         prefix = '<bslash>g',
         mode = 'n',
         buffer = bufnr,
      }
   )

   wk.register(
      {
         name = 'workspace'
      },
      {
         prefix = '<bslash>w',
         mode = 'n',
         buffer = bufnr,
      }
   )
end

-- Haskell related keymaps
function M.haskell(bufnr)
   km({ 'n', 'v' }, '<bslash>LF', '<cmd>%!stylish-haskell<cr>', {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'stylish haskell format',
   })

   wk.register(
      {
         name = 'haskell specific',
      },
      {
         prefix = '<bslash>L',
         mode = { 'n', 'v' },
         buffer = bufnr,
      }
   )
end

-- Rust-Tools related keymaps
function M.rust(bufnr, rt)
   km('n', '<bslash>LH', rt.hover_actions.hover_actions, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'rust hover actions',
   })
   km('n', '<bslash>LA', rt.code_action_group.code_action_group, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'rust code action group',
   })

   wk.register(
      {
         name = 'rust specific',
      },
      {
         prefix = '<bslash>L',
         mode = 'n',
         buffer = bufnr,
      }
   )
end

-- Scala Metals related keymaps
function M.metals(bufnr, metals)
   km('n', '<bslash>LH', metals.hover_worksheet, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'metals hover worksheet',
   })

   wk.register(
      {
         name = 'scala specific',
      },
      {
         prefix = '<bslash>L',
         mode = 'n',
         buffer = bufnr,
      }
   )
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.dap(bufnr, dap, dap_ui_widgets)
   km('n', '<bslash><bslash>c', dap.continue, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap continue',
   })
   km('n', '<bslash><bslash>h', dap_ui_widgets.hover, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap hover',
   })
   km('n', '<bslash><bslash>l', dap.run_last, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap run last',
   })
   km('n', '<bslash><bslash>o', dap.step_over, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap step over',
   })
   km('n', '<bslash><bslash>i', dap.step_into, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap step into',
   })
   km('n', '<bslash><bslash>b', dap.toggle_breakpoint, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap toggle breakpoint',
   })
   km('n', '<bslash><bslash>r', dap.repl.toggle, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = 'dap repl toggle',
   })

   wk.register(
      {
         name = 'dap',
      },
      {
         prefix = '<bslash><bslash>',
         mode = 'n',
         buffer = bufnr,
      }
   )
end

return M
