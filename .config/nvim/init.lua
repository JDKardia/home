require("plugins")

-- sane options
vim.g.mapleader = " "
vim.o.number = false ---------- the perfect line numbers
vim.o.scrolloff = 4 ---------- sane scrolloff
vim.o.foldmethod = "marker" -- use {{{ to }}} for folding
vim.o.autoindent = true ------ preserve current line's indent
vim.o.smartindent = true ----- smartly add indents when necessary
vim.o.colorcolumn = "80,88,100,120" -- solid healthy line length
vim.o.expandtab = false ------ Use tabs instead of spaces
vim.o.shiftwidth = 0 --------- 0 => same shiftwidth as whatever softtabstop is
vim.o.softtabstop = 2 -------- behave as if 1 tab == 2 spaces
vim.o.tabstop = 2 ------------ all tabs show as length 2
vim.o.magic = true ----------- For regular expressions turn magic on
vim.o.mat = 2 ---------------- tenths of a second to blink when matching brackets
vim.o.timeoutlen = 300 ------- ms to wait for a mapped sequence to complete.
vim.o.ffs = "unix,dos,mac" --- Use Unix as the standard file type
vim.o.encoding = "utf8" ------ cuz duh
vim.o.errorbells = false ----- disable errorbells
vim.o.visualbell = false ----- disable visual flash from bell
vim.o.ignorecase = true ------ Ignore case when searching
vim.o.showmatch = true ------- Show matching brackets when indicator is over them
vim.o.wildmenu = true -------- enable 'enhanced mode' of command completions
vim.o.spell = true ----------- enable spellchecking
vim.o.undofile = true -------- maintain undo history between sessions
vim.o.wildmode = "longest:full,full" -- Enable vim command completion
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l,[,]" -- allow cursor to wrap lines
vim.o.nrformats = "bin,hex,alpha" -- increment alpha char with <C-A>
vim.o.completeopt = "menu,menuone,noselect,preview"
vim.o.swapfile = false
vim.o.colorcolumn = "80,88,100,120"

-- look for these suffixes when given filename without an extension
vim.opt.suffixesadd = ".md,.py,.sh,.js"

--stuff i haven't converted to lua yet.
vim.cmd([[


inoreabbrev .\ λ

" Automatically leave insert mode if idle for too long
au CursorHoldI * stopinsert

" set 'updatetime' to 15 seconds when in insert mode, preserve old update time
au InsertEnter * let updaterestore=&updatetime | set updatetime=30000
au InsertLeave * let &updatetime=updaterestore

" automatically write if navigate away from buffer and filetype is markdown
au Filetype markdown set autowriteall

au FileType go setlocal foldmethod=indent

au BufNewFile,BufRead *.bazel   set filetype=bzl

]])
