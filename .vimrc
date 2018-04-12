" General settings"{{{
set backupskip=/tmp/*,/private/tmp/*
set foldmethod=marker
set hls             " highlight search
set linebreak       " break long lines
set relativenumber  " relative line numbers
set nocompatible
set number          " line number
set shell=/bin/bash\ --rcfile\ ~/.bash_profile\ -i
set viminfo=

" Vim auxiliary files in separate hidden directories
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
set undodir=~/.vim/tmp/undo//

filetype plugin on
autocmd BufRead,BufNewFile *.tex setlocal spell spelllang=en_us
autocmd BufRead,BufNewFile *.tex setlocal fo=c
autocmd BufEnter * silent! lcd %:p:h

" tab settings for coding
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
"}}}

"Remaps"{{{
let g:mapleader = ' '
nnoremap <Leader>; ;
nnoremap ; :
vnoremap ; :
vnoremap : ;
nnoremap Y y$
imap <C-d> <Del>

" allows for easier navigation of text with long lines.
vnoremap j gj
vnoremap k gk
vnoremap $ g$
vnoremap ^ g^
vnoremap 0 g0
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap ^ g^
nnoremap 0 g0
nnoremap I g^i
nnoremap A g$a

nnoremap Q gwip
nmap <Leader>4 $
nmap <Leader>6 ^

" true Ctrl-C = Escape, important for keyboard layout switching
inoremap <C-C> <ESC>
"}}}

"Plug block"{{{
call plug#begin('~/.vim/plugged')
Plug 'bronson/vim-trailing-whitespace'
Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': 'tex' }
Plug 'lyokha/vim-xkbswitch'
Plug 'Raimondi/delimitMate'
" Plug 'SirVer/ultisnips'
Plug 'shougo/neosnippet.vim'
Plug 'shougo/neosnippet-snippets'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wombat256.vim'
call plug#end()
"}}}

" Plugin settings"{{{
" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline_right_sep=''
let g:airline_left_sep=''

" Buffer Navigation
nnoremap <Leader>b :bnext!<CR>
nnoremap <Leader>B :bprevious!<CR>
nnoremap <Leader>kb :bdelete<CR>

let g:UltiSnipsExpandTrigger="<C-J>"

"""" Latex Box
let g:tex_flavor = "latex"
let g:LatexBox_latexmk_options="-pdflatex='pdflatex -synctex=1 \%O \%S'"
let g:LatexBox_viewer='open -a Skim -F'
let g:LatexBox_quickfix=2
let g:LatexBox_custom_indent=0
let g:Tex_BibtexFlavor='biber'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf,dvi'
" Jump to line in PDF you are on in source using Skim (Mac only)
map <silent> <LocalLeader>ls :silent
    \ !/Applications/Skim.app/Contents/SharedSupport/displayline
    \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>"
    \ "%:p" <CR>
""""

nnoremap <Leader>u :GundoToggle<CR>

" Fugitive bindings
nnoremap <Leader>g :Gstatus<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gD :Gdiff HEAD<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gl :Git log<CR>
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gremove<CR>

au FileType tex let b:delimitMate_matchpairs="(:),[:],{:},`:'"
au FileType tex let b:delimitMate_quotes="$ \""
let g:delimitMate_expand_space = 1

au FileType awk setlocal commentstring=#\ %s

" YCM - blacklist identical to default except *without* text
let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'unite' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 1,
    \ 'infolog' : 1,
    \ 'mail' : 1
    \}

" Switch to different keyboard layout in insert mode
" See github.com/vovkasm/input-source-switcher (Mac)
let g:XkbSwitchEnabled = 1
let g:XkbSwitchLib = '/usr/local/lib/libInputSourceSwitcher.dylib'
"}}}

" Aesthetics"{{{
set background=dark
let g:airline_theme='wombat'
colorscheme wombat256mod
set guifont=Droid\ Sans\ Mono\ for\ Powerline:h13
"}}}

" GUI"{{{
if has("gui_running")
    set columns=100
    set lines=60
    set textwidth=80
    set winwidth=100
    set listchars=tab:►\ ,eol:¬,trail:·,extends:>,precedes:<
endif
"}}}
