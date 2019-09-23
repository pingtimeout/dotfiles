" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Set tabs to 4 spaces
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" Display invisible characters (newlines, tabs) {{{
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
 
" Mark trailing spaces by a dot, tabs with a > sign, and eol with $
set listchars=trail:.,extends:>,tab:>\ ,eol:$

" ------------------------------------------------------------------------------
"                             PLA Custom config
" ------------------------------------------------------------------------------

" vim.plug seems to be a better package manager
call plug#begin('~/.vim/plugged')
Plug 'habamax/vim-asciidoctor'                          " Fast syntax highlighter for asciidoc files, including folding
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " View directory tree with :NERDTree
Plug 'dpelle/vim-LanguageTool'                          " Check language with :LanguageToolCheck and :LanguageToolClear
Plug 'godlygeek/tabular'                                " Tabularise content with :Tabularize /,
Plug 'plasticboy/vim-markdown'                          " Markdown support in vim, including folding with zo zO and others
Plug 'tpope/vim-surround'                               " Surround regions of text with csiW'
call plug#end()

" ---  vim-asciidoctor configuration ---
let g:asciidoctor_executable = 'asciidoctor'
let g:asciidoctor_extensions = ['asciidoctor-diagram']
let g:asciidoctor_pdf_executable = 'asciidoctor-pdf'
let g:asciidoctor_pdf_extensions = ['asciidoctor-diagram']
let g:asciidoctor_pandoc_executable = 'pandoc'
let g:asciidoctor_folding = 1
let g:asciidoctor_fold_options = 1
fun! AsciidoctorMappings()
	nnoremap <buffer> <leader>oo :AsciidoctorOpenRAW<CR>
	nnoremap <buffer> <leader>op :AsciidoctorOpenPDF<CR>
	nnoremap <buffer> <leader>oh :AsciidoctorOpenHTML<CR>
	nnoremap <buffer> <leader>ch :Asciidoctor2HTML<CR>
	nnoremap <buffer> <leader>cp :Asciidoctor2PDF<CR>
endfun
augroup asciidoctor
	au!
	au BufEnter *.adoc,*.asciidoc call AsciidoctorMappings()
augroup END
" --- /vim-asciidoctor configuration ---

" Default colorscheme : slate is slightly better than elflord on remote terminals
colorscheme desert

" Use Control-hjkl to switch between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Use zsh-like autocompletion menu
set wildmenu
set wildmode=full

" Increase command history size
set history=200

" Display relative line numbers before/after cursor
" Display absolute line number at cursor
set number
set relativenumber

" Start NERDTree automatically
" 2018-05-22 do not start NERD tree automatically since it takes a long time
" to scan $HOME when MacVim is started from Alfred
"autocmd vimenter * if !argc() | NERDTree | endif

" Enable modelines for per-file vim settings overrides
set modeline
set modelines=5

" Enable Fira Code in MacVim
if has("gui_running")
  set macligatures
  set guifont=Fira\ Code:h12
endif

" Configure LanguageTool
let g:languagetool_jar='$HOME/env/opt/LanguageTool-3.5/languagetool-commandline.jar'

" Custom syntax files for unsupported filetypes
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufNewFile,BufRead *.plt,*.gnuplot setf gnuplot
augroup END
