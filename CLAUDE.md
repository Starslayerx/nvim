# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Configuration Architecture

This is a Neovim configuration built with **lazy.nvim** as the package manager. The configuration follows a modular structure:

### Core Bootstrap Flow
1. `init.lua` - Entry point that:
   - Disables Perl and Ruby providers
   - Loads lazy.nvim package manager
   - Loads custom configuration modules (transparency, keymaps, options)

2. `lua/config/lazy.lua` - Bootstraps lazy.nvim and sets:
   - Leader key: Space
   - LocalLeader: `\`
   - Plugin spec imports from `lua/plugins/`
   - Git submodules disabled for plugins

3. Plugin configuration is split into semantic modules in `lua/plugins/`:
   - `ui.lua` - Theme, statusline, icons, treesitter, rainbow brackets
   - `cmp.lua` - Completion system (blink.cmp, Copilot, autopairs)
   - `lsp.lua` - LSP servers, Mason, diagnostics, Trouble, lspsaga, noice
   - `snacks.lua` - fzf-lua and neo-tree configuration
   - `tools.lua` - Gitsigns, vim-illuminate, neotest, formatters (conform.nvim), wildfire, PEP8 indent
   - `debug.lua` - nvim-dap debugging setup (Python debugpy)

### LSP Configuration Strategy

This config uses the **new Neovim LSP API** (vim.lsp.config/enable) instead of the traditional lspconfig setup:

```lua
-- New API pattern used in lua/plugins/lsp.lua:
vim.lsp.config(server, server_opts)
vim.lsp.enable(server)
```

Mason auto-installs LSP servers: clangd, pyright, gopls, eslint, ts_ls, lua_ls, rust_analyzer, marksman, html, cssls, jsonls, yamlls, bashls, dockerls, taplo, emmet_language_server

Special configurations:
- **pyright**: Type checking disabled (`typeCheckingMode = "off"`), automatic venv discovery (searches up 3 levels for .venv/venv/env)
- **lua_ls**: Configured for Neovim API with `vim` global recognized
- **Django templates**: Use HTML LS + Emmet. `jinja_lsp` is intentionally disabled because it cannot resolve Django's runtime template context and reports false errors.

### Completion System

Uses **blink.cmp** (modern completion engine) with:
- Default preset keybindings (`<C-y>` to accept, `<C-Space>` to toggle docs)
- GitHub Copilot integration via blink-copilot (lazy-loaded: use `:Copilot` command to activate)
- LSP capabilities from blink.cmp are passed to all LSP servers
- **auto_brackets**: blink.cmp handles bracket insertion for function/method completions
  - Uses blink.cmp's default kind/semantic-token resolution and safety exclusions
  - Python remains supported; the default blocked-filetype lists are not overridden
- **nvim-autopairs**: Handles manual bracket input, <CR> formatting, bracket deletion
  - Disabled in macros and replace mode
  - Python quotes, including f-strings, use the plugin's default pairing rules

### Formatting

**conform.nvim** handles formatting with auto-format on save (2000ms timeout):
- Python: ruff (ignores F401)
- JS/TS/React: prettier
- HTML/CSS/JSON/Markdown: prettier
- Lua: stylua (2 spaces)
- Shell: shfmt (2 spaces)
- C/C++: clang-format (4 spaces, tabs as spaces)
- YAML: yamlfmt
- SQL: sql_formatter (disabled auto-format on save to avoid syntax errors)
- TOML: taplo
- Dockerfile: dprint

### Key Settings

Important options in `lua/config/options.lua`:
- Tab width: 4 spaces
- Smart indent/C indent: **disabled** (nosmartindent, nocindent)
- Fold method: indent (level 99, Treesitter takes over via plugins)
- Case-sensitive search (ignorecase=false, smartcase=false)
- Persistent undo in `~/.config/nvim/tmp/undo/`
- Transparency effects applied via `lua/config/transparency.lua`
- Auto-comment disabled via FileType autocmd
- Cursor position remembered on file reopen

### UI and Visual Features

- **Theme**: nord.nvim with italic comments and bold lualine
- **Treesitter**: Main branch, lazy=false (no lazy-loading supported)
  - Auto-installs parsers: lua, vim, python, javascript, typescript, html, css, json, markdown, bash, c, cpp, rust, go, java
  - Enables folding via `vim.treesitter.foldexpr()`
  - Excludes markdown/text from treesitter folding
- **Rainbow brackets**: HiPhish/rainbow-delimiters.nvim with Nord + Catppuccin Frappé colors
  - Submodules disabled (testing dependencies not needed)
  - Strategy: global by default, local for vim files
- **Inline diagnostics**: tiny-inline-diagnostic.nvim
  - Ghost preset, 80ms throttle, multiline display, and soft wrapping
  - Disables default vim virtual_text
  - Hidden in Insert mode and refreshed after leaving Insert mode
- **lspsaga**: LSP UI with rounded borders
  - `<leader>lh` opens hover documentation without forcibly changing the active window
  - Outline auto-preview is disabled; the configuration does not override lspsaga private APIs
- **noice.nvim**: Enabled for cmdline/notifications/popupmenu; the native message UI retains bottom-line search counts

### Debugging Configuration

- **nvim-dap**: Core debugging with Nord-themed breakpoint signs
  - Breakpoint signs: ● (red), ◆ (orange condition), ○ (gray rejected), ➜ (green stopped), ◉ (yellow logpoint)
  - Signs don't highlight line numbers to avoid interfering with relative numbers
- **nvim-dap-view**: Unified debug panel with tab-like sections in a single window
  - Auto-opens on debug start, auto-closes on terminate/exit
  - Configured as a right-side panel with tab-like sections
  - Sections: scopes, breakpoints, threads, watches, REPL, console
  - Force redraw after DAP events to fix rendering issues
- **nvim-dap-python**: Uses Mason-installed debugpy at `~/.local/share/nvim/mason/packages/debugpy/venv/bin/python`
- **mason-nvim-dap**: Auto-installs debugpy
- **Terminal split shortcuts**: `<C-w>t` opens a horizontal terminal split and `<C-w>T` opens a vertical terminal split, intentionally overriding the built-in `CTRL-W_t` / `CTRL-W_T` window commands

### Git And Test Workflow

- **gitsigns.nvim**: Inline Git hunk workflow
  - Navigation: `<leader>gj` / `<leader>gk`
  - Hunk actions: `<leader>gs`, `<leader>gr`, `<leader>gp`, `<leader>gi`
  - Buffer actions: `<leader>gS`, `<leader>gR`
  - Review actions: `<leader>gb`, `<leader>gd`, `<leader>gD`, `<leader>gq`
  - Toggles: `<leader>gl`, `<leader>gw`
- **neotest**: Test runner with Python, Go, and Vitest adapters
  - Run nearest/file/project: `<leader>tn`, `<leader>tf`, `<leader>ta`
  - Debug nearest test through DAP: `<leader>td`
  - Python-only test debugging: `<leader>tm`, `<leader>tc`
  - Test UI: `<leader>ts`, `<leader>to`, `<leader>tO`
  - Watch/stop: `<leader>tw`, `<leader>tS`

## Development Commands

### Testing Configuration Changes

After modifying plugin config:
```bash
nvim  # Just restart Neovim - lazy.nvim auto-loads changes
```

To manually update plugins:
```vim
:Lazy sync  " Update all plugins
:Lazy clean " Remove unused plugins
```

### LSP Management

```vim
:Mason              " Open Mason UI to manage LSP servers
:LspInfo            " Show attached LSP clients
:Trouble diagnostics " View all diagnostics
```

### Checking Plugin Status

```vim
:Lazy               " Open lazy.nvim UI
:checkhealth lazy   " Check lazy.nvim health
:checkhealth lsp    " Check LSP configuration
:checkhealth fzf_lua " Check fzf-lua integration and external binary support
```

### Format Code

Format current buffer:
```vim
<leader>F  " Uses conform.nvim formatters
```

### Debug Commands

```vim
:DapInstall         " Install debug adapters via Mason
<leader>ds          " Start debugging
<leader>dc          " Continue debugging
<leader>dn          " Step over
<leader>di          " Step into
<leader>do          " Step out
<leader>db          " Toggle breakpoint
<leader>du          " Toggle debug view
<leader>dp          " Open debug REPL
<leader>dq          " Terminate debugging
```

### Test Commands

```vim
<leader>tn          " Run nearest test
<leader>tf          " Run current file
<leader>ta          " Run current project
<leader>td          " Debug nearest test
<leader>tm          " Debug current test method (Python only)
<leader>tc          " Debug current test class (Python only)
<leader>ts          " Toggle neotest summary
<leader>to          " Open latest output
```

### Copilot Activation

Copilot is lazy-loaded and requires manual activation:
```vim
:Copilot            " Authenticate and activate Copilot
```

## Architecture Considerations

### Plugin Organization

When adding new plugins:
- UI/visual plugins → `lua/plugins/ui.lua`
- Completion/snippets → `lua/plugins/cmp.lua`
- LSP/diagnostics → `lua/plugins/lsp.lua`
- Search/file navigation → `lua/plugins/snacks.lua`
- File operations/utilities → `lua/plugins/tools.lua`
- Debugging → `lua/plugins/debug.lua`

### Keybinding Strategy

Core keybindings are in `lua/config/keymaps.lua`, but many plugins define their own in their config:
- Buffer: `<leader>bb` (buffer list), `<leader>bn` / `<leader>bp` (next/prev), `<leader>bd` (delete)
- Gitsigns: `<leader>g*`
- vim-illuminate: `]r` / `[r` (next/prev reference), `<leader>ch` (toggle current buffer highlighting)
- Neotest: `<leader>t*`
- Trouble: `<leader>x*` prefix (diagnostics)
- fzf-lua: primary search mappings (`<leader><space>`, `<leader>bb`, `<leader>/`, `<leader>:`, `<leader>ff`, `<leader>fg`, `<leader>fb`, `<leader>fc`, `<leader>fr`, `<leader>fs`, `<leader>fS`, `<leader>ft`, `<leader>fT`, `<leader>fR`)
- Neo-tree: `<leader>e` (filesystem reveal left toggle), `o` (open in new tab), `H` (toggle hidden/gitignored)
- LSP/lspsaga: `gh` (hover), `gd` (definition), `gp` (peek), `gr` (references), `<leader>rn` (rename), `<leader>ca` (code action), `<leader>o` (outline)
- DAP: `<leader>d*` prefix (all debug operations)
- LSP is defined in plugin specs (see `keys = {}` tables)

### LSP Server Addition

To add a new LSP server:

1. Add to Mason's ensure_installed in `lua/plugins/lsp.lua`:
```lua
ensure_installed = {
  "clangd", "pyright", ..., "new_server",
}
```

2. If special config needed, add to the loop in mason-lspconfig config:
```lua
vim.lsp.config.new_server = {
  capabilities = capabilities,
  settings = { ... }
}
```

3. Mason will auto-install on next Neovim start

### Transparency System

Transparency is managed separately in `lua/config/transparency.lua` and applied via autocmd after ColorScheme load. To disable transparency, comment out the require in `init.lua`.

## File Explorer And Search

Use **fzf-lua** as the default picker layer for files, buffers, grep, command history, and recent files.

File explorer is **neo-tree**:
- `<leader>e`: `:Neotree filesystem reveal left toggle`
- `<CR>` / `l`: open in current window
- `o`: open in a new tab
- `s` / `S`: vertical / horizontal split
- `H`: toggle hidden and gitignored files
- Hidden files and gitignored files are filtered by default
- `follow_current_file` is disabled so changing window focus does not move the tree selection; `<leader>e` explicitly uses `reveal` when opening the tree
- A `CursorMoved` guard preserves the configured `scrolloff` margin only in normal editable buffers; Neo-tree manages its own cursor and scroll position
- `t` is intentionally unmapped inside neo-tree so tab navigation keeps working elsewhere

## Debugging Tips

If LSP not working:
1. Check `:LspInfo` - is server attached?
2. Check `:Mason` - is server installed?
3. Check `~/.local/share/nvim/mason/packages/` for actual installation
4. Verify using new API: `vim.lsp.config.*` not `require("lspconfig").*.setup()`

If completion not working:
1. Check if blink.cmp loaded: `:lua require('blink.cmp')`
2. For Copilot: Did you run `:Copilot` to authenticate?
3. Check whether blink.cmp intentionally excludes the current filetype from automatic bracket resolution

If formatting not working:
1. Check conform setup: `:lua vim.print(require('conform').list_formatters())`
2. Check if formatter installed in Mason or system PATH
3. For SQL files, auto-format on save is disabled to prevent syntax errors

If autopairs not working with blink.cmp:
1. Verify blink.cmp auto_brackets is enabled; this config keeps its default filetype exclusions
2. Check nvim-autopairs is not disabled for your filetype
3. Remember: blink handles function/method completions, autopairs handles manual input

If debugging not working:
1. Check `:DapInstall` shows debugpy installed
2. For Python: verify Mason debugpy path exists at `~/.local/share/nvim/mason/packages/debugpy/venv/bin/python`
3. Check DAP UI opens automatically when debug starts
4. Verify breakpoint signs are visible in sign column

## Common Issues and Solutions

### Pyright Type Checking Errors

**Problem**: Type errors like `Cannot access attribute "aclose"` shown but code runs fine.

**Solution**: This config disables Pyright type checking via:
```lua
vim.lsp.config.pyright = {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        diagnosticSeverityOverrides = {
          reportAttributeAccessIssue = "none",
          -- ... other disabled rules
        },
      },
    },
  },
}
```

If config not applying:
1. Confirm using `vim.lsp.config.*` not `lspconfig.*.setup()`
2. Clean Mason symlinks: `rm -f ~/.local/share/nvim/mason/bin/pyright*`
3. Reinstall: `:MasonInstall pyright`

### Bracket Auto-Completion Issues

**Problem**: Functions don't get `()` after completion, or manual brackets don't pair.

**Solution**: This config uses a **combined approach**:
- **blink.cmp auto_brackets**: Handles function/method completions
  - Uses blink.cmp defaults instead of clearing its safety exclusions
  - Python is supported; kind resolution remains blocked for TSX/JSX/Vue and semantic-token resolution for Java
- **nvim-autopairs**: Handles manual bracket input and <CR> formatting
  - Check your filetype is not in `disable_filetype`

Test scenarios:
```python
# Type "pri", select "print" → print(|)  (blink.cmp)
# Type "(" → (|)  (nvim-autopairs)
# In {|}, press <CR> → multi-line format  (nvim-autopairs)
```

### Virtual Environment Not Detected

**Problem**: Pyright can't find project dependencies.

**Solution**: This config auto-discovers venvs by searching up 3 levels for `.venv`, `venv`, or `env` directories. The venv must have a `bin/python` executable. If not found, pyright uses system Python.

### Rainbow Brackets Git Submodule Errors

**Problem**: Warning about git submodules during plugin update.

**Solution**: Submodules are intentionally disabled in lazy.nvim config (`git.submodules = false`) because most plugin submodules are testing dependencies users don't need. The warning is safe to ignore.

### Noice.nvim Command Line Issues

**Problem**: Command line behaves unexpectedly.

**Solution**: Noice is enabled for cmdline beautification. If causing issues, disable by setting `enabled = false` in the noice plugin spec in `lua/plugins/lsp.lua`. The config uses `command_palette = false` to avoid conflicts.

### Lspsaga UI Behavior

`<leader>lh` opens hover documentation without forcibly focusing the float. `<leader>o` toggles Outline with auto-preview disabled. Keep the integration on lspsaga's public setup options and commands; update or pin the plugin if an upstream regression appears instead of overriding private modules.
