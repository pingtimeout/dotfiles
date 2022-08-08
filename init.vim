" First, install vim-plug with
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" Set leader key to space
nnoremap <SPACE> <Nop>
nnoremap \ :echohl DraculaRedInverse \| echo "Leader key is SPACE" \| echohl None<CR>
let mapleader = " "

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

set updatetime=100
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
Plug 'dracula/vim', { 'as': 'dracula' }                 " Dracula colorscheme
Plug 'https://github.com/tpope/vim-commentary'          " Comment/uncomment lines with gcc and gc
Plug 'https://github.com/ap/vim-css-color'              " CSS Color Preview in all files
Plug 'https://github.com/preservim/tagbar'              " Tagbar for code navigation with :TagbarToggle or <F8>
Plug 'https://github.com/cohama/lexima.vim'             " Automatically close parens, quotes, etc while typing
Plug 'https://github.com/airblade/vim-rooter'           " Automatically change directory when opening a file
Plug 'dpelle/vim-LanguageTool'                          " Check grammatical and syntax mistakes with :LanguageToolCheck
Plug 'pedrohdz/vim-yaml-folds'                          " Better folding in YAML files
Plug 'Asheq/close-buffers.vim'                          " Buffer management
call plug#end()

" Map main NERDTree commands under <LEADER>-n
" - LEADER-n-n opens a new NERDTree instance against the current directory
" - LEADER-n-t opens/closes the current NERDTree
" - LEADER-n-f opens NERDTree in the current working directory and focus on the current file
nnoremap <leader>nn :NERDTree<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" Map main LanguageTool commands under <LEADER>-l
" - LEADER-l-c runs LanguageTool checks and show them in a split window
" - LEADER-l-x clears the LanguageTool checks
nnoremap <leader>lc :LanguageToolCheck<CR>
nnoremap <leader>lx :LanguageToolClear<CR>

" Map close-buffers.vim menu under <LEADER>-b-m
" List all buffers with <LEADER>-b-l
nnoremap <leader>bu :unhide<CR>
nnoremap <leader>bl :buffers<CR>
nnoremap <leader>bm :Bdelete menu<CR>

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
  org_capture_templates = {
    t = {
      description = 'Task',
      template = '* TODO %?\n %u'
    },
    r = {
      description = 'Request',
      template = '* TODO %?\n** What is the context of the request?\n** Why is this timeline required?\n** What is the problem that needs solved?\n  %u',
      target = '~/env/home/org/dremio.org',
    },
  },
})
EOF

" Setup numbers.nvim
lua require('numbers').setup()

" Use case insensitive search except when using capital letters
set ignorecase
set smartcase

" Automatically change directory only in the current tab
let g:rooter_cd_cmd = 'tcd'
" The new current working directory should be the deepest directory that contains one of these files/dirs
let g:rooter_patterns = ['.git', 'Makefile', 'src']

:colorscheme dracula

" For Asciidoc files:
augroup asciidoctor
    autocmd!
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

augroup yamlfiles
  autocmd!
  " Source => https://www.arthurkoziel.com/setting-up-vim-for-yaml/
  " If not already the case, ensure that spaces are used and that an indentation level is 2 spaces
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  " Use a visible character for indentation levels => is easier to read
  let g:indentLine_char = '⦙'
  " Fold levels above 20 => do not fold anything when opening a file
  set foldlevelstart=20
  " Only lint the yaml when the file is saved
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_sign_error = '✘'
  let g:ale_sign_warning = '⚠'
  let g:ale_lint_on_text_changed = 'never'
augroup END

" Do not specify LanguageTool jar as `java` may not be accessible unless SdkMan has already been loaded
" Instead, use the system-wide runner.
" Also, disable the rule that matches open/close brackets as Asciidoc open brackets for URLs are not parsed correctly.
let g:languagetool_cmd='/usr/local/bin/languagetool'
let g:languagetool_disable_rules='EN_UNPAIRED_BRACKETS'

" Blink the cursor line when searching through matches to locate cursor more easily
nnoremap <silent> n n:call HLNext(100)<CR>
nnoremap <silent> N N:call HLNext(100)<CR>
function! HLNext (blinktime)
  set invcursorline
  redraw
  exec 'sleep ' . a:blinktime . 'm'
  set invcursorline
  redraw
endfunction

" In VimR, map Cmd-[ and Cmd-] to previous/next tab, respectively
nnoremap <leader>[ :tabprevious<CR>
nnoremap <leader>] :tabnext<CR>

" Map LEADER-A-... to insert asciidoc related content from normal mode
" - LEADER-A-T inserts an AsciiDoc table
" - LEADER-A-C inserts an AsciiDoc code block
" - LEADER-A-I inserts an AsciiDoc image
nnoremap <leader>at :r ~/dotfiles/vim/abbreviations/asciidoc-table.adoc<CR>
nnoremap <leader>ac :r ~/dotfiles/vim/abbreviations/asciidoc-code-block.adoc<CR>
nnoremap <leader>ai :r ~/dotfiles/vim/abbreviations/asciidoc-image.adoc<CR>

" Fold Asciidoc sections
let g:asciidoctor_folding = 1

let g:tagbar_type_asciidoctor = {
    \ 'ctagstype' : 'asciidoc',
    \ 'kinds'     : [
          \ 'c:chapter:0:1',
          \ 's:section:0:1',
          \ 'S:subsection:0:1',
          \ 't:subsubsection:0:1',
          \ 'T:paragraph:0:1',
          \ 'u:subparagraph:0:1',
          \ 'a:anchor:0:0',
    \ ],
    \ 'sro'        : '""',
    \ 'kind2scope' : {
          \ 'c' : 'chapter',
          \ 's' : 'section',
          \ 'S' : 'subsection',
          \ 't' : 'subsubsection',
          \ 'T' : 'l4subsection',
          \ 'u' : 'l5subsection',
    \ },
    \ 'scope2kind' : {
          \ 'chapter' : 'c',
          \ 'section' : 's',
          \ 'subsection' : 'S',
          \ 'subsubsection' : 't',
          \ 'l4subsection' : 'T',
          \ 'l5subsection' : 'u',
    \ },
    \ 'sort' : 0,
    \ }

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
