" Map main LanguageTool commands under <LEADER>-l
" - LEADER-l-c runs LanguageTool checks and show them in a split window
" - LEADER-l-x clears the LanguageTool checks
nnoremap <leader>lc :LanguageToolCheck<CR>
nnoremap <leader>lx :LanguageToolClear<CR>

" Do not specify LanguageTool jar as `java` may not be accessible unless SdkMan has already been loaded
" Instead, use the system-wide runner.
" Also, disable the rule that matches open/close brackets as Asciidoc open brackets for URLs are not parsed correctly.
let g:languagetool_cmd='/usr/local/bin/languagetool'
let g:languagetool_disable_rules='EN_UNPAIRED_BRACKETS'
