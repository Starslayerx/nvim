# nvim
My neovim configuraton

## Plugs
I use [vim-plug](https://github.com/junegunn/vim-plug) to manage this plugs blew:

- [lightline.vim](https://github.com/itchyny/lightline.vim)
lightline is s statue line for vim and intergrted with many other plugs.
This is my lightline config
```vimscrpit
""" lightline config"""
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
```

- [nord-vim](https://www.nordtheme.com/)
Nord is a beautiful them.I also use this for my alactritty terminal.
```vimscript
""" nord theme config """
let g:nord_cursor_line_number_background = 1
let g:nord_uniform_status_lines = 1
let g:nord_bold_vertical_split_line = 1
let g:nord_uniform_diff_background = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord
```

- [vim-visual-multi](https://github.com/mg979/vim-visual-multi)

- [vim-surround](https://github.com/tpope/vim-surround)

- [wildfire.vim](https://github.com/gcmt/wildfire.vim)

- [ale](https://github.com/dense-analysis/ale)
I used to use [coo.vim](https://github.com/neoclide/coc.nvim), but it's complicate to config.And I also use [kite](https://www.kite.com/) to complete my code.However kite will disable coc.There is also a coc.kite plug, but it works not that good.Now I use ale for syntax checking.
