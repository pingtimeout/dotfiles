" vim: textwidth=200 colorcolumn=200

"
" First, install vim-plug with
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"

"
" This file contains vim-specific configuration settings. For plugin-specific configuration, look for $HOME/.config/nvim/plugin.d/$plugin.vim.
"

" Before doing anything else, remap leader key to space so that all key bindings use the correct leader.
nnoremap <SPACE> <Nop>
nnoremap \ :echohl DraculaRedInverse \| echo "Leader key is SPACE" \| echohl None<CR>
let mapleader = " "

" Load all plugins so that configuration options take precedence and things like the colorscheme can be applied.
call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-sensible'                               " Sensible defaults
Plug 'habamax/vim-asciidoctor'                          " Fast syntax highlighter for asciidoc files, including folding
Plug 'preservim/nerdtree'                               " View directory tree with :NERDTree or with <CTRL-t> and <CTRL-f>
Plug 'godlygeek/tabular'                                " Tabularise content with :Tabularize /,
Plug 'tpope/vim-surround'                               " Surround regions of text with csiW'
Plug 'vim-airline/vim-airline'                          " Better status bar
Plug 'airblade/vim-gitgutter'                           " Display local changes for files versioned with Git
Plug 'nkakouros-original/numbers.nvim'                  " Deactivate relative line numbers in insert mode
Plug 'nvim-treesitter/nvim-treesitter'                  " Required for orgmode
Plug 'nvim-orgmode/orgmode'                             " Orgmode for vim
Plug 'dracula/vim', { 'as': 'dracula' }                 " Dracula colorscheme
Plug 'https://github.com/tpope/vim-commentary'          " Comment/uncomment lines with gcc and gc
Plug 'https://github.com/ap/vim-css-color'              " CSS Color Preview in all files
Plug 'https://github.com/preservim/tagbar'              " Tagbar for code navigation with :TagbarToggle or <F8>
Plug 'https://github.com/cohama/lexima.vim'             " Automatically close parens, quotes, etc while typing
Plug 'https://github.com/airblade/vim-rooter'           " Automatically change directory when opening a file
Plug 'dpelle/vim-LanguageTool'                          " Check grammatical and syntax mistakes with :LanguageToolCheck
Plug 'pedrohdz/vim-yaml-folds'                          " Better folding in YAML files
Plug 'Asheq/close-buffers.vim'                          " Buffer management
Plug 'dense-analysis/ale'                               " Lint engine support for yaml files
Plug 'martinda/Jenkinsfile-vim-syntax'                  " Support Jenkinsfile filetype
Plug 'fladson/vim-kitty'                                " Kitty config syntax
Plug 'akinsho/org-bullets.nvim'                         " Unicode bullets for orgmode
"Plug 'milisims/tree-sitter-org'                         " Treesitter for orgmode
Plug 'gyim/vim-boxdraw'                                 " Plugin to draw simple ASCII diagrams with +o and +O, and lines with +- or +_ or +>
Plug 'hashivim/vim-terraform'                           " Plugin to support tf files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Program to search files
Plug 'junegunn/fzf.vim'                                 " Plugin to search files
call plug#end()

" If a plugin-specific configuration exists, load it
for plugin in keys(g:plugs)
  let plugin = substitute(plugin, '\v\.(nvim|vim)', "", "")
  let s:plugin_config = $HOME . '/.config/nvim/plugin.d/' . plugin . '.vim'
  "echo 'Checking if ' . s:plugin_config . ' exists...'
  if filereadable(s:plugin_config)
    "echo 'Sourcing ' . s:plugin_config
    execute 'source ' . s:plugin_config
  endif
endfor

" Use 24-bits colors instead 256 colors and ctermbg/fg
set termguicolors

" Put all backups into a dedicated directory instead of in the current directory.
silent exec "!mkdir -p ~/.vim_backup"
set backupdir=~/.vim_backup//,.
set directory=~/.vim_backup//,.

" Enable line numbers and relative numbers everywhere, and toggle them with "\r".
set number
set relativenumber
nmap <leader>r :set relativenumber!<CR>

" Set tabs to 2 spaces
set tabstop=2
set shiftwidth=2
set smarttab
set softtabstop=2
set expandtab

