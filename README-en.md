# Neovim Configuration

[中文文档](README.md)

A modular Neovim configuration powered by `lazy.nvim`, focused on LSP, completion, debugging, testing, Git, template development, and fast navigation.

> The current configuration is used with Neovim `0.12.4` and relies on the newer `vim.lsp.config()` / `vim.lsp.enable()` API. Neovim `0.11+` is recommended.

## Overview

| Area                 | Implementation                                                     |
| -------------------- | ------------------------------------------------------------------ |
| Plugin manager       | lazy.nvim, automatic update checks, plugin Git submodules disabled |
| Theme and statusline | nord.nvim, lualine.nvim, transparent backgrounds                   |
| Completion           | blink.cmp, friendly-snippets, nvim-autopairs                       |
| LSP                  | New Neovim LSP API, Mason, mason-lspconfig                         |
| Diagnostics UI       | tiny-inline-diagnostic, Trouble, lspsaga                           |
| Syntax parsing       | nvim-treesitter `main`, rainbow-delimiters                         |
| Search and files     | fzf-lua, neo-tree                                                  |
| Git                  | gitsigns.nvim                                                      |
| Formatting           | conform.nvim                                                       |
| Debugging            | nvim-dap, nvim-dap-view, nvim-dap-python                           |
| Testing              | neotest with pytest, Go, and Vitest adapters                       |
| Task management      | Built-in Taskwarrior panel and commands                            |
| Project environment  | direnv.vim, syncing `.envrc` when buffers are opened or created    |

