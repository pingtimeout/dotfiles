" Map LEADER-A-... to insert asciidoc related content from normal mode
" - LEADER-A-T inserts an AsciiDoc table
" - LEADER-A-C inserts an AsciiDoc code block
" - LEADER-A-I inserts an AsciiDoc image
nnoremap <leader>at :r ~/dotfiles/vim/abbreviations/asciidoc-table.adoc<CR>
nnoremap <leader>ac :r ~/dotfiles/vim/abbreviations/asciidoc-code-block.adoc<CR>
nnoremap <leader>ai :r ~/dotfiles/vim/abbreviations/asciidoc-image.adoc<CR>

" Fold Asciidoc sections
let g:asciidoctor_folding = 1
