" Put all backups into a dedicated directory
silent exec "!mkdir -p ~/.vim_backup"
set backupdir=~/.vim_backup//,.
set directory=~/.vim_backup//,.

" Set tabs to 2 spaces
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Display invisible characters (newlines, tabs)
" Shortcut to rapidly toggle `set list`
" The <leader> key is the backslash key \
nmap <leader>l :set list!<CR>

" Prevent NeoVim from remapping Y to y$, keep the classic behaviour which
" yanks the newline character.
nnoremap Y Y

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                               " Sensible defaults
Plug 'arcticicestudio/nord-vim'                         " Nord theme for Vim
Plug 'habamax/vim-asciidoctor'                          " Fast syntax highlighter for asciidoc files, including folding
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " View directory tree with :NERDTree
Plug 'godlygeek/tabular'                                " Tabularise content with :Tabularize /,
Plug 'tpope/vim-surround'                               " Surround regions of text with csiW'
Plug 'vim-airline/vim-airline'                          " Better status bar
Plug 'airblade/vim-gitgutter'                           " Display local changes for files versioned with Git
Plug 'nkakouros-original/numbers.nvim'                  " Deactivate relative line numbers in insert mode
call plug#end()

lua require('numbers').setup()


" Use the Nord theme with a specific color for line numbers
:colorscheme nord
:highlight LineNr guifg=#5e81ac


" Use case insensitive search except when using capital letters
set ignorecase
set smartcase


" Use Control-hjkl to switch between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l


" Enable line numbers and relative numbers everywhere, and toggle them with "\r"
se number
se relativenumber
nmap <leader>r :set relativenumber!<CR>


" For Asciidoc files:
augroup asciidoctor
    au!
    au BufEnter *.adoc,*.asciidoc call AsciidoctorMappings()
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
