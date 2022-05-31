" First, install vim-plug with
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" Put all backups into a dedicated directory
silent exec "!mkdir -p ~/.vim_backup"
set backupdir=~/.vim_backup//,.
set directory=~/.vim_backup//,.

" Enable line numbers and relative numbers everywhere, and toggle them with "\r"
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

set encoding=UTF-8
set autoindent
set mouse=a
set noshowmode
set splitbelow
set splitright

" Use Control-hjkl to switch between windows
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Display invisible characters (newlines, tabs)
" Shortcut to rapidly toggle `set list`
" The <leader> key is the backslash key \
nmap <leader>l :set list!<CR>

" Prevent NeoVim from remapping Y to y$, keep the classic behaviour which
" yanks the newline character.
nnoremap Y Y

call plug#begin('~/.vim/plugged')
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
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro colorschemes
Plug 'dracula/vim', { 'as': 'dracula' }                 " Dracula colorscheme
Plug 'https://github.com/tpope/vim-commentary'          " Comment/uncomment lines with gcc and gc
Plug 'https://github.com/ap/vim-css-color'              " CSS Color Preview in all files
Plug 'https://github.com/preservim/tagbar'              " Tagbar for code navigation with :TagbarToggle or <F8>
Plug 'https://github.com/cohama/lexima.vim'             " Automatically close parens, quotes, etc while typing
call plug#end()

" Map CTRL-n to a new NERDTree instance against the current directory
" Use CTRL-t to open/close the current NERDTree
" Use CTRL-f to open NERDTree in the current working directory and focus on the current file
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Map <F8> to tagbar
nmap <F8> :TagbarToggle<CR>

" Store orgmode files under ~/env/home/org
lua << EOF
require('orgmode').setup_ts_grammar()
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {'org'},
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'},
}
require('orgmode').setup({
  org_agenda_files = {'~/env/home/org/*'},
  org_default_notes_file = '~/env/home/org/refile.org',
})
EOF

" numbers.nvim config
lua require('numbers').setup()

" Use case insensitive search except when using capital letters
set ignorecase
set smartcase

:colorscheme sonokai
:colorscheme dracula

" For Asciidoc files:
augroup asciidoctor
    au!
    " Mark the 120th column, and wrap long lines with a visual indicator
    au BufEnter *.adoc,*.asciidoc set colorcolumn=120 textwidth=0 wrap linebreak showbreak=↳ breakindent breakindentopt=min:20,shift:2
    au BufEnter *.adoc,*.asciidoc highlight ColorColumn ctermbg=16 guibg=black
    " Create a function to have one sentence per line when using gq
    " Source: https://coastsystems.net/fr/2021/01/astuces-pour-%C3%A9diter-asciidoc-avec-neovim/vim-comme-un-boss/
    function! OneSentencePerLine()
        if mode() =~# '^[iR]'
            return
        endif
        let start = v:lnum
        let end = start + v:count - 1
        execute start.','.end.'join'
        s/[.!?]\zs\s*\ze\S/\r/g
    endfunction
    au BufEnter *.adoc,*.asciidoc set formatexpr=OneSentencePerLine()
augroup END

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
