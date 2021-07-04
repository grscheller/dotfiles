" Neovim configuration file
"
" ~/.config/nvim/init.vim
"
" Written by Geoffrey Scheller
" See https://github.com/grscheller/dotfiles

""" Preliminaries

"" Set default encoding, localizations, and file formats
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set spelllang=en_us
set fileformats=unix,mac,dos

"" Remove Vim misfeatures and vulnerabilities
set nomodeline

"" Some plugins need a POSIX compatible shell
set shell=/bin/sh

"" Improve Vi and Vim, not Clone Vi or Vim
" More powerful backspacing in insert mode
set backspace=indent,eol,start
" Make tab completion in command mode more useful
set wildmenu
set wildmode=longest:full,full
" Allow gf and :find to use recursive sub-folders
" and find files in the working directory
set path+=.,**
set hidden

""" Personnal preferences

"" Configure features and behaviors
set history=10000   " Number lines of command history to keep
set mouse=a         " Enable mouse for all modes
set scrolloff=2     " Keep cursor away from top/bottom of window
set nowrap          " Don't wrap lines
set sidescroll=1    " Horizontally scroll nicely
set sidescrolloff=5 " Keep cursor away from side of window
set splitbelow      " Horizontally split below
set splitright      " Vertically split to right
set hlsearch        " Highlight / search results after <CR>
set incsearch       " Highlight / search matches as you type
set ignorecase      " Case insensitive search,
set smartcase       " ... unless query has caps
set showcmd         " Show partial normal mode commands in lower right corner
set nrformats=bin,hex,octal " bases used for <C-A> & <C-X>,
set nrformats+=alpha        " ... also single letters too

" Set default tabstops and replace tabs with spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

"" Setup key mappings
" Define <Leader> explicitly as a space
nnoremap <Space> <Nop>
let g:mapleader = "\<Space>"

" Clear search highlighting
nnoremap <Leader><Space> :nohlsearch<CR>
 
" Trim all trailing whitespace
nnoremap <Leader>w :%s/\s\+$//<CR>

" Toggle spell checking
nnoremap <Leader>sp :set invspell<CR>

" Fix an old vi inconsistancy between Y and D & C
nnoremap Y y$

" Open a vertical terminal running fish shell
nnoremap <expr> <Leader>f ':vsplit<CR>:term fish<CR>i'

" Reduce keystrokes and memmory load from :dig to entering digraph
"  - position cursor on char before you want to insert digraph
"  - type <Leader>k
"  - use q to exit digraph table
"  - type digraph
nnoremap <expr> <Leader>k ':dig<CR>a<C-K>'

" Clear & redraw screen, lost <C-L> for this below
nnoremap <Leader>l :mode<CR>

" Move windows around using CTRL-hjkl in normal mode
nnoremap <C-H> <C-W>H
nnoremap <C-J> <C-W>J
nnoremap <C-K> <C-W>K
nnoremap <C-L> <C-W>L

" Resize windows using ALT-hjkl in normal mode
nnoremap <M-h> 2<C-W><
nnoremap <M-j> 2<C-W>-
nnoremap <M-k> 2<C-W>+
nnoremap <M-l> 2<C-W>>

" Navigate between windows using CTRL+arrow-keys in normal mode
nnoremap <C-Left> <C-W>h
nnoremap <C-Down> <C-W>j
nnoremap <C-Up> <C-W>k
nnoremap <C-Right> <C-W>l

" Toggle between 3 line numbering states via <Leader>n
set nonumber
set norelativenumber

function! MyLineNumberToggle()
    if(&relativenumber == 1)
        set nonumber
        set norelativenumber
    elseif(&number == 1)
        set nonumber
        set relativenumber
    else
        set number
        set norelativenumber
    endif
endfunction

nnoremap <Leader>n :call MyLineNumberToggle()<CR>:<C-C>

