"""""""""""""""""""""""""""""""""""""
" Joe's Vim Config That Isn't Neovim"
"""""""""""""""""""""""""""""""""""""

" The Essentials
"""""""""""""""""""""""""""""""""""""""""""
" The Sane Escape
:imap jk <Esc>
:imap kj <Esc>

command! Vimrc :vs $MYVIMRC " open vimrc

set number relativenumber      " Set the perfect line numbers
set mouse=a          " enable mouse support in all modes
set wildmode=longest:full,full " Enable vim command completion
set whichwrap+=<,>,h,l,[,]     " allow cursor to wrap lines
let mapleader=","    " Set a Sensible Leader
set magic            " For regular expressions turn magic on
set ignorecase       " Ignore case when searching
set showmatch        " Show matching brackets when indicator is over them
set mat=2            " tenths of a second to blink when matching brackets
set scrolloff=7      " Set sane scrolloff
set autoindent       " preserve current line's indent
set smartindent      " smartly add indents when necessary
"set textwidth=88     " black formatter recommended line length
set colorcolumn=88   " black formatter recommended line length
set expandtab        " Use spaces instead of tabs
set shiftwidth=2     " 1 tab == 2 spaces
set tabstop=2        " 1 tab == 2 spaces
set ffs=unix,dos,mac " Use Unix as the standard file type
set encoding=utf8    " cuz duh
set timeoutlen=500   " ms to wait for a mapped sequence to complete.
set noerrorbells     " disable errorbells
set novisualbell     " disable visual flash from bell
set nrformats+=alpha " allows <CTRL+A> to increment alpha characters too.
set t_vb=

" look for these suffixes when given filename without an extension
set suffixesadd=.md,.py,.sh,.js


" Theming
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set termguicolors " 24 bit color

" Language specific behavior
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" change default for python
autocmd FileType python setlocal sw=4 sts=4
" sane yaml shit
autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>

" The PERSONAL TWEAKS AND CHANGES
"""""""""""""""""""""""""""""""""""""""""""
let noteroot="/home/kardia/notes"

" move a line of text with ALT+[jk] or META+[jk] on mac
nmap <M-Down> mz:m+<cr>`z:
nmap <M-Up> mz:m-2<cr>`z
vmap <M-Down> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-Up> :m'<-2<cr>`>my`<mzgv`yo`zi

" Typos Suck
command! Wq wq
command! Q q

noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>Y "*y
noremap <Leader>P "*p
vnoremap <Leader>y "+y
vnoremap <Leader>p "+p
vnoremap <Leader>Y "*y
vnoremap <Leader>P "*p

inoreabbrev .\ λ 

" note for self, while inserting, ctrl+v then some keyboard input captures
" the input, like a ctrl+r or or a carriage return. Lets you make fancy macros

"for inserting new logs into my Captains Log
function! NewLog()
    let l:date = strftime("%Y-%m-%d")
    call append(line('.'),["# " . date,"## Log","","## TL;DR;","- ","","## TODO:","- [ ]","",""])
    normal! 2j
endfunction
command! NewLog call NewLog()
nnoremap <leader>n :<C-U>call NewLog()<CR>

"for inserting new time entries in a Captains log
function! NewTime()
    let l:date = strftime("%T%z")
    call append(line('.'),["### " . date,""])
    normal! 2j
endfunction
command! NewTime call NewTime()
nnoremap <leader>t :<C-U>call NewTime()<CR>

function! NewCheck()
  call append(line('.'),["- [ ]"])
endfunction
nnoremap <leader>c :<C-U>call NewCheck()<CR>

" create init content for notes
function! ZetStart(...)
    " build title-case title
    let l:title = substitute(join(a:000, " "), '\v<(a|an|the|is)@!\w+>', '\u&', 'g')
    call append(0,["# " . title,"","","## tags","","- ",""])
    normal! 5k
endfunction
command! -nargs=* Zet call ZetStart(<f-args>)

" set filetype to scala for .sc files (ammonite scripts)
au BufRead,BufNewFile *.sc set filetype=scala

