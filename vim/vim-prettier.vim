" Autoformat files on save without @format or @prettier tags
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

augroup PrettierFileDetect
  autocmd BufNewFile,BufReadPost *.mts setfiletype typescript
augroup end
