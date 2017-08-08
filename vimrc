" Source this buffer like this:    gg VGy    <Esc> :@"

" Or source it from the Internet directly:
"        :so http://jaku.com.ar/vimrc

" --- Sanity defaults ------------------------------------------------------ {{{
set nocompatible
scriptencoding utf-8
set encoding=utf-8

" Make Y behave like D and C
nnoremap Y y$
" Make y% yank the entire buffer
nnoremap y% mw ggyG `w
" Allow 1500 millisecond timeout for key sequences (instead of 1000)
"set timeoutlen=2500     " replaced by the following:

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Assumes a fast console and updates the screen more.
set ttyfast
" Redraws the screen after all changes are completed (ie, after repeating a
" macro several times)
set lazyredraw
" Resize panes inside tmux and screen
set ttymouse=xterm2
set foldmethod=marker
set foldlevelstart=99 " Sick of having to zR all the time
set nofoldenable      " disable folding
let g:DisableAutoPHPFolding = 1  " PIV plugin
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

set complete+=k
set dictionary-=~/.vim/dictionaries/user.txt
set dictionary+=~/.vim/dictionaries/user.txt
au FileType * execute 'setlocal dict+=~/.vim/dictionaries/'.&filetype.'.txt'

"silent! colorscheme desert
"silent! colorscheme vividchalk
silent! colorscheme molokai
"silent! colorscheme seoul256


" Custom overrides to colorscheme
hi Comment         ctermfg=15  ctermbg=237


" Transparent background so we can see the terminal program's background image
" (had to move this below VimPlug because it was overriding it)
" highlight Normal ctermbg=NONE
" highlight NonText ctermbg=NONE

if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
endif

"set gfn=Inconsolata\ Medium\ 10
"set gfn=DejaVu\ Sans\ Mono\ 10
set gfn=DejaVu\ Sans\ Mono\ for\ Powerline\ 10

set printfont=DejaVu\ Sans\ Mono:h10

" Better navigation for long lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

set whichwrap+=<,>,[,]

" source $VIMRUNTIME/mswin.vim
" behave mswin

"set t_ut=
"set t_Co=256

set encoding=utf-8 "For the terminal, not the files
set fileencoding=utf-8 "For the terminal, not the files
set ffs=unix,dos,mac "Default file types

set nobackup
set noswapfile

set expandtab

set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set wildmenu "Turn on WiLd menu

set cmdheight=2 "The commandbar height

"set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set splitright    " vertical splits open right from the current window

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class,*/tmp/*,*.so,*\\tmp\\*,*.swp,*.zip,
               \*.exe,*.gif,*.png,*.jpg
set title                " change the terminal's title
set scrolloff=3
set textwidth=80
set colorcolumn=+1
set formatoptions=qrnlj

if version >= 703
  " tell it to use an undo file
  set undofile
  " set a directory to store the undo history
  set undodir=~/.vimundo/
endif

"set shortmess=atI

set guioptions-=m  "remove menu bar, still accesible via F10
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar

" Make Vim able to edit crontab files again
set backupskip=/tmp/*,/private/tmp/*"

" }}}
" --- Customizations ------------------------------------------------------- {{{

""""""""""""""""""""""""""""""
" => Line Return
""""""""""""""""""""""""""""""

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

""""""""""""""""""""""""""""""
" => Save when losing focus
""""""""""""""""""""""""""""""
au FocusLost * :silent! wall

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

""""""""""""""""""""""""""""""
" => Tabline
""""""""""""""""""""""""""""""
" Hide the Tabline, since it will be controlled with CtrlSpace plugin (<C-Space>l)
" set showtabline=0
"nnoremap <C-Space> :CtrlSpace<CR>
let g:ctrlspace_default_mapping_key = "<C-s>"


""""""""""""""""""""""""""""""
" => CtrlSpace Colors
""""""""""""""""""""""""""""""
hi CtrlSpaceSelected term=reverse ctermfg=187   guifg=#d7d7af ctermbg=23    guibg=#005f5f cterm=bold gui=bold
hi CtrlSpaceNormal   term=NONE    ctermfg=244   guifg=#808080 ctermbg=232   guibg=#080808 cterm=NONE gui=NONE
hi CtrlSpaceSearch   ctermfg=220  guifg=#ffd700 ctermbg=NONE  guibg=NONE    cterm=bold    gui=bold
hi CtrlSpaceStatus   ctermfg=230  guifg=#ffffd7 ctermbg=234   guibg=#1c1c1c cterm=NONE    gui=NONE



function! CurDir()
    let curdir = substitute(getcwd(), '/home/sebas/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

" Format the closed fold line
function! MyFoldText()
let line = getline(v:foldstart)

let nucolwidth = &fdc + &number * &numberwidth
let windowwidth = winwidth(0) - nucolwidth - 3
let foldedlinecount = v:foldend - v:foldstart

" expand tabs into spaces
let onetab = strpart('          ', 0, &tabstop)
let line = substitute(line, '\t', onetab, 'g')
let line = substitute(line, '{{{', '', 'g') "}}} do not remove this comment

let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 1
  return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . ' ' . '…' . ' '
  endfunction " 
set foldtext=MyFoldText()


"Makes f and t work across multiple lines
nnoremap <silent> f :call FindChar(0, 0, 0)<cr>
onoremap <silent> f :call FindChar(0, 1, 0)<cr>
nnoremap <silent> F :call FindChar(1, 0, 0)<cr>
onoremap <silent> F :call FindChar(1, 1, 0)<cr>
nnoremap <silent> t :call FindChar(0, 0, 1)<cr>
onoremap <silent> t :call FindChar(0, 0, 0)<cr>
nnoremap <silent> T :call FindChar(1, 0, 1)<cr>
onoremap <silent> T :call FindChar(1, 0, 0)<cr>


" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" C-a y C-e to jump to beginning and ending of line just like in bash and zsh
inoremap <C-a> <esc>I " implementar version <expr> que se fije si getline(".")[col(".")-1] (char under cursor) es un número
" si es un número debe emitir el <C-a> nativo.
inoremap <C-e> <esc>A

" Say something
function! Say(something)
 let x = system("say ".a:something) 
 return
endfunction

" Decir algo
function! Decir(something)
 let x = system("decir ".a:something) 
 return
endfunction

" Zip Right
"
" Moves the character under the cursor to the end of the line.  Handy when you
" have something like:
"
"     foo
"
" And you want to wrap it in a method call, so you type:
"
"     println()foo
"
" Once you hit escape your cursor is on the closing paren, so you can 'zip' it
" over to the right with this mapping.
"
" This should preserve your last yank/delete as well.
nnoremap zl :let @z=@"<cr>x$p:let @"=@z<cr>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
" <Space> is a handy leader
nnoremap <Space> <Nop>
let mapleader = "\<Space>"

iabbrev slg "Sebastián Grignoli" <grignoli@gmail.com>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ,p Prepara y ,a Aplica un patron
"    $x = array("{{1}}_{{1}}"=>"{{2}}");       <=  ,p
"    texto,otro                          <=  ,a
" queda:
"    $x = array("texto_texto"=>"otro");
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ApplyPattern()
  let pattern = @r
  let li = split(getline('.'), ',')
  let c = 0
  for word in li
    let tag = '{{'.(c+1).'}}'
    let pattern = substitute(pattern, tag, word, 'g')
    let c += 1
  endfor
  echom(substitute(pattern,"\n$","x",""))
  call setline(line("."),substitute(pattern, "\n$", "", ''))
endfunction

nnoremap ,p "ryy
vnoremap ,p "ryy
nnoremap ,a :call ApplyPattern()<cr>j

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Additional text objects
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALIASES FOR SPEED
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Move lines up and down
nnoremap <C-j> ddp
nnoremap <C-k> ddkkp

" ALT-Up, ALT-Down -> Navigate buffers
noremap <M-Up> <Esc>:bprevious<Enter>
noremap <M-Down> <Esc>:bnext<Enter>
noremap gB <Esc>:BufSurfBack<Enter>
noremap gb <Esc>:BufSurfForward<Enter>


" Function for abbreviating commands without messing with the whole command
  " line.  Do not use cabbrev for commands!  Use Cabbrev instead.
fu! Cabbrev(key, value)
  exe printf('cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s', a:key, 1+len(a:key), string(a:value), string(a:key))
endfu

" Edit Symfony schema
call Cabbrev("Sch","e app/model/schema.yml")

" hide buffers instead of closing them.
" (needed by LustyExplorer and CtrlSpace)
set hidden

" Only search for matching parentheses for 5 milliseconds.  Abort if nothing found.
let g:matchparen_insert_timeout=5

" Teclas de funcion
inoremap <F7> <Esc>:vertical res +1<Enter>
nnoremap <F7> :vertical res +1<Enter>

inoremap <F8> <Esc>:vertical res -1<Enter>
nnoremap <F8> :vertical res -1<Enter>

" %% Expands to current buffer's path
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" [S]plit line (sister to [J]oin lines)
" cc still substitutes the line like S would
nnoremap S i<CR><Esc>^mwgk:silent! s/\v +$//<CR>:noh<CR>

" Change word and repeat for next or previous with .
nnoremap <leader>c *``cgn
nnoremap <leader>C #``cgN

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" open and close:
"inoremap ( ()<Left>
" open and close a block:
"inoremap (<Enter> (<Enter><Enter>)<Up><Space><Space>
" jump over closing character:
"inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

"inoremap [ []<Left>
"inoremap [<Enter> [<Enter><Enter>]<Up><Space><Space>
"inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"

"inoremap { {}<Left>
"inoremap {<Enter> {<Enter><Enter>}<Up><Space><Space>
"inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"

" open and close, or jump over closing character:
"inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
"inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
"inoremap <expr> ` strpart(getline('.'), col('.')-1, 1) == "\`" ? "\<Right>" : "\`\`\<Left>"

