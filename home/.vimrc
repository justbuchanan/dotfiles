
set nocompatible	" vim, not vi
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'altercation/vim-colors-solarized'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Use w!! to use sudo to save the file
cmap w!! w !sudo tee % >/dev/null

imap jj <Esc>		" Esc takes too long, just double-tap 'j'

set number			" show line numbers in gutter
set ruler			" show line number in bottom bar

set ts=4
set shiftwidth=4
set expandtab
set ai				" auto-indent

filetype indent on	" filetype-specific indenting
filetype plugin on	" filetype-specific plugins

" scons
autocmd BufReadPre,BufNewFile SConstruct set filetype=python
autocmd BufReadPre,BufNewFile SConscript set filetype=python

set ignorecase		" case-insensitive search
set incsearch		" when searching, highlight as you type

" enable mouse mode
set mouse=a

" sublime
au BufNewFile,BufRead *.sublime-settings set filetype=json
au BufNewFile,BufRead *.sublime-project set filetype=json

" JSON
let g:vim_json_syntax_conceal = 0

noremap :bb ddk$

map <C-n> :NERDTreeToggle<CR>
map <C-l> :bnext<CR>
map <C-h> :bprev<CR>

let g:airline_theme='solarized'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1

nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

syntax enable
set background=dark

" solarized options
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
let g:solarized_termcolors = 16
colorscheme solarized
