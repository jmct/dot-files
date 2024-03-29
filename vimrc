""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" JMCT's literate vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""
" NOTE "
""""""""
" use `za` to fold and unfold any foldings you may encounter here

" make ',' my leader key
let mapleader = ","

set nocompatible

""" Mappings --------------------------------------------------------------- {{{

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

vmap kj <Esc>

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

" }}}

""" Flags ------------------------------------------------------------------ {{{
"
" Flags are some stored variable with default values. Many are boolean valued.
"
" Boolean Flags
"""""""""""""""
"
"For a flag, you can set it with

set number " show line numbers in the gutter

"And unset it with
"
"
" set nonumber

" When you type the closing bracket, quickly jump to it's opening
" match to show you where it is (default matchtime is for 0.5 seconds)
set showmatch

" Valued Flags
""""""""""""""
"
" Valued flags are set in the same way as boolean flags, but with `=VAL`:

set background=dark
set t_Co=256

set laststatus=2 " So that that statusline shows in Xmonad

" Options dealing with tabs:
set expandtab " don't use explicit tab characters
set tabstop=2 " each hit of the tab key should be two spaces
set shiftwidth=2 " Each shift (>> or <<) should be two spaces
" }}}

""" Autocommands ----------------------------------------------------------- {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Autocommands tell vim to execute some sequence of commands whenever an event
" is triggered

" Make sure that a file is created whenever you say 'vim foo' on the CLI
autocmd BufNewfile * :write

" Make sure that tex files do not wrap lines and has the spell checker on
augroup prosegroup
  autocmd!
  autocmd BufNewFile,BufRead *.tex setlocal nowrap
  autocmd BufNewFile,BufRead *.{tex,md,markdown} setlocal spell
  autocmd BufNewFile,BufRead *.{md,markdown} set syntax=markdown
augroup END

" Some behavior that is specific to file type (and therefore, filetype must be on)
filetype on

" Filetype autocommands help us avoid having to deal with the possible various
" file extensions for a known 'type' of file
augroup codegroup
  autocmd!
  autocmd FileType haskell nnoremap <buffer> <localleader>c I--<esc>
  autocmd FileType c       nnoremap <buffer> <localleader>c I//<esc>
  autocmd FileType rust    nnoremap <buffer> <localleader>c I//<esc>
augroup END
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimscript file settings ------------------------------------------------- {{{
" Things for when I'm editing vimscript files (including this one)
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

"" Colors seems to be a pain between VIM and tmux
"" The following comment on an issue in VIM seems to be the workaround:
"" https://github.com/vim/vim/issues/3608#issuecomment-438487463

"" This is only necessary if you use "set termguicolors":
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

"" However, a comment from just two months ago (May 2021), says the the issue can be fixed by adding another setting to tmux. In my view the issue is the vim+tmux combo, so I will address it there.
set termguicolors
syntax on
colorscheme jmct-beamer


" fixes glitch? in colors when using vim with tmux
"set background=dark
set t_Co=256



""" Satusline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set statusline=%f             " Current file
"set statusline+=\ -\ 
"set statusline+=FT:\ %y\      " Show the filetype
"set statusline+=%{trim(system('echo\ $HOME'))}
" THIS DOES NOT WORK
" it needs to deal with the possibility that we aren't in a git repo
"set statusline+=%{trim(system('git\ branch'))}
set statusline+=\ %m%r        " Show if the file is modified


" Things from the right-hand side of the statusline
set statusline+=%=               
set statusline+=col.\ %02c\ of\ line\ %l\ out\ of\ %L

""" Variables -------------------------------------------------------------- {{{
"
" Variables in vimscript come in four flavors, though they are not mutually
" exclusive:
"
" * standard variables
" * options
" * local variables
" * register variables
"
" Standard
""""""""""
" Standard variables are given plain names like `foo`, `len`, `num`, etc.
"
" Options
"""""""""
" Options affect vim's behavior, many of the earlier values in this file are
" options: `statusline`, `background`, etc. Boolean options can be prefaced
" with `no` in order to mean the logical negation of the option, e.g. `nowrap`.
"
" Some expresisons expect a 'variable' and will complain about undefined
" variables if you use an option instead. The way around this is to preface
" the name of the option with `&`
"
" echo statusline  <-- error
" echo &statusline <-- prints the format string for the statusline
"
" Local
"""""""
" Local variables allow you to control the value of a variable only in the
" local scope. You preface the variable with `&l:`, so `number` becomes
" `&l:number`. TODO: Ask dmwit about local variables, this doesn't seem
" to do what I thought it would
"
" Registers
"""""""""""
" Registers can also be used as variables, by prefixing their name with `@`.
"
" let @a = "yo, watup?" <-- In normal mode you can paste the contents with "ap
"
" echo @a
"
""" Set and Let
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" These variables can be set or assigned in two ways:
"
" * assigned using `set`
" * assigned using `let`
"
"
" Set
"""""
"
" Variables assigned using `set` can only be assigned using _literals and
" constants_. Like:
"
" set foo = "bar"
"
" Let
"""""
"
" Variables assigned using `let` can be arbitrary vimscript expressions:
"
" let foo = bar + 5
"
""" Scope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Variables can be scoped to a specific buffer by prefacing the variable name
" with `b:`
"
" let b:test = "yo yo yo"
" echo b:test             <--- will only work in the buffer it was defined in
" }}}


""" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"call plug#begin('~/.vim/plugged')
"
"Plug 'vimwiki/vimwiki', {'branch': 'dev'} | Plug 'tbabej/taskwiki'
"
"call plug#end()
"
"let g:vimwiki_list = [{'path': '~/wiki/',
"                     \ 'syntax': 'markdown', 'ext': '.md'}]

""""""""""""""""""""""""""""""""""
" VIMSCRIPT THE HARD WAY EXERCISES
""""""""""""""""""""""""""""""""""
" if I like them, I move them up "
""""""""""""""""""""""""""""""""""

imap <c-d> <esc>ddi
imap <c-u> <esc><space>Uea

iabbrev adn and
iabbrev teh the

iabbrev memail jmct@jmct.cc
iabbrev mename José Manuel Calderón Trilla
iabbrev mefirst José
iabbrev mefirst José
iabbrev mecaltri José



" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
