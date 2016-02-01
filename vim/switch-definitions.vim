" Usar BACKSPACE para hacer el switch

let g:switch_custom_definitions =
      \ [
      \   ["true", "false"],
      \   ["on", "off"],
      \   ["On", "Off"],
      \ ]


" Ejemplo de switchs definidos por filetype

autocmd FileType php let b:switch_custom_definitions =
      \ [
      \   ["php", "test"],
      \   { 'if(true || \(.\{-}\))': 'if\(false && \1\)' },
      \   { 'if(false && \(.\{-}\))': 'if\(\1\)' },
      \   { 'if(\(.\{-}\))': 'if\(true || \1\)' },
      \ ]
