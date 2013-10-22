
set nocompatible	" vim, not vi

execute pathogen#infect()


imap jj <Esc>		" Esc takes too long, just double-tap 'j'

set number			" show line numbers in gutter
set ruler			" show line number in bottom bar

set ts=4
set shiftwidth=4
set noexpandtab		" spaces suck, use tabs
set ai				" auto-indent

filetype indent on	" filetype-specific indenting
filetype plugin on	" filetype-specific plugins

" scons
autocmd BufReadPre,BufNewFile SConstruct set filetype=python
autocmd BufReadPre,BufNewFile SConscript set filetype=python

set ignorecase		" case-insensitive search
set incsearch		" when searching, highlight as you type

" prevent 'cheating'
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" sublime
au BufNewFile,BufRead *.sublime-settings set filetype=json
au BufNewFile,BufRead *.sublime-project set filetype=json

" JSON
let g:vim_json_syntax_conceal = 0

noremap :bb ddk$


nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

syntax enable
set background=dark
colorscheme solarized