The Leader key is Space and LocalLeader is `\`.

## Requirements

Required or strongly recommended:

- Neovim `0.11+`; the current tested version is `0.12.4`
- Git
- A Nerd Font
- `fzf` and `ripgrep`
- An environment with working system clipboard support

Optional tools:

- `ctags`: fallback symbol source when LSP and Tree-sitter cannot provide symbols
- `task`: enables the Taskwarrior integration
- `direnv`: synchronizes project `.envrc` environments into Neovim
- A GitHub Copilot account: for the optional Copilot command and status display
- Language runtimes such as Python, Node.js, Go, Rust, and Java

Mason automatically installs the configured LSP servers. Formatters used by Conform are not installed by one shared installer in this configuration; install them through Mason, a system package manager, or the relevant language package manager and make sure they are available in `PATH`.

## Installation

Place the repository in the Neovim configuration directory:

```bash
git clone <repository-url> ~/.config/nvim
nvim
```

On the first launch, lazy.nvim installs plugins while Mason and Tree-sitter install the configured servers and parsers.

Useful maintenance commands:

```vim
:Lazy
:Lazy sync
:Lazy clean
:Mason
:LspInfo
:ConformInfo
:checkhealth lazy
:checkhealth lsp
:checkhealth fzf_lua
```

## Project Structure

```text
~/.config/nvim/
├── init.lua
├── data/
│   └── htmx.html-data.json
├── lua/
│   ├── config/
│   │   ├── lazy.lua
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── filetype.lua
│   │   ├── transparency.lua
│   │   └── taskwarrior.lua
│   └── plugins/
│       ├── ui.lua
│       ├── cmp.lua
│       ├── lsp.lua
│       ├── snacks.lua
│       ├── tools.lua
│       └── debug.lua
├── README.md
└── README-en.md
```

Plugins are grouped by responsibility: UI, completion, LSP, search/files, tools, and debugging. Filetype-specific behavior lives in `lua/config/filetype.lua`.

## Core Options

- Absolute and relative line numbers, cursor line, and a persistent sign column
- Global soft wrapping, `scrolloff=8`, and a 100-column guide
- Four-space indentation with `expandtab` and `autoindent`
- `smartindent` and `cindent` disabled; Python keeps the PEP8 plugin's `indentexpr`
- Default `foldmethod=indent`, `foldlevel=99`, and folding disabled
- Tree-sitter fold expressions for buffers other than Markdown and Text
- Case-sensitive search, search highlighting, and `inccommand=split`
- Vertical splits open right and horizontal splits open below
- Backup, write-backup, and swap files disabled
- Persistent undo stored in `~/.config/nvim/tmp/undo/`
- Cursor position restored when reopening files
- Automatic comment continuation disabled
- `timeoutlen=500`, `ttimeoutlen=50`, and `updatetime=300`
- `lazyredraw=false` to avoid redraw issues with UI plugins such as Noice
- Perl and Ruby providers disabled at startup

## Custom Keymaps

### Basic Editing

| Key            | Action                                                                  |
| -------------- | ----------------------------------------------------------------------- |
| `S`            | Save the current file                                                   |
| `Q`            | Quit the current window                                                 |
| `Y`            | Select the whole buffer and copy it to the system clipboard             |
| `<leader><CR>` | Clear search highlighting                                               |
| `J` / `K`      | Move down/up five lines                                                 |
| `<` / `>`      | Indent in Normal mode; retain selection in Visual mode                  |
| `<leader>z`    | Move the current split into its own tab and toggle a full-window view   |
| `G`            | Markdown only: jump to the target/end of file and run `zz` to center it |

The Markdown `G` mapping is buffer-local. Other filetypes retain native `G`; counted commands such as `20G` also center after jumping.

### Insert Mode and Terminal

| Key               | Action                                                                                   |
| ----------------- | ---------------------------------------------------------------------------------------- |
| `<C-a>`           | Move to the beginning of the line and remain in Insert mode                              |
| `<C-e>`           | Move to the end of the line and remain in Insert mode; the blink.cmp binding is disabled |
| `<C-h>` / `<C-l>` | Move one character left/right                                                            |
| `<C-j>` / `<C-k>` | Scroll one full page down/up                                                             |
| `<C-w>t`          | Open a terminal in a horizontal split                                                    |
| `<C-w>T`          | Open a terminal in a vertical split                                                      |
| `<Esc>`           | Leave Terminal mode for Normal mode                                                      |

### Tabs, Windows, and Buffers

| Key                         | Action                              |
| --------------------------- | ----------------------------------- |
| `tn`                        | Create a new tab                    |
| `tN`                        | Put the current buffer in a new tab |
| `th` / `tl`                 | Previous/next tab                   |
| `tmh` / `tml`               | Move the tab left/right             |
| `<leader>bn` / `<leader>bp` | Next/previous buffer                |
| `<leader>bd`                | Delete the current buffer           |
| `<C-w>h/j/k/l`              | Use native Neovim window navigation |

### fzf-lua and Neo-tree

| Key                         | Action                                                  |
| --------------------------- | ------------------------------------------------------- |
| `<leader><space>`           | fzf-lua global picker                                   |
| `<leader>bb` / `<leader>fb` | Buffer list                                             |
| `<leader>/`                 | Live grep                                               |
| `<leader>:`                 | Command history                                         |
| `<leader>ff`                | Find files                                              |
| `<leader>fg`                | Find Git files                                          |
| `<leader>fc`                | Find Neovim configuration files                         |
| `<leader>fr`                | Recent files                                            |
| `<leader>fs`                | Document symbols: LSP → Tree-sitter → ctags             |
| `<leader>fS`                | Workspace symbols: LSP → ctags                          |
| `<leader>ft`                | Tree-sitter symbols                                     |
| `<leader>fT`                | Project tags                                            |
| `<leader>fR`                | Resume the previous fzf-lua picker                      |
| `<leader>e`                 | Toggle Neo-tree on the left and reveal the current file |

Inside Neo-tree:

| Key          | Action                              |
| ------------ | ----------------------------------- |
| `<CR>` / `l` | Open a file or expand a directory   |
| `h`          | Collapse a directory                |
| `o`          | Open in a new tab                   |
| `s` / `S`    | Open in a vertical/horizontal split |
| `P`          | Toggle floating preview             |
| `H`          | Toggle hidden and gitignored files  |

`t` is explicitly unmapped inside Neo-tree so it does not interfere with the tab navigation workflow.

### LSP and Diagnostics

| Key                         | Action                                                 |
| --------------------------- | ------------------------------------------------------ |
| `<leader>lh`                | Open Lspsaga hover documentation                       |
| `<leader>ld`                | Go to definition in the current window                 |
| `<leader>lv`                | Open a vertical split, then go to definition           |
| `<leader>ls`                | Open a horizontal split, then go to definition         |
| `<leader>lf`                | Peek definition in a floating window                   |
| `<leader>lr`                | Find references and implementations                    |
| `<leader>rn`                | Rename                                                 |
| `<leader>ca`                | Code Action in Normal or Visual mode                   |
| `[d` / `]d`                 | Previous/next diagnostic                               |
| `<leader>o`                 | Toggle the Lspsaga Outline                             |
| `<leader>xl`                | Show diagnostics for the current line                  |
| `<leader>xx`                | Trouble workspace diagnostics                          |
| `<leader>xX`                | Trouble buffer diagnostics                             |
| `<leader>cs`                | Trouble symbols                                        |
| `<leader>cl`                | Trouble LSP information                                |
| `<leader>xL` / `<leader>xQ` | Location list / Quickfix list                          |

`K` moves up five lines, so hover documentation uses `<leader>lh`.

### Git

| Key                         | Action                                           |
| --------------------------- | ------------------------------------------------ |
| `<leader>gj` / `<leader>gk` | Next/previous hunk                               |
| `<leader>gs` / `<leader>gr` | Stage/reset a hunk, including a Visual selection |
| `<leader>gS` / `<leader>gR` | Stage/reset the current buffer                   |
| `<leader>gp` / `<leader>gi` | Floating/inline hunk preview                     |
| `<leader>gb`                | Full blame for the current line                  |
| `<leader>gd` / `<leader>gD` | Diff against the index / `~`                     |
| `<leader>gq`                | Send hunks to the quickfix list                  |
| `<leader>gl`                | Toggle current-line blame                        |
| `<leader>gw`                | Toggle word diff                                 |
| `ih`                        | Hunk text object                                 |

### Testing

| Key                         | Action                             |
| --------------------------- | ---------------------------------- |
| `<leader>tn`                | Run the nearest test               |
| `<leader>tf`                | Run the current file               |
| `<leader>ta`                | Run the current project            |
| `<leader>td`                | Debug the nearest test through DAP |
| `<leader>tm` / `<leader>tc` | Debug a Python test method/class   |
| `<leader>ts`                | Toggle the test summary            |
| `<leader>to`                | Open the latest output             |
| `<leader>tO`                | Toggle the output panel            |
| `<leader>tw`                | Watch the current file             |
| `<leader>tS`                | Stop the test run                  |

### Debugging

| Key                                        | Action                                                           |
| ------------------------------------------ | ---------------------------------------------------------------- |
| `<leader>ds`                               | Start debugging                                                  |
| `<leader>dc`                               | Continue; show session actions when a session is already running |
| `<leader>dn` / `<leader>di` / `<leader>do` | Step over / into / out                                           |
| `<leader>db`                               | Toggle a persistent breakpoint                                   |
| `<leader>dB`                               | Set a conditional breakpoint                                     |
| `<leader>dl`                               | Set a log point                                                  |
| `<leader>du`                               | Toggle DAP View                                                  |
| `<leader>de`                               | Evaluate the cursor expression or Visual selection               |
| `<leader>dp`                               | Open the REPL                                                    |
| `<leader>dR`                               | Run the previous configuration again                             |
| `<leader>dq`                               | Terminate debugging                                              |

Breakpoints persist across Neovim restarts. DAP View is a right-side panel using 50% of the window width and automatically follows the debug lifecycle. Inline debug virtual text is explicitly disabled.

### Taskwarrior

| Key/command                    | Action                    |
| ------------------------------ | ------------------------- |
| `<leader>an` / `:TaskNext`     | Show next tasks           |
| `<leader>aa` / `:TaskAll`      | Show all tasks            |
| `<leader>ap` / `:TaskProjects` | Show projects             |
| `<leader>aA` / `:TaskAdd`      | Prompt for and add a task |

Inside the Taskwarrior panel: `r` refreshes, `<CR>` opens task details, `x` completes a task, and `q` closes the panel.

### Other Editing Tools

| Key             | Action                                                                |
| --------------- | --------------------------------------------------------------------- |
| `<leader>F`     | Format the buffer in Normal mode or the selected range in Visual mode |
| `<leader>j`     | Split/join the current syntax node with TreeSJ                        |
| `<CR>` / `<BS>` | Expand/shrink a Wildfire bracket or Tree-sitter selection             |
| `]r` / `[r`     | Next/previous highlighted reference                                   |
| `<leader>ch`    | Toggle reference highlighting for the current buffer                  |
| `<leader>?`     | Show buffer-local keymaps                                             |

nvim-surround uses its default mappings, for example `ysiw"`, `ds"`, `cs"'`, and `S{char}` in Visual mode.

Other enabled integrations: direnv.vim synchronizes project environments, and nvim-colorizer displays color swatches.

## LSP and Template Support

Mason automatically installs and enables:

- `clangd`
- `pyright`
- `gopls`
- `eslint`
- `ts_ls`
- `lua_ls`
- `rust_analyzer`
- `marksman`
- `html`
- `cssls`
- `jsonls`
- `yamlls`
- `bashls`
- `dockerls`
- `taplo`
- `emmet_language_server`

Special behavior:

- Pyright uses `diagnosticMode=workspace`, disables type checking, and keeps warnings for missing imports/module sources.
- Pyright searches up to three parent levels for `.venv`, `venv`, or `env` and sends its `bin/python` to the server as `pythonPath`.
- Clangd uses `-std=c23` as a fallback when no compilation database/flags exist and logs errors only.
- Lua LS recognizes the Neovim runtime and the `vim` global.
- Django templates use HTML LS + Emmet; `jinja_lsp` is disabled because it treats Django's dynamic context as undefined variables.
- HTML, Jinja, and Emmet support `htmldjango`; HTML LS loads local HTMX custom data.
- CSS LS only serves CSS, SCSS, and Less, avoiding incorrect CSS property completion inside Jinja templates.
- `.jinja`, `.jinja2`, and `.j2` files become `htmldjango`; HTML files under `templates/` or containing Jinja markers are detected automatically.
- Typing `%` or `#` between an existing `{}` pair can expand it to `{%  %}` or `{#  #}`.
- nvim-ts-context-commentstring dynamically selects HTML or Jinja comment syntax.

## Completion and Automatic Pairs

The default blink.cmp sources are:

- LSP
- Paths
- friendly-snippets
- Current buffer
- Copilot (idle until `:Copilot` activates the client)

Primary keys:

- `<C-y>` accepts a completion
- `<C-Space>` opens the menu or toggles documentation
- `<C-n>` / `<C-p>` selects the next/previous item
- `<C-e>` is removed from blink.cmp and reserved for the custom end-of-line mapping

blink.cmp `auto_brackets` adds `()` for function and method completions according to its default rules, including its default filetype safety exclusions; Python remains supported. nvim-autopairs handles manually typed pairs, Enter, and Backspace behavior, including its normal pairing rules in Markdown.

The Copilot provider is in blink.cmp's default source list, but stays idle until `:Copilot` loads and attaches the client. The Copilot suggestion and panel UIs remain disabled, and the lualine status component remains configured.

## Formatting

Formatting runs before save by default (with a two-second timeout, except for SQL and htmldjango) and can also be triggered manually with `<leader>F`. Conform may fall back to LSP formatting when the external formatter is unavailable.

| Filetype                            | Formatter                                           |
| ----------------------------------- | --------------------------------------------------- |
| C / C++                             | clang-format, four spaces, no tabs                  |
| Python                              | ruff_fix → ruff_format; the fix step ignores F401   |
| JavaScript / TypeScript / JSX / TSX | prettier                                            |
| HTML / Jinja / htmldjango           | djlint with Django profile and two-space indentation |
| CSS / SCSS                          | prettier                                            |
| JSON / Markdown                     | prettier                                            |
| YAML                                | yamlfmt                                             |
| Lua                                 | stylua with two spaces                              |
| Shell                               | shfmt with two spaces                               |
| Dockerfile                          | dprint                                              |
| SQL                                 | sql-formatter                                       |
| TOML                                | taplo                                               |

## Tree-sitter and UI

Automatically installed parsers: Lua, Vim, Vimdoc, Python, JavaScript, TypeScript, HTML, htmldjango, CSS, JSON, Markdown, Bash, C, C++, Rust, Go, and Java.

Tree-sitter starts for every recognized filetype. Markdown and Text are explicitly excluded from Tree-sitter folding. Python also restores Vim syntax so the PEP8 indent plugin can use `synID()`.

UI components:

- Nord theme with italic comments and bold lualine sections
- Transparent Normal, SignColumn, NormalNC, and MsgArea backgrounds
- Static mini.indentscope guide with no animation
- rainbow-delimiters with Nord and Catppuccin Frappé colors
- tiny-inline-diagnostic ghost preset with an 80ms throttle, multiline display, and soft wrapping
- Noice for command-line and message UI, with common file-write messages hidden
- Which-key modern preset with a 140ms delay and dynamic toggle-state icons
- Lspsaga with rounded floats; Outline auto-preview disabled, with no private-API overrides or forced hover focus
- nvim-colorizer for live color swatches

## Python Debugging

Mason DAP prepares debugpy, and nvim-dap-python uses:

```text
~/.local/share/nvim/mason/packages/debugpy/venv/bin/python
```

Python launch configurations include:

- Current file
- Current file with prompted arguments
- Run a Python module
- Attach to a host/port, defaulting to `127.0.0.1:5678`
- Run `doctest` against the current file

Programs use the integrated terminal. DAP avoids jumping into `winfixbuf` windows and forces redraws after important debug events.

## Troubleshooting

### `G` leaves the cursor at the bottom in Markdown

Markdown buffers map `G` to `Gzz`. It performs the native jump and then centers the target line. Check the mapping source with:

```vim
:verbose nmap G
```

### LSP does not start

```vim
:LspInfo
:Mason
:checkhealth lsp
```

This configuration uses the new API; do not convert it back to `require("lspconfig").SERVER.setup()`.

### Pyright cannot find the virtual environment

Verify that `.venv/bin/python`, `venv/bin/python`, or `env/bin/python` exists at the project root or within three parent levels. Use `:LspInfo` to confirm that Pyright is attached and inspect its project root.

### Formatting does nothing

```vim
:ConformInfo
:lua vim.print(require("conform").list_formatters())
```

Ensure the formatter is installed and available in `PATH`. SQL is formatted only when `<leader>F` is invoked manually.

### Completion does not add brackets

Confirm that blink.cmp `auto_brackets` is enabled. This configuration keeps the plugin's default safety exclusions: TSX, JSX, and Vue skip kind resolution, while Java skips semantic-token resolution; Python remains supported. Manually typed pairs are handled by nvim-autopairs.

### Python DAP does not start

```vim
:DapInstall
```

Also verify that the Mason debugpy Python path exists. Toggle the debug panel manually with `<leader>du`.

### Noice command-line problems

Noice is configured in `lua/plugins/lsp.lua`. Temporarily disabling its plugin spec can confirm a message-UI conflict; keep `lazyredraw=false`.

## Customization Entry Points

- General options: `lua/config/options.lua`
- Global keymaps: `lua/config/keymaps.lua`
- Filetype behavior: `lua/config/filetype.lua`
- Taskwarrior: `lua/config/taskwarrior.lua`
- UI: `lua/plugins/ui.lua`
- Completion: `lua/plugins/cmp.lua`
- LSP and diagnostics: `lua/plugins/lsp.lua`
- Search and file tree: `lua/plugins/snacks.lua`
- Git, tests, formatting, and editing tools: `lua/plugins/tools.lua`
- Debugging: `lua/plugins/debug.lua`
