require('plugins')

-- sane options
vim.g.mapleader = ','
vim.o.relativenumber = true -- the perfect line numbers
vim.o.number = true ---------- the perfect line numbers
vim.o.scrolloff = 7 ---------- sane scrolloff
vim.o.foldmethod = 'marker' -- use {{{ to }}} for folding
vim.o.autoindent = true ------ preserve current line's indent
vim.o.smartindent = true ----- smartly add indents when necessary
vim.o.colorcolumn = 80 ------- solid healthy line length
vim.o.expandtab = true ------- Use spaces instead of tabs
vim.o.shiftwidth = 2 --------- 1 tab == 2 spaces
vim.o.tabstop = 2 ------------ 1 tab == 2 spaces
vim.o.mouse = 'a' ------------ enable mouse support in all modes
vim.o.magic = true ----------- For regular expressions turn magic on
vim.o.mat = 2 ---------------- tenths of a second to blink when matching brackets
vim.o.timeoutlen = 500 ------- ms to wait for a mapped sequence to complete.
vim.o.ffs = 'unix,dos,mac' --- Use Unix as the standard file type
vim.o.encoding = 'utf8' ------ cuz duh
vim.o.errorbells = false ----- disable errorbells
vim.o.visualbell = false ----- disable visual flash from bell
vim.o.ignorecase = true ------ Ignore case when searching
vim.o.showmatch = true ------- Show matching brackets when indicator is over them
vim.o.wildmenu = true -------- enable 'enhanced mode' of command completions
vim.o.wildmode = 'longest:full,full' -- Enable vim command completion
vim.o.whichwrap = vim.o.whichwrap .. '<,>,h,l,[,]' -- allow cursor to wrap lines
vim.o.nrformats = 'bin,hex,alpha' -- increment alpha char with <C-A>

-- look for these suffixes when given filename without an extension
vim.opt.suffixesadd = '.md,.py,.sh,.js'

-- keymaps, convert these later once rest is working
vim.cmd([[
:imap jk <Esc>
:imap kj <Esc>

nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" move a line of text with ALT+[jk] or META+[jk] on mac
nnoremap <A-j> :m .+1<cr>==
nnoremap <A-k> :m .-2<cr>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+<cr>gv=gv
vnoremap <A-k> :m '<-2<cr>gv=gv

noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>Y "*y
noremap <Leader>P "*p
vnoremap <Leader>y "+y
vnoremap <Leader>p "+p
vnoremap <Leader>Y "*y
vnoremap <Leader>P "*p

nnoremap <Leader>r <Plug>(Luadev-Run)

inoreabbrev .\ λ
]])
-- commands, convert these once all working.
vim.cmd([[
let noteroot="/home/kardia/notes"

" Typos suck
command! Wq wq
command! Q q

"for inserting new logs into Captains Log
function! NewLog()
  let l:date = strftime("%Y-%m-%d")
  call append(line('.'),["# " . date,"## TODO:","- [ ]","",""])
  normal! 2j
endfunction
command! NewLog call NewLog()
nnoremap <leader>n :<C-U>call NewLog()<CR>

function! NewCheck()
  call append(line('.'),["- [ ]"])
endfunction
nnoremap <leader>c :<C-U>call NewCheck()<CR>

command! ReloadConfig :so $MYVIMRC

" custom sql formatting, requires sql-formatter to be installed
if executable("sql-formatter")
  command! SqlFormat :%! sed -E 's/(@|\#|\$)/FUCK\1FUCK/g' |sql-formatter -u | sed -zE '
     \ s/ - > / -> /g;
     \ s/ \| \| / || /g;
     \ s/ \! = / \!= /g;
     \ s/ -> > / ->> /g;
     \ s/:: /::/g;
     \ s/FUCK(.)FUCK/\1/g;
     \ s/FUCK (.) FUCK/\1/g;
     \ s/(\n\s*)(DISTINCT) / \2\1/g;
     \ s/\sWITH/\nWITH/g'
endif

" harden shell scripts if available
if executable("shellharden")
  command! Harden :%!shellharden --transform ''
endif

" set filetype to scala for .sc files (ammonite scripts)
au BufRead,BufNewFile *.sc set filetype=scala
]])
