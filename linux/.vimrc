" Most of this config was lifted from http://jsdelfino.blogspot.com/2010/11/my-vi-configuration-file.html

" vim-plug (https://github.com/junegunn/vim-plug)

call plug#begin()
" Theme
Plug 'fatih/molokai'
"Plug 'cormacrelf/vim-colors-github'
" Status bar
" Plug 'powerline/powerline'
Plug 'https://github.com/bling/vim-airline'
" Git plugins
"Plug 'tpope/vim-fugitive'
"Plug 'int3/vim-extradite'
" Golang
" NOTE: vim-go does not work with the standard vim included in some Linux distros. Disable the plugin for now.
"Plug 'fatih/vim-go'
Plug 'nsf/gocode'
" Text editing
Plug 'scrooloose/nerdtree'
Plug 'godlygeek/tabular'
Plug 'https://github.com/plasticboy/vim-markdown.git'
Plug 'https://github.com/avakhov/vim-yaml.git'
Plug 'pangloss/vim-javascript'
Plug 'beautify-web/js-beautify'
Plug 'elzr/vim-json'
" File browsers
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
call plug#end()

" vi-improved mode
set nocompatible
filetype on
filetype plugin on
filetype indent on

" cycle buffers without writing
set hidden

" backup while writing
set writebackup

" file completion
set wildmenu
set wildmode=list:longest

" update window title
set title

" display cursor location
set ruler
set number
set scrolloff=7

"colorscheme github
"let g:airline_theme = "github"

" Statusline
" https://github.com/pengwynn/dotfiles/blob/master/vim/vimrc.symlink#L160
set statusline=                                     " Override default
"set statusline+=%1*%{fugitive#statusline()[4:-2]}%* " Show fugitive git info
set statusline+=%2*\ %f\ %m\ %r%*                   " Show filename/path
set statusline+=%3*%=%*                             " Set right-side status info after this line
set statusline+=%4*%l/%L:%v%*                       " Set <line number>/<total lines>:<column>
set statusline+=%5*\ %*                             " Set ending space

" short message prompts
set shortmess=atI

" silent
set noerrorbells
set novisualbell
" switch to current file's directory
set autochdir

" remember marks, registers, searches, buffer list
set viminfo='20,<50,s10,h,%

" keep a big history
set history=1000

" syntax highligting
syntax on

set list
set listchars=nbsp:¬,tab:»·,trail:·

" auto smart code indent
set autoindent
filetype indent on
set smartindent
set smarttab
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set shiftround

" allow backspacing in insert mode
set backspace=indent,eol,start

" incremental search
set incsearch
set nohlsearch

" ignore case
set ignorecase
set smartcase

" Reload changes to .vimrc automatically
autocmd BufWritePost  ~/.vimrc source ~/.vimrc

" Explorer
let g:netrw_liststyle=3

" ctrl-p settings
let g:ctrlp_map = '<c-p>'

" vim-markdown
let g:vim_markdown_folding_disabled=1

" vim-json
let g:vim_json_syntax_conceal = 0

" autocommands
au! BufRead,BufNewFile *.json set filetype=json
au! BufRead,BufNewFile *.go set filetype=go

" key mappings
map <C-n> :NERDTreeToggle<CR>
