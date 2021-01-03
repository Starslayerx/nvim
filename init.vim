""" vim config """
set nu
set showcmd
set t_Co=256
set expandtab
set nobackup
set expandtab
set cursorline
set nocompatible
set smartindent
set autoindent
set laststatus=2

set tabstop=4
set shiftwidth=4
set guifont=Hack:h14
set fenc=utf-8
set encoding=utf-8
set scrolloff=15 
%retab!
syntax on

inoremap [ []<ESC>i
inoremap {<CR> {<CR>}<ESC>O



""" vim plugs """
call plug#begin('~/.config/nvim/plugged')
" lightline "
Plug 'itchyny/lightline.vim'
" themes "
Plug 'arcticicestudio/nord-vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
" vim tools
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-surround'
Plug 'gcmt/wildfire.vim'
" code complete
Plug 'dense-analysis/ale'
" file search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
call plug#end()

""" onehalfdark theme config"""
"let g:lightline = {
"      \ 'colorscheme': 'onehalfdark',
"      \ 'component_function': {
"      \   'gitbranch': 'FugitiveHead'
"      \ },
"      \ 'component': {
"      \   'charvaluehex': '0x%B'
"      \ },
"      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
"      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
"      \ }
"colorscheme onehalfdark

""" nord theme config """
let g:nord_cursor_line_number_background = 1
let g:nord_uniform_status_lines = 1
let g:nord_bold_vertical_split_line = 1
let g:nord_uniform_diff_background = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ }

""" fzf.vim """
noremap <c-f> :Files<CR>
noremap <c-l> :Lines<CR>
noremap <c-b> :Buffers<CR>
noremap <c-h> :History<CR>
noremap <c-g> :Ag<CR>
let g:fzf_preview_window = 'right:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
""" ack: ag for fzf """
let g:ackprg = 'ag --nogroup --nocolor --column'