" Ensure that enough lines are shown before/after cursor for context
set scrolloff=10

set updatetime=100
set encoding=UTF-8
set autoindent
set mouse=a
set noshowmode
set splitbelow
set splitright
:colorscheme dracula

" Use Control-hjkl to switch between windows
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Add French and English as spell checked languages and only show the top 10 suggestions.
" Additionally, map <leader>s to enable spell checking.
set spelllang=en,fr
set spellsuggest=best,10
nnoremap <silent> <leader>s :set spell!<cr>

" Display invisible characters (newlines, tabs)
" Shortcut to rapidly toggle `set list`
" The <leader> key is the backslash key \
nmap <leader>l :set list!<CR>

" Prevent NeoVim from remapping Y to y$, keep the classic behaviour which
" yanks the newline character.
nnoremap Y Y

" Use case insensitive search except when using capital letters
set ignorecase
set smartcase

" In VimR, map Cmd-[ and Cmd-] to previous/next tab, respectively
nnoremap <leader>[ :tabprevious<CR>
nnoremap <leader>] :tabnext<CR>

" Go beyond the end of line in visual mode
:set virtualedit+=all

" Store orgmode files under ~/env/home/org
"lua << EOF
"require('org-bullets').setup()
"EOF

"lua << EOF
"local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
"parser_config.org = {
"  install_info = {
"    url = 'https://github.com/milisims/tree-sitter-org',
"    revision = 'main',
"    files = { 'src/parser.c', 'src/scanner.cc' },
"  },
"  filetype = 'org',
"}
"EOF

" For Asciidoc files:
"augroup asciidoctor
"    autocmd!
"    " Mark the 120th column, and wrap long lines with a visual indicator
"    au BufEnter *.adoc,*.asciidoc set colorcolumn=120 textwidth=0 wrap linebreak showbreak=↳ breakindent breakindentopt=min:20,shift:2
"    au BufEnter *.adoc,*.asciidoc highlight ColorColumn ctermbg=16 guibg=black
"    " Create a function to have one sentence per line when using gq
"    " Source: https://coastsystems.net/fr/2021/01/astuces-pour-%C3%A9diter-asciidoc-avec-neovim/vim-comme-un-boss/
"    function! OneSentencePerLine()
"        if mode() =~# '^[iR]'
"            return
"        endif
"        let start = v:lnum
"        let end = start + v:count - 1
"        execute start.','.end.'join'
"        s/[.!?]\zs\s*\ze\S/\r/g
"    endfunction
"    au BufEnter *.adoc,*.asciidoc set formatexpr=OneSentencePerLine()
"augroup END
"
"augroup yamlfiles
"  autocmd!
"  " Source => https://www.arthurkoziel.com/setting-up-vim-for-yaml/
"  " If not already the case, ensure that spaces are used and that an indentation level is 2 spaces
"  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
"  " Use a visible character for indentation levels => is easier to read
"  let g:indentLine_char = '⦙'
"  " Fold levels above 20 => do not fold anything when opening a file
"  set foldlevelstart=20
"augroup END
"
"" Blink the cursor line when searching through matches to locate cursor more easily
"nnoremap <silent> n n:call HLNext(100)<CR>
"nnoremap <silent> N N:call HLNext(100)<CR>
"function! HLNext (blinktime)
"  set invcursorline
"  redraw
"  exec 'sleep ' . a:blinktime . 'm'
"  set invcursorline
"  redraw
"endfunction
"

" ------------------------------------------------------------------------------
"                            surround.vim tutorial
" ------------------------------------------------------------------------------
"
" Press cs"' inside "Hello world!" to change it to 'Hello world!'
" Now press cs'<q> inside 'Hello world!' to change it to <q>Hello world!</q>
" To go full circle, press cst" to get "Hello world!"
"
" To remove the delimiters entirely, press ds" in "Hello world!"
"
" Now with the cursor on Hello, press ysiw] (iw is a text object).
" "Hello world!" will bebome "[Hello] world!"
"
" It also works with braces using ysiw} and parentheses using ysiw)
"
" Now wrap the entire line in parentheses with yssb or yss).

