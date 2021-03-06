# Nvim
My  neovim configuraton :heart:

## Neovim Flatpak
- `init.vim` to be created in `~/.var/app/io.neovim.nvim/config/nvim/`
- Install vim pluug
  ```bash
  curl -fLo ~/.var/app/io.neovim.nvim/data/nvim/site/autoload/plug.vim --create-dirs     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  ```

## Vim Plugs
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
- [onehalf](https://github.com/sonph/onehalf)
A vim theme.I like the color of code, but no background.

- [vim-visual-multi](https://github.com/mg979/vim-visual-multi)

- [vim-surround](https://github.com/tpope/vim-surround)

- [wildfire.vim](https://github.com/gcmt/wildfire.vim)

- [ale](https://github.com/dense-analysis/ale)  
I used to use [coo.vim](https://github.com/neoclide/coc.nvim), but it's complicate to config.And I also use [kite](https://www.kite.com/) to complete my code.However kite will disable coc.There is also a coc.kite plug, but it works not that good.Now I use ale for syntax checking.
You need to install tools for the language you need syntax checking.See the ale supported languages and tools list [here](https://github.com/dense-analysis/ale/blob/master/supported-tools.md).

- [fzf.vim](https://github.com/junegunn/fzf.vim)
It's a vim version of fzf.Very good tool to search files in vim.You need to install [bat](https://github.com/sharkdp/bat) for highligh preview. 

- [ack.vim](https://github.com/mileszs/ack.vim)
You will need to install [the_silver_searcher](https://github.com/ggreer/the_silver_searcher) frst. And install this plug then.Don't forget to add this
> let g:ackprg = 'ag --nogroup --nocolor --column' 

or
> let g:ackprg = 'ag --vimgrep'  


## other plugs
- [kite](https://www.kite.com/)  
An ai code completion engine.It supports a lot of editors and IDE.
