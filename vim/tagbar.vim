" Map <F8> to tagbar
nmap <F8> :TagbarToggle<CR>

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