inoremap <? <?php<Space><Space>?><Left><Left><Left>
inoremap <a <a<Space>href=""></a><Left><Left><Left><Left><Left><Left>
inoremap <d <div></div><Left><Left><Left><Left><Left><Left>
inoremap <bo <body></body><Left><Left><Left><Left><Left><Left><Left>
inoremap <br <br/>
inoremap <ht <html></html><Left><Left><Left><Left><Left><Left><Left>
inoremap <h1 <h1></h1><Left><Left><Left><Left><Left>
inoremap <h2 <h2></h2><Left><Left><Left><Left><Left>
inoremap <h3 <h3></h3><Left><Left><Left><Left><Left>
inoremap <h4 <h4></h4><Left><Left><Left><Left><Left>
inoremap <u <ul></ul><Left><Left><Left><Left><Left>
inoremap <l <li></li><Left><Left><Left><Left><Left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart way to move between windows
"map <C-h> <C-W>h
"map <C-j> <C-W>j
"map <C-k> <C-W>k
"map <C-l> <C-W>l
" and Tabs!
map <C-w><C-t> <Esc>:tabnew<enter>

" Split vertically and explore
nnoremap <C-w><C-e> <C-w>v:Ex<enter>


inoremap <F5> <Esc>:bp<Enter>
nnoremap <F5> :bp<Enter>
vnoremap <F5> :bp<Enter>