""" Setup plugins

"" Setup the Plug plugin manager
"
" Bootstrap manually by installing plug.vim into the right place:
"
"   $ curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" and then from command mode run
"
"   :PlugInstall
"
" Plug Commands:
"   :PlugInstall [name ...] [#threads] Install plugins
"   :PlugUpdate [name ...] [#threads]  Install or update plugins
"   :PlugClean[!]           Remove unlisted plugins
"   :PlugUpgrade            Upgrade Plug itself
"   :PlugStatus             Check the status of plugins
"   :PlugDiff               Diff previous update and pending changes
"   :PlugSnapshot[!] [path] Generate script to restore current plugin state
"
call plug#begin('~/.local/share/nvim/plugged')

" Surrond text objects with matching (). {}. '', etc
"
"   ds delete surronding - ds"
"   cs change surronding - cs[{
"   ys surround text object or motion - ysiw)
"
" Works on various markup tags
" Works in visual line mode
Plug 'tpope/vim-surround'

" Enable repeating last action via "." for supported plugins
Plug 'tpope/vim-repeat'

" Shows what is in registers
" extends " and @ in normal mode and <C-R> in insert mode
Plug 'junegunn/vim-peekaboo'

" Use vim-airline to configure the statusline
Plug 'vim-airline/vim-airline'

" Install plugins to manage Metals for Scala
Plug 'scalameta/nvim-metals'
Plug 'nvim-lua/completion-nvim'

" Use NeoMake to provide asynchronous execution of commands,
" usually for syntax/style checking and building source code.
Plug 'neomake/neomake'

" Provide Rust file detection, syntax highlighting,
" formatting, Syntastic integration, and more
Plug 'rust-lang/rust.vim'

" Provide VimL lint checking via vimlint (below) and vint (pacman)
Plug 'ynkdir/vim-vimlparser'
Plug 'syngan/vim-vimlint'

" Provide Fish syntax highlighting support
Plug 'dag/vim-fish'

" Install colorschemes
Plug 'grscheller/tokyonight.nvim'

" Colorize hexcodes and names like Blue
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

"" Metals configuration, modified
"  from https://github.com/scalameta/nvim-metals/discussions/39

" Comment out for latest stable server.  To use the latest bloody edge
" version, see https://scalameta.org/metals/docs/editors/overview.html
let g:metals_server_version = '0.10.4+118-c2380821-SNAPSHOT'

" Nvim-LSP Mappings
nnoremap <silent> gd        <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gds       <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gws       <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> mrn       <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> mf        <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> mca       <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> mws       <cmd>lua require'metals'.worksheet_hover()<CR>
nnoremap <silent> ma        <cmd>lua require'metals'.open_all_diagnostics()<CR>
nnoremap <silent> <Leader>d <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> <Leader>[ <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
nnoremap <silent> <Leader>] <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>

" Nvim-Metals setup with a few additions such as nvim-completions
:lua << EOF
  metals_config = require'metals'.bare_config
  metals_config.settings = {
     showImplicitArguments = true,
     excludedPackages = {
       "akka.actor.typed.javadsl",
       "com.github.swagger.akka.javadsl"
     }
  }

  metals_config.on_attach = function()
    require'completion'.on_attach();
  end

  metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {
        prefix = '',
      }
    }
  )
EOF

augroup lsp
  au!
  au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
augroup end

" completion-nvim settings
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? '\<C-n>' : '\<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '\<C-p>' : '\<S-Tab>'

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

set shortmess-=F
set shortmess+=c

"" Neomake configuration

" NeoMake full interactive automation
"   when writing or reading a buffer, and on changes in
"   insert and normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)

" Disable NeoMake scala makers, will use Metals for Scala.
let g:neomake_scala_enabled_makers = []

"" Setup colors

" Nvim colorizer setup (create autocmds for filetypes)
set termguicolors
lua require'colorizer'.setup()

" Configure Tokyo Night Colorscheme
let g:tokyonight_style = 'night'
let g:tokyonight_italic_functions = 1
let g:tokyonight_sidebars = [ 'qf', 'vista_kind', 'terminal', 'packer' ]
colorscheme tokyonight
