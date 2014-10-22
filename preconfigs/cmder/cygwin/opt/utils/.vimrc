" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Makes VIM run Syntastic correctly.
set shell=bash
set noshelltemp

" Enables pathogen plugin which allows runtime reloading of plugins
call pathogen#infect()

" Make backspace behave in a sane manner.
set backspace=indent,eol,start

" Switch syntax highlighting on
syntax on

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

" Show line numbers
set number

" Allow hidden buffers, don't limit to 1 file per window/split
set hidden

" By default Vim saves your last 8 commands.  We can handle more
set history=128

" Make status bar visible all the time
set laststatus=2

" Make F5 key displey undo tree
nnoremap <F5> :GundoToggle<CR>
" Make F8 key doisplay tagbar window
nmap <F8> :TagbarToggle<CR>
