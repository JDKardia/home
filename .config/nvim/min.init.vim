""""""""""""""""""""
" Joe's Vim Config "
""""""""""""""""""""
" The Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" Declare the list of plugins.
Plug '907th/vim-auto-save'
Plug 'SirVer/ultisnips'
Plug 'fladson/vim-kitty'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'honza/vim-snippets'
Plug 'hrsh7th/nvim-compe'
Plug 'mhinz/vim-signify'
Plug 'morhetz/gruvbox'
Plug 'neovim/nvim-lspconfig'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
Plug 'preservim/nerdtree' |  Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'prettier/vim-prettier'
Plug 'sbdchd/neoformat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'kovisoft/slimv'
Plug 'ziglang/zig.vim'
Plug 'williamboman/nvim-lsp-installer'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

if exists("g:vscode")
  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
endif



" The Essentials (on top of tpope/sensible)
"""""""""""""""""""""""""""""""""""""""""""
" The Sane Escape
:imap jk <Esc>
:imap kj <Esc>

nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

command! Vimrc :vs $MYVIMRC " open vimrc

set number relativenumber      " Set the perfect line numbers
set mouse=a           " enable mouse support in all modes
set wildmode=longest:full,full " Enable vim command completion
set whichwrap+=<,>,h,l,[,]     " allow cursor to wrap lines
let mapleader=","     " Set a Sensible Leader
set magic             " For regular expressions turn magic on
set ignorecase        " Ignore case when searching
set showmatch         " Show matching brackets when indicator is over them
set mat=2             " tenths of a second to blink when matching brackets
set scrolloff=7       " Set sane scrolloff
set foldmethod=marker " use {{{ to }}} based folding
set autoindent        " preserve current line's indent
set smartindent       " smartly add indents when necessary
set colorcolumn=88    " black formatter recommended line length
set expandtab         " Use spaces instead of tabs
set shiftwidth=2      " 1 tab == 2 spaces
set tabstop=2         " 1 tab == 2 spaces
set ffs=unix,dos,mac  " Use Unix as the standard file type
set encoding=utf8     " cuz duh
set timeoutlen=500    " ms to wait for a mapped sequence to complete.
set noerrorbells      " disable errorbells
set novisualbell      " disable visual flash from bell
set nrformats+=alpha  " allows <CTRL+A> to increment alpha characters too.
set t_vb=

" look for these suffixes when given filename without an extension
set suffixesadd=.md,.py,.sh,.js



" Theming
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set termguicolors " 24 bit color
try
    colorscheme gruvbox
catch
endtry
let g:gruvbox_contrast_dark="hard"
set background=dark

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
nnoremap <A-j> :m .+1<cr>==
nnoremap <A-k> :m .-2<cr>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+<cr>gv=gv
vnoremap <A-k> :m '<-2<cr>gv=gv

" Typos suck
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

"for inserting new logs into Captains Log
function! NewLog()
  let l:date = strftime("%Y-%m-%d")
  call append(line('.'),["# " . date,"## TODO:","- [ ]","",""])
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

" custom sql formatting, requires sql-formatter to be installed
if executable("sql-formatter")
  command! SqlFormat :%!sql-formatter -u | sed 's/ - > / -> /g; s/ \! = / \!= /g; s/ -> > / ->> /g; s/:: /::/g; s/ \#/\#/g'
endif
" harden shell scripts if available
if executable("shellharden")
  command! Harden :%!shellharden --transform ''
endif

" set filetype to scala for .sc files (ammonite scripts)
au BufRead,BufNewFile *.sc set filetype=scala


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Telescope Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Treesitter Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua <<TSCONF
require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "all",
  highlight = {enable=true,disable={"scala"}},
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 2000,
    },
  playground = {
    enable=true,
    }
}
TSCONF


"" LSP and Completion Config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:UltiSnipsExpandTrigger="<Nop>"
"let g:UltiSnipsJumpForwardTrigger="<Nop>"
"let g:UltiSnipsJumpBackwardTrigger="<Nop>"
"let g:UltiSnipsMappingsToIgnore=["<tab>", "<S-tab>"]

"lua << LSPCONF
"local lsp_installer = require("nvim-lsp-installer")
"local lspconf = require("lspconfig")

