""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" JMCT's literate vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" make ',' my leader key
let mapleader = ","


""" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map
"""""
"
" `map` maps keys in both normal and visual mode. It also uses previous mappings
" when it expands. For example

" In normal-mode make space highlight a word

map <space> viw

" Would use any mapping of `v`, `i`, or `w`. So if `v`, `i`, or `w` get mapped
" to something else, this may not mean what we think

" nmap
""""""
"
" The same as `map` but for normal mode only.
"
" Add markdown-style underlines for the current line
" Leaving you in insert mode after adding a newline
nmap == yypVr=o<cr>
nmap -- yypVr-o<cr>


" vmap
""""""
"
" The same as `map` but for visual mode only.
"
" imap
""""""

" The same as `map` but for insert mode only.

" Map kj (in quick succession) to leave insert mode
imap kj <Esc>

" noremap
"
"
" Each of `map`, `imap`, `nmap`, `vmap`, have a version that _does not_ use other
" mappings when it expands.
"
" `noremap`
" `inoremap`
" `nnoremap`
" `vnoremap`

" Mappings to edit and source vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

""" Flags
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Flags are some stored variable with default values. Many are boolean valued.
"
" Boolean Flags
"""""""""""""""
"
"For a flag, you can set it with

set number " show line numbers in the gutter

" When you type the closing bracket, quickly jump the it's opening
" match to show you where it is (default matchtime is for 0.5 seconds)
set showmatch

"And unset it with
"
"
" set nonumber

" Valued Flags
""""""""""""""
"
" Valued flags are set in the same way as boolean flags, but with `=VAL`:

set background=dark
set t_Co=256

" Options dealing with tabs:
set expandtab " don't use explicit tab characters
set tabstop=2 " each hit of the tab key should be two spaces

""""""""""""""""""""""""""""""""""
" VIMSCRIPT THE HARD WAY EXERCISES
""""""""""""""""""""""""""""""""""
" if I like them, I move them up "
""""""""""""""""""""""""""""""""""

" Change the case on a word
imap <c-u> <esc><c-u>a


iabbrev adn and
iabbrev teh the

iabbrev memail jmct@jmct.cc
iabbrev mename José Manuel Calderón Trilla

syntax on