nnoremap <leader>, :bp<Enter>
vnoremap <leader>, :bp<Enter>

inoremap <F6> <Esc>:bn<Enter>
nnoremap <F6> :bn<Enter>
vnoremap <F6> :bn<Enter>

nnoremap <leader>. :bn<Enter>
vnoremap <leader>. :bn<Enter>



""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUN SHELL COMMAND AND SEND OUTPUT TO A SCRATCH WINDOW
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:ExecuteInShell(command, bang)
  let _ = a:bang != '' ? s:_ : a:command == '' ? '' : join(map(split(a:command), 'expand(v:val)'))

  if (_ != '')
    let s:_ = _
    let bufnr = bufnr('%')
    let winnr = bufwinnr('^' . _ . '$')
    "    silent! execute  winnr < 0 ? 'belowright new ' . fnameescape(_) : winnr . 'wincmd w'
    silent! execute  winnr < 0 ? 'vertical belowright new ' . fnameescape(_) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile wrap number
    silent! :%d
    let message = 'Execute ' . _ . '...'
    call append(0, message)
    echo message
    silent! 2d | resize 1 | redraw
    silent! execute 'silent! %!'. _
    silent! execute 'resize ' . line('$')
    silent! execute 'syntax on'
    silent! execute 'autocmd BufUnload <buffer> execute bufwinnr(' . bufnr . ') . ''wincmd w'''
    silent! execute 'autocmd BufEnter <buffer> execute ''resize '' .  line(''$'')'
    silent! execute 'nnoremap <silent> <buffer> <CR> :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>g :execute bufwinnr(' . bufnr . ') . ''wincmd w''<CR>'
    nnoremap <silent> <buffer> <C-W>_ :execute 'resize ' . line('$')<CR>
    silent! syntax on
  endif
endfunction
command! -complete=shellcmd -nargs=* -bang Shell call s:ExecuteInShell(<q-args>, '<bang>')
call Cabbrev("shell", "Shell")






" DestroyAllSoftware screencast tricks:



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UltiSnips mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:UltiSnipsExpandTrigger       = '<tab>'
let g:UltiSnipsExpandTrigger       = '<F5>'
let g:UltiSnipsListSnippets        = '<c-tab>'
let g:UltiSnipsJumpForwardTrigger  = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsEditSplit           = "vertical"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  end
endfunction

command! RenameFile call s:RenameFile()
call Cabbrev("ren", "Rename")
call Cabbrev("mv", "Rename")


" End of DestroyAllSoftware screencast tricks


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Change :sa to saveas but under current file path
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Define SaveasSamePath
command! -nargs=1 SaveasSamePath exe "sav " . expand("%:p:h") . "/" . expand("<args>")
ca sa SaveasSamePath

" Define EditSamePath
command! -nargs=1 EditSamePath exe "edit " . expand("%:p:h") . "/" . expand("<args>")


"nnoremap <leader>t :Tlist<CR>
"nnoremap <leader>t :Tagbar<CR>


" don't throw a warning if Ruby is not installed:
let g:LustyExplorerSuppressRubyWarning = 1

let g:CSApprox_verbose_level = 0


""""""""""""""""""""""""""""""
" => LustyExplorer mappings
""""""""""""""""""""""""""""""
nnoremap ,f :LustyFilesystemExplorerFromHere<cr>
nnoremap ,b :LustyBufferExplorer<cr>
nnoremap ,g :LustyBufferGrep<cr>


""""""""""""""""""""""""""""""
" => lhs comments
""""""""""""""""""""""""""""""
vnoremap z# :s/^/#/<CR>:nohlsearch<CR>
vnoremap z/ :s/^/\/\//<CR>:nohlsearch<CR>
vnoremap z> :s/^/> /<CR>:nohlsearch<CR>
vnoremap z" :s/^/\"/<CR>:nohlsearch<CR>
vnoremap z% :s/^/%/<CR>:nohlsearch<CR>
vnoremap z! :s/^/!/<CR>:nohlsearch<CR>
vnoremap z; :s/^/;/<CR>:nohlsearch<CR>
vnoremap z- :s/^/-- /<CR>:nohlsearch<CR>
vnoremap z0 :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:nohlsearch<CR>