"local capabilities = vim.lsp.protocol.make_client_capabilities()
"capabilities.textDocument.completion.completionItem.snippetSupport = true
"capabilities.textDocument.completion.completionItem.resolveSupport = {
"  properties={
"    'documentation',
"    'detail',
"    'additionalTextEdits',
"  }
"}

"-- Use an on_attach function to only map the following keys
"-- after the language server attaches to the current buffer
"local on_attach = function(client, bufnr)
"  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
"  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

"  --Enable completion triggered by <c-x><c-o>
"  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

"  -- Mappings.
"  local opts = {
"    noremap=true,
"    silent=true
"  }

"  -- See `:help vim.lsp.*` for documentation on any of the below functions
"  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
"  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
"  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
"  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
"  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
"  buf_set_keymap('n', '<leader><leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
"  buf_set_keymap('n', '<leader><leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
"  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
"  buf_set_keymap('n', '<leader><leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
"  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
"  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
"  buf_set_keymap('n', '<leader><leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
"  buf_set_keymap("n", "<leader><leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
"end



"-- Use a loop to call 'setup' on multiple servers

"local servers = {
"  "bashls",
"  "clangd",
"  "cmake",
"  "cssls",
"  "dockerls",
"  "dotls",
"  "elixirls",
"  "eslint",
"  "html",
"  "jsonls",
"  "pyright",
"  "sqlls",
"  "tsserver",
"  "vimls",
"  "yamlls",
"  "zls"
"}

"for _, lsp in ipairs(servers) do
"  lspconf[lsp].setup { on_attach=on_attach, capabilities=capabilities }
"end

"require'compe'.setup {
"  enabled = true;
"  autocomplete = true;
"  debug = false;
"  min_length = 1;
"  preselect = 'enable';
"  throttle_time = 80;
"  source_timeout = 200;
"  incomplete_delay = 400;
"  max_abbr_width = 100;
"  max_kind_width = 100;
"  max_menu_width = 100;
"  documentation = true;

"  source = {
"    path = true;
"    buffer = true;
"    calc = true;
"    nvim_lsp = true;
"    nvim_lua = true;
"    vsnip = false;
"    ultisnips = true;
"  };
"};

"local t = function(str)
"  return vim.api.nvim_replace_termcodes(str, true, true, true)
"end

"local check_back_space = function()
"    local col = vim.fn.col('.') - 1
"    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
"        return true
"    else
"        return false
"    end
"end

"-- Use (s-)tab to:
"--  move to prev/next item in completion menuone
"--  jump to prev/next snippet's placeholder
"_G.tab_complete = function()
"  if vim.fn.pumvisible() == 1 then
"    return t "<C-n>"
"  elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
"    return t "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>"
"  elseif check_back_space() then
"    return t "<Tab>"
"  else
"    return vim.fn['compe#complete']()
"  end
"end
"_G.s_tab_complete = function()
"  if vim.fn.pumvisible() == 1 then
"    return t "<C-p>"
"  elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
"    return t "<C-R>=UltiSnips#JumpBackwards()<CR>"
"  else
"    -- If <S-Tab> is not working in your terminal, change it to <C-h>
"    return t "<S-Tab>"
"  end
"end

"vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
"vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
"vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
"vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

"LSPCONF

" " NOTE: Order is important. You can't lazy loading lexima.vim.
" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <CR>      compe#confirm('<CR>')
" inoremap <silent><expr> <C-e>     compe#close('<C-e>')

" NERDTree Configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" open/close nerdtree with ctrl+n
map <C-n> :NERDTreeToggle<CR>
" auto close nerdtree if it's all that's left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Tell nerdtree-git-plugin we have nerdfonts
let g:NERDTreeGitStatusUseNerdFonts = 1 "
let g:NERDTreeWinPos= "right"


" Auto-save configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:auto_save = 1
"let g:auto_save_silent = 1  " do not display the auto-save notification
let g:auto_save_events = ["CursorHold"]
let g:updatetime = 1000


" Neoformat configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neoformat_enabled_haskell = ['ormolu']
let g:shfmt_opt='-ci'
let g:neoformat_enabled_c = []

" vim-signify configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=100

