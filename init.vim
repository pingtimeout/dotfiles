" vim: textwidth=200 colorcolumn=200

"
" First, install vim-plug with
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"

"
" This file contains vim-specific configuration settings. For plugin-specific configuration, look for $HOME/.config/nvim/plugin.d/$plugin.vim.
"

" Put all backups into a dedicated directory instead of in the current directory.
silent exec "!mkdir -p ~/.vim_backup"
set backupdir=~/.vim_backup//,.
set directory=~/.vim_backup//,.

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
syntax enable
set background=dark
colorscheme solarized
" :colorscheme dracula

" Add French and English as spell checked languages and only show the top 10 suggestions.
" Additionally, map <leader>s to enable spell checking.
set spelllang=en,fr
set spellsuggest=best,10
nnoremap <silent> <leader>s :set spell!<cr>

" Prevent NeoVim from remapping Y to y$, keep the classic behaviour which
" yanks the newline character.
nnoremap Y Y

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