""""""""""""""""""""""""""""""
" => Wrapping comments
""""""""""""""""""""""""""""""
vnoremap z* :s/^\(.*\)$/\/\* \1 \*\//<CR>:nohlsearch<CR>
vnoremap z( :s/^\(.*\)$/\(\* \1 \*\)/<CR>:nohlsearch<CR>
vnoremap z< :s/^\(.*\)$/<!-- \1 -->/<CR>:nohlsearch<CR>
vnoremap Z0 :s/^\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$/\2/<CR>:nohlsearch<CR>


""""""""""""""""""""""""""""""
" => Toggle Mouse Plugin
""""""""""""""""""""""""""""""
fun! s:ToggleMouse()
  if !exists("s:old_mouse")
    let s:old_mouse = "a"

  endif

  if &mouse == ""
    let &mouse = s:old_mouse
    echo "Mouse is for Vim (" . &mouse . ")"
  else
    let s:old_mouse = &mouse
    let &mouse=""
    echo "Mouse is for terminal"
  endif
endfunction

noremap <F12> :call <SID>ToggleMouse()<CR>
inoremap <F12> <Esc>:call <SID>ToggleMouse()<CR>a

let &mouse = "a"



""""""""""""""""""""""""""""""
" => Change cursor in different modes
""""""""""""""""""""""""""""""

" Gnome-Terminal
if !exists("vimrc_autocommands_cursor_loaded")
  let vimrc_autocommands_cursor_loaded = 1
  if has("autocmd")
    if executable("gconftool-2")
      au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
      au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
      au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
    endif
  endif
endif

" Konsole
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

function! s:disableCursorShape()
let &t_SI = ""
let &t_EI = ""
endfunction

nnoremap <leader><F12> :call <SID>disableCursorShape()<CR>

" Set X Window clipboard as the default register
set clipboard=unnamedplus

let g:ctrlp_working_path_mode = "rc"
let g:ctrlp_root_markers = ["symfony",".git"]
let g:ctrlp_use_cache = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_lazy_update = 150
let g:ctrlp_mruf_max = 1500
let g:ctrlp_max_height = 35



if executable("ag")
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

if !exists("vimrc_autocommands_completion_loaded")
  let vimrc_autocommands_completion_loaded = 1
  if has("autocmd")
    autocmd FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType c setlocal omnifunc=ccomplete#Complete

    "let g:SuperTabClosePreviewOnPopupClose = 1
    " Estas lineas hacen lo mismo que la anterior cuando no esta instalado SuperTab:
    " autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    " autocmd InsertLeave * if pumvisible() == 0|pclose|endif

    " Resalta todas las ocurrencias de la palabra que está bajo el cursor en modo normal.
    " autocmd CursorMoved * exe printf('match MatchCurrent /\V\<%s\>/', escape(expand('<cword>'), '/\'))

    "hi MatchCurrent  ctermfg=229    cterm=underline
    hi MatchCurrent  ctermfg=214    cterm=underline
    "hi MatchCurrent  guifg=#E6DB74  gui=underline
    hi MatchCurrent  guifg=#FF2820  gui=underline
  endif
endif

"Functions
fun! FindChar(back, inclusive, exclusive)
  let flag = 'W'
  if a:back
    let flag = 'Wb'
  endif
  let g:lastfsearchquery = getchar()
  if search('\V' . nr2char(g:lastfsearchquery), flag)
    if a:inclusive
      norm! l
    endif
    if a:exclusive
      norm! h
    endif
    let g:lastfsearchback = a:back
    let g:lastfsearchinclusive = a:inclusive
    let g:lastfsearchexclusive = a:exclusive
  endif
endfun

fun! FindCharRepeat(back)
  let flag = 'W'
  if (!a:back && g:lastfsearchback) || (a:back && !g:lastfsearchback)
    let flag = 'Wb'
  endif
  if search('\V' . nr2char(g:lastfsearchquery), flag)
    if g:lastfsearchinclusive
      norm! l
    endif
    if g:lastfsearchexclusive
      norm! h
    endif
  endif
endfun

:set fillchars+=vert:\    " Set Vsplit char blank (\ ) instead of |

" Abbreviate ConqueTerm to term
call Cabbrev("term", "ConqueTermSplit bash")

" set binary
" set fileformats=unix,dos
" set fileformats=unix


hi! link SignColumn LineNr



" Compatible with ranger 1.4.2 through 1.6.*
"
" Add ranger as a file chooser in vim
"
" If you add this function and the key binding to the .vimrc, ranger can be
" started using the keybinding ",r".  Once you select a file by pressing
" enter, ranger will quit again and vim will open the selected file.
if executable('ranger')
  fun! RangerChooser()
    exec "silent !ranger --choosefile=/tmp/chosenfile " . expand("%:p:h")
    if filereadable('/tmp/chosenfile')
      exec 'edit ' . system('cat /tmp/chosenfile')
      call system('rm /tmp/chosenfile')
    endif
    redraw!
  endfun
  nnoremap <leader>R :call RangerChooser()<CR>
endif

map <F1> :Obsession .vim_auto_sess<CR>
map <F2> :so .vim_auto_sess<CR>

command! -bar -nargs=0 Mutt   :silent exe "! mutt" |redraw!
command! -bar -nargs=0 Tig    :silent exe "! tig" |redraw!

" }}}
" --- Load plugins --------------------------------------------------------- {{{
call plug#begin('~/.vim/plugged')
try
Plug 'beanworks/vim-phpfmt'
Plug 'arnaud-lb/vim-php-namespace'
Plug 'https://github.com/junegunn/vim-easy-align'
"Plug 'https://github.com/tpope/vim-haystack'
"Plug 'https://github.com/kien/ctrlp.vim'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'https://github.com/tacahiroy/ctrlp-funky'
Plug 'https://github.com/mattn/ctrlp-register'
Plug 'https://github.com/bling/vim-airline'
"Plug 'https://github.com/gorodinskiy/vim-coloresque' " conflict with vim-ondemandhighlight
"Plug 'https://github.com/skammer/vim-css-color' " slow loading files
"Plug 'https://github.com/lilydjwg/colorizer' " slow switching tabs

Plug 'https://github.com/yonchu/accelerated-smooth-scroll'
Plug 'https://github.com/rking/ag.vim'
Plug 'https://github.com/jiangmiao/auto-pairs'
"Plug 'https://github.com/vim-scripts/autoproto.vim'
Plug 'https://github.com/neitanod/autoproto.vim'
"Plug 'https://github.com/vim-scripts/autosession.vim' " replaced with Tim Pope's Obsession
Plug 'https://github.com/duff/vim-bufonly'
Plug 'https://github.com/rhysd/clever-f.vim'
" Plug 'https://github.com/sgur/ctrlp-extensions.vim'
Plug 'https://github.com/neitanod/vim-sade'

Plug 'https://github.com/mattn/emmet-vim.git'
Plug 'https://github.com/luochen1990/rainbow'
Plug 'https://github.com/neitanod/vim-clevertab'
Plug 'https://github.com/SirVer/ultisnips'
Plug 'https://github.com/alvan/vim-closetag'
Plug 'https://github.com/tpope/vim-repeat'
Plug 'https://github.com/tpope/vim-unimpaired'
Plug 'https://github.com/soh335/vim-symfony'
Plug 'https://github.com/Shougo/unite.vim'
Plug 'https://github.com/h1mesuke/unite-outline'
Plug 'https://github.com/kana/vim-textobj-user'
Plug 'https://github.com/rhysd/vim-textobj-anyblock'
Plug 'https://github.com/kana/vim-textobj-indent'
Plug 'https://github.com/kana/vim-textobj-line'
Plug 'https://github.com/akiyan/vim-textobj-php'
Plug 'https://github.com/kana/vim-textobj-syntax'
Plug 'https://github.com/jceb/vim-textobj-uri'
Plug 'https://github.com/Julian/vim-textobj-variable-segment'
Plug 'https://github.com/tmhedberg/matchit'
Plug 'https://github.com/valloric/MatchTagAlways'
Plug 'https://github.com/Shougo/neocomplete.vim'
Plug 'https://github.com/Shougo/neoyank.vim'
Plug 'https://github.com/scrooloose/syntastic'
Plug 'https://github.com/godlygeek/tabular'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/airblade/vim-gitgutter'
Plug 'https://github.com/ntpeters/vim-better-whitespace'
Plug 'https://github.com/kana/vim-operator-user'

Plug 'https://github.com/airblade/vim-rooter'
Plug 'https://github.com/honza/vim-snippets'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tomtom/tcomment_vim'
Plug 'https://github.com/wellle/targets.vim'
Plug 'https://github.com/vim-scripts/LargeFile'
Plug 'https://github.com/ton/vim-bufsurf'
Plug 'https://github.com/justinmk/vim-matchparenalways'
Plug 'https://github.com/wincent/Command-T'
Plug 'https://github.com/vim-scripts/Conque-Shell'
Plug 'https://github.com/neitanod/vim-ondemandhighlight'
Plug 'https://github.com/tpope/vim-obsession'
"Plug 'https://github.com/spf13/PIV'  " SLOOOOOOW!
"Plug 'https://github.com/m2mdas/phpcomplete-extended'
Plug 'https://github.com/Shougo/vimproc.vim'
Plug 'https://github.com/itchyny/vim-qfedit'
"Plug 'https://github.com/jceb/vim-editqf'
Plug 'https://github.com/vim-scripts/diffchar.vim'
Plug 'https://github.com/gcmt/taboo.vim'
Plug 'https://github.com/szw/vim-ctrlspace'
"Plug 'https://github.com/tomaszj/lexplore.vim'
Plug 'https://github.com/atweiden/vim-dragvisuals'
Plug 'https://github.com/AndrewRadev/switch.vim'
Plug 'https://github.com/ktonga/vim-follow-my-lead'
" Plug 'https://github.com/sergei-dyshel/vim-abbrev-matcher'
Plug 'https://github.com/evidens/vim-twig'
Plug 'https://github.com/embear/vim-foldsearch'
"browser
"calendar.vim


"dragvisuals
"git-file.vim
"hilinks
"listmaps
"lusty
"paster
"PIV
"quickfix-reflector.vim
"ScrollColors
"solarized
"tlib_vim
"undotree
"vim-addon-mw-utils
"vim-easymotion
"vim-exchange
"vim-expand-region
"vim-gtfo
"vim-interestingwords-orig
"vim-l9
"vimproc.vim
"vim-sparkup
"vim-speeddating
"vim-tbone
"vimux
catch

endtry
call plug#end()





" Transparent background so we can see the terminal program's background image
highlight Normal ctermbg=NONE
highlight NonText ctermbg=NONE

" }}}
" --- Auto reload .vimrc --------------------------------------------------- {{{
augroup myvimrc
  au!
  au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif 
augroup END

" }}}
" --- Autocommands --------------------------------------------------------- {{{
if !exists("vimrc_autocommands_various_loaded")
  let vimrc_autocommands_various_loaded = 1
  if has("autocmd")
    "autocmd FileReadPost normal zR

    " Clean HTML markup with gg gqG
    let pandoc_pipeline  = "pandoc --from=html --to=markdown"
    let pandoc_pipeline .= " | pandoc --from=markdown --to=html"
    autocmd FileType html let &formatprg=pandoc_pipeline

  endif
endif


" }}}
" --- Leader mappings and other awesome mappings --------------------------- {{{

" jk and kj -> Quit Insert mode (and autosave)
" inoremap jk <Esc><Esc>`^:w<Cr>
" inoremap kj <Esc><Esc>`^:w<Cr>
inoremap jk <Esc><Esc>`^
inoremap kj <Esc><Esc>`^
cnoremap jk <C-c>
cnoremap kj <C-c>

" Autosave on CursorHold
autocmd CursorHold * :update

" ; alias for : (; does not require shift)
nnoremap ; :

" W and Q just works, for when you didn't release shift on time
command! -bang W w<bang>
command! -bang Q q<bang>
" Typos
command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang W w<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>
" Discard all, quick way out
command! Qq qa!
call Cabbrev("qq","Qq")

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Quickly edit the vimrc and TIL files
nnoremap <silent> <leader>v :tabedit $MYVIMRC<CR>
nnoremap <silent> <leader>T :tabedit ~/TIL.txt<CR>
nnoremap <silent> <leader>S :tabedit ~/dotfiles/vim/UltiSnips/php.snippets<CR>
nnoremap <silent> <leader>n :tabedit ~/Dropbox/Public/notas/notas.md<CR>
nnoremap <silent> <leader>p :tabedit ~/.pentadactylrc<CR>
" nnoremap <silent> <backspace> :Switch<CR>
source $HOME/.vim/switch-definitions.vim

" Indent the whole file
nnoremap <silent> <leader>i mkgg=G`k

nnoremap <silent> <leader>G :Gofmt<CR>

function! Gofmt()
  exec "normal! m`:% !gofmt\n``"
endfunction
command! Gofmt :call Gofmt()

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Symfony go to action and go to view
nnoremap <expr> <leader>a match(expand('%:t'),'\.class') == -1 ? ':Saction<CR>' : ':Sview<CR>'
nnoremap <leader>m :Smodel<CR>

" OpenChangedFiles (<Leader>O)
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\)" | cut -d " " -f 3')
  let filenames = split(status, "\n")

  if len(filenames) < 1
    let status = system('git show --pretty="format:" --name-only')
    let filenames = split(status, "\n")
  endif

  exec "edit " . filenames[0]

  for filename in filenames[1:]
    if len(filenames) > 3
      exec "tabedit " . filename
    else
      exec "vsp " . filename
    endif
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()
noremap<Leader>O :OpenChangedFiles <CR>

