" open CommandT automatically when opening a new tab
map <C-w>t <Esc>:tabnew<enter>:CommandT<Enter>
map <C-w><C-t> <Esc>:tabnew<enter>:CtrlPMRU<Enter>



nmap <leader>f :CommandT<CR>
nmap <leader>c :CommandT<CR>

" Replace CtrlP default mapping with CommandT's
let g:ctrlp_map = '<c-]><c-p>'
noremap <C-p> :CommandT<CR>  " Map Control-p to CommandT

" Reverse CommandT results
let g:CommandTMatchWindowReverse = 1
let g:CommandTHighlightColor = 'Ptext'

