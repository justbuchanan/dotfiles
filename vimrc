
execute pathogen#infect()

syntax on			" syntax highlighting

imap jj <Esc>

set number			" show line numbers in gutter
set ruler			" show line number in bottom bar
set textwidth=80

set nocompatible	" vim, not vi


set ts=4
set shiftwidth=4
set noexpandtab		" spaces suck, use tabs

set ai
filetype indent on	" filetype-specific indenting
filetype plugin on	" filetype-specific plugins

" scons
autocmd BufReadPre,BufNewFile SConstruct set filetype=python
autocmd BufReadPre,BufNewFile SConscript set filetype=python

set ignorecase		" case-insensitive search

" prevent 'cheating'
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>



noremap :bb ddk$