"visually select around function
nnoremap vaf ?func.*\n*\s*{<cr>ma/{<cr>%mb`av`b
vmap af o<esc>kvaf

" mark with 'mm' and later quickly go to that mark
" with just 'MM' (without having to reach for `)
nnoremap mm mM
vnoremap mm mM
nnoremap MM `M
vnoremap MM `M

" Navigate history with g-/g= instead of g-/g+ (no SHIFT needed)
nnoremap g= g+

" Navigate change list with Backspace and Enter
nnoremap <cr> g,
nnoremap <backspace> g;

" File's git history using 'tig'
nnoremap <leader>H :call TigHistory()<cr>

fun! TigHistory()
  :execute ':silent !tig %'
  :execute ':redraw!'
endfunc

" In Insert mode replace sdate with current date
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

" Really useful!
" In visual mode when you press * or # to search for the current selection
" {{{
function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
" }}}

" <leader>g helps you write a vimgrep command
nnoremap <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" <leader>/ cleans search highlight
nnoremap <silent> <leader>/ :nohlsearch<CR>

" When you use * to search for the current word, do not jump to the next
" occurrence right away.
nnoremap * *N

" F10 shows the current highlight group for the word under the cursor
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Set invisibles visible, and set fancy characters for TAB and NEWLINE
set listchars=tab:▸\ ,eol:¬
highlight NonText       guifg=#707070 ctermfg=8
highlight SpecialKey    guifg=#707070 ctermfg=8

"Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>
au BufRead,BufNewFile ~/buffer iab <buffer> xh1 ===========================================

map <leader>pp :setlocal paste!<cr>

" Zoom and Unzoom functions for GUI version of Vim
let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
let s:minfontsize = 6
let s:maxfontsize = 16
function! AdjustFontSize(amount)
  if has("gui_gtk2") && has("gui_running")
    let fontname = substitute(&guifont, s:pattern, '\1', '')
    let cursize = substitute(&guifont, s:pattern, '\2', '')
    let newsize = cursize + a:amount
    if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
      let newfont = fontname . newsize
      let &guifont = newfont
    endif
  else
    "echoerr "You need to run the GTK2 version of Vim to use this function."
    " It's better to fail silently, I think...
  endif
endfunction

function! LargerFont()
  call AdjustFontSize(1)
endfunction
command! Zoom call LargerFont()

function! SmallerFont()
  call AdjustFontSize(-1)
endfunction
command! Unzoom call SmallerFont()

" Open a quickfix window with the last search
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

" Perform an Ag search with the last search
nnoremap <silent> <leader>? :execute 'Ag '.@/<cr>:copen<cr>

" Restore original functionality of keys inside quickfix
if has('autocmd')
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
endif

" allows incsearch highlighting for range commands
" usage: /searchterm$m moves the found line to current line
" usage: /searchterm$M moves the found line to above current line
" With t and T it's the same but copying instead of moving
cnoremap $m <CR>:m''<CR>
cnoremap $M <CR>:m''<CR>
cnoremap $t <CR>:t''<CR>
cnoremap $T <CR>:t''<CR>
cnoremap $d <CR>:d<CR>``

" mt and mT: move split window to next/previous tab
" Neat!
function! MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    "sp  "for horizontal split
    vert topleft split "for vertical split
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function! MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    "sp  "for horizontal split
    vert topleft split "for vertical split
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

nnoremap mt :call MoveToNextTab()<cr>
nnoremap mT :call MoveToPrevTab()<cr>

" Allow saving of files as sudo when I forgot to start vim using sudo.
command! -bar -nargs=0 Sudow   :silent exe "write !sudo tee % >/dev/null"|silent edit!
command! -bar -nargs=0 Sudowq  :silent exe "write !sudo tee % >/dev/null"|silent edit!|q
ca sudow Sudow
ca w!! Sudow
ca wq!! Sudowq

" Replace trailing spaces and ^M
command! TrimEOL :%s/\(\s\|\r\)\+$//

" Replace tabs with 4 spaces
command! FixTabs :%s/^\t/    /g

" Replace tabs with 2 spaces
command! FixTabs2 :%s/^\t/  /g

" do not replace yanked text when pasting over something else
xnoremap p pgvy
xnoremap P Pgvy

command! -nargs=1 Run :let g:VimuxOrientation = "v" |:call VimuxRunCommand(<f-args>)
command! -nargs=1 RunV :let g:VimuxOrientation = "h" |:call VimuxRunCommand(<f-args>)
nnoremap <leader>r :VimuxRunLastCommand<CR>

" Pass everything as a single argument:            -nargs=1
"command! -nargs=1 Run call UserFunction(<f-args>)
" works like calling: call UserFunction("ls -la")

" Pass every word as a separate argument:          -nargs=*
"command! -nargs=* Run call UserFunction(<f-args>)
" works like calling: call UserFunction("ls","-la")

" <leader>r -> run current line as VIM command
nnoremap <leader>r mmyy:@"<Enter>`m

" <leader>c -> run current line as SHELL command
"nnoremap <leader>c o<Esc>dG0i:r!<Space><Esc>mnyy:@"<Enter>`nld0

" <leader>u -> "update code (using shellscript generator)":
" run text between delimiters {%{ and }%} (in current line only) as bash command
" and paste results into target area marked by {%[ and ]%}.  See example below.
" 
" put cursor here {%{ echo "       \" alert(\"`date "+%Y-%m-%d %T"`\");" }%}
"                          put cursor here in the line above
"                          and type <leader>u
" {%[   line below this delimiter is target area.
"   alert("2014-10-16 16:04:22");
" ]%}   this line marks the end of the target area
nnoremap <leader>u my0/{%{<enter><right><right><right>y/}%}<enter>/{%[<enter><down>0mx/]%}<enter>:nohlsearch<enter>0"xd`xO<esc>P!!bash<enter>`y

" Damian Conway -> n and N highlight match in red
highlight WhiteOnRed ctermbg=red ctermfg=white
function! HLNext (blinktime)
  let [bufnum, lnum, col, off] = getpos('.')
  let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  let target_pat = '\c\%#'.@/

  let ring = matchadd('WhiteOnRed', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  "call matchdelete(ring)
  redraw

  "    exec 'sleep ' . float2nr(a:blinktime * 500) . 'm'
  "    let ring = matchadd('WhiteOnRed', target_pat, 101)
  "    redraw
  "    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  "    call matchdelete(ring)
  "    redraw

endfunction
nnoremap <silent> n  n:call HLNext(0.05)<cr>
nnoremap <silent> N  N:call HLNext(0.05)<cr>


"Will open files in current directory, allows you to leave the working cd in
"the project root. You can also use %% anywhere in the command line to expand.
cnoremap %% <C-R>=expand('%:h').'/'<cr>

"Searches current Keyword (the word under cursor) in Vim's help index
nnoremap K "zyiw:help <C-R>z<cr>

" }}}
" --- Vim sade ------------------------------------------------------------- {{{
try
  call sade#NoReMap('Gd', "ymmodie(\<esc>pA);\<esc>`m") " die(<target>)
  call sade#NoReMap('Gc', "di/*\<esc>gp`]a*/\<esc>") "    /* <target> */
  call sade#NoReMap('Gt', "di<*>@</*>\<esc>?*\<cr>vpgvy?*\<cr>vp/@\<cr>x")  " <target>|</target>
  call sade#NoReMap('GS', "y:@\"\<cr>")   " source <target>

  call sade#Func("Gh",'SadeHighlight')
  call sade#Func("GI",'Inspect')
  call sade#Func("Gt",'TranslateThis')
catch

endtry

function! Inspect()
  exe "normal! \<esc>o\<esc>"
  let @a="Inspect::view(".g:sade#LastText.");"
  normal! "ap
endfunction

" PHP TRANSLATE THIS
" inserts a line like:   <?php t(<yanked_text>)?>
function! TranslateThis()
  :normal! d
  :normal! a<?php _('
  :normal! P
  :normal! a')?>
endfunction

command! Php :silent % ! phpcbf --standard=PSR2<ENTER>
cabbrev php Php

" ALT-SHIFT-L runs the PHP formatter (just like PHPStorm does) :D
nnoremap L <ESC>m`:Php<ENTER>``

" Map ALT-j:  nnoremap j <command>
" Map ALT-k:  nnoremap k <command>
" Map ALT-h:  nnoremap h <command>
" Map ALT-l:  nnoremap l <command>

" }}}
" --- Plugins config ------------------------------------------------------- {{{
" -------- Unite       {{{

let g:phpfmt_standard = 'PEAR'
let g:phpfmt_command = '~/bin/phpcbf'
let g:phpfmt_tmp_dir = '~/'

let g:unite_data_directory = '~/.unite'
let g:unite_abbr_highlight = 'normal'
let g:unite_source_history_yank_enable = 1
if exists("unite#filters#matcher")
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
endif
nnoremap <leader>y :<C-u>Unite history/yank<CR>
nnoremap <leader>sl :<C-u>Unite -start-insert -auto-resize line<CR>
nnoremap <leader>R :<C-u>Unite register<CR>
nnoremap <leader>b :<C-u>Unite -start-insert -auto-resize buffer<CR>
nnoremap <leader>so :<C-u>Unite -start-insert -auto-resize outline<CR>
nnoremap <leader>f :<C-u>Unite -start-insert -auto-resize file_rec/git<CR>
nnoremap <leader>e :<C-u>UniteWithBufferDir -start-insert -auto-resize file<CR>

nmap <leader>oc :CtrlP<CR>app/controllers/
nmap <leader>os :CtrlP<CR>schemayml<CR>
nmap <leader>om :CtrlP<CR>app/model/
nmap <leader>ov :CtrlP<CR>app/views/
nmap <leader>oh :CtrlP<CR>app/helpers/
nmap <leader>ow :CtrlP<CR>web/
nmap <leader>op :CtrlP<CR>web/panel_files/

" }}}
" -------- GitGutter   {{{
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
" }}}
" -------- Region Expand   {{{
" Leader-w  = wider region
"nmap <leader>w v
vmap v <Plug>(expand_region_expand)
" Leader-n  = narrower region
vmap <C-v> <Plug>(expand_region_shrink)
" }}}
" -------- Visually move block around   {{{
" Damian Conway -> arrow keys move block around (dragvisual plugin)
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()
" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1
" }}}
" -------- Powerline and Airline   {{{
"let g:Powerline_symbols = 'fancy'
"let g:Powerline_dividers_override = ['', '', '', '']
"let g:Powerline_dividers_override = ['', '', '', '']
"let g:Powerline_dividers_override = ["\Ue0b0", "\Ue0b1", "\Ue0b2", "\Ue0b3"]
"let g:Powerline_symbols_override = { 'BRANCH': '', 'LINE': '', 'RO': '' }
"let g:Powerline_symbols_override = { 'BRANCH': "\Ue0a0", 'LINE': "\Ue0a1", 'RO': "\Ue0a2" }
"let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
"let g:airline_detect_whitespace = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline_exclude_preview = 1 "needed by CtrlSpace plugin


if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
let g:airline_left_sep = ''
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
let g:airline_right_sep = ''
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'


" }}}
" -------- Syntastic   {{{
" Automatically open error list when errors are detected.
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 2
let g:syntastic_quiet_messages = { "type": "style" }


" }}}
" -------- CtrlP   {{{
noremap <C-[><C-p> :CtrlPMRU<CR>            " Map Control-[ then Control-p  => to CtrlP in MRU mode
noremap <C-e> :CtrlP %:p:h<CR>              " Control-p in folder of current file instead of project
noremap <C-y> :CtrlP %:p:h/..<CR>           " Control-p in folder PARENT of current file's 
noremap <C-[><C-[> '0                       " Map Control-[ twice to reopen last file
" noremap <leader>p <C-p><C-\>w               " I feel lucky -> Jump to Ctrl-P search for word under cursor
" noremap <C-[><C-[><C-p> :CtrlPYankring<CR>  " Map Control-[ then Control-p  => to CtrlP in Buffer mode

" if exists("g:abbrev_matcher_grep_exe")  " not loaded yet, conditional does not work.  Moved to vimloadedrc
"  let g:ctrlp_match_func = { 'match': 'ctrlp#abbrev_matcher#match' }
" endif


function! LazyP()
  let g:ctrlp_default_input = expand('<cword>')
  CtrlP
  let g:ctrlp_default_input = ''
endfunction
command! LazyP call LazyP()
nnoremap <C-L> :LazyP<CR><CR> 


" Use Tim Pope's improved match algorithm from "haystack.vim" plugin
"   CANCELLED.  Too slow. =(
function! CtrlPMatch(items, str, limit, mmode, ispath, crfile, regex) abort
  let items = copy(a:items)
  if a:ispath
    call filter(items, 'v:val !=# a:crfile')
  endif
  return haystack#filter(items, a:str)
endfunction
" let g:ctrlp_match_func = {'match': function('CtrlPMatch')}

" }}}
" -------- ControlSpace   {{{
" }}}
nnoremap <leader><leader> :CtrlSpace<CR>
nnoremap <leader>j :CtrlSpaceGoDown<CR>
nnoremap <leader>k :CtrlSpaceGoUp<CR>

" let g:CtrlSpaceLoadLastWorkspaceOnStart = 1

" -------- EasyMotion  {{{
" Single character search, the only way of searching I will ever use:
"map <cr> <Plug>(easymotion-f)
"map <backspace> <Plug>(easymotion-F)

let g:gtfo#terminals = { 'mac' : 'iterm', 'unix' : 'konsole' }
" }}}
" -------- NeoComplete   {{{
let g:neocomplete#disable_auto_complete = 1
let g:neocomplete#enable_at_startup = 0
"let g:neocomplete#enable_auto_select = 1

if !exists('g:neocomplete#sources')
  let g:neocomplete#sources = {}
endif
let g:neocomplete#sources._ = ['buffer', 'dictionary']
let g:neocomplete#sources.php = ['buffer', 'dictionary']

let g:neocomplete#sources#dictionary#dictionaries = {
\   'default' : '',
\   'php' : $HOME.'/php.dict',
\   'html' : $HOME.'/php.dict'
\ }

"if !exists('g:neocomplete#sources#omni#input_patterns')
"	let g:neocomplete#sources#omni#input_patterns = {}
"endif
"if !exists('g:neocomplete#sources#omni#functions')
"  let g:neocomplete#sources#omni#functions = {}
"endif
"if !exists('g:neocomplete#force_omni_input_patterns')
"	let g:neocomplete#force_omni_input_patterns = {}
"endif
"if !exists('g:neocomplete#keyword_patterns')
"    let g:neocomplete#keyword_patterns = {}
"endif

"let g:neocomplete#keyword_patterns['default'] = '\h\w*'

"PHP Input Patterns
"let g:neocomplete#sources#omni#input_patterns.php =
"			\'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

" }}}
" -------- Clever Tab:  Uses UltiSnips+Keyword+Omni completion chain   {{{
  inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                        \<c-r>=CleverTab#Complete('tab')<cr>
                        \<c-r>=CleverTab#Complete('ultisnips')<cr>
                        \<c-r>=CleverTab#Complete('keyword')<cr>
                        \<c-r>=CleverTab#Complete('neocomplete')<cr>
                        \<c-r>=CleverTab#Complete('omni')<cr>
                        \<c-r>=CleverTab#Complete('stop')<cr>
  inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
" }}}
" -------- On demand highlight   {{{
" }}}
" }}}
" --- Continue with the commands of this file, but after loading plugins --- {{{
autocmd VimEnter * source ~/dotfiles/vimloadedrc
" }}}
"
"
