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
   - `snacks.lua` - Snacks.nvim toolkit (explorer, picker, terminal, notifications)
   - `tools.lua` - Formatters (conform.nvim), wildfire, PEP8 indent
   - `debug.lua` - nvim-dap debugging setup (Python debugpy)

### LSP Configuration Strategy

This config uses the **new Neovim LSP API** (vim.lsp.config/enable) instead of the traditional lspconfig setup:

```lua
-- New API pattern used in lua/plugins/lsp.lua:
vim.lsp.config(server, server_opts)
vim.lsp.enable(server)
```

Mason auto-installs LSP servers: clangd, pyright, gopls, eslint, lua_ls, rust_analyzer, marksman

Special configurations:
- **pyright**: Type checking disabled (`typeCheckingMode = "off"`), automatic venv discovery (searches up 3 levels for .venv/venv/env)
- **lua_ls**: Configured for Neovim API with `vim` global recognized

### Completion System

Uses **blink.cmp** (modern completion engine) with:
- Default preset keybindings (`<C-y>` to accept, `<C-Space>` to toggle docs)
- GitHub Copilot integration via blink-copilot (lazy-loaded: use `:Copilot` command to activate)
- LSP capabilities from blink.cmp are passed to all LSP servers
- **auto_brackets**: blink.cmp handles bracket insertion for function/method completions
  - Uses both `kind_resolution` and `semantic_token_resolution` (400ms timeout)
  - `blocked_filetypes` cleared to support all languages including Python, TS, Vue
- **nvim-autopairs**: Handles manual bracket input, <CR> formatting, bracket deletion
  - Disabled in macros, replace mode, and snacks_picker_input
  - Special rule for Python f-strings (f' and f" auto-pairing)

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
  - Ghost preset, throttle 150ms, multiline enabled
  - Disables default vim virtual_text
  - Smart delay: waits 300ms after fast typing before showing diagnostics
- **lspsaga**: LSP UI with rounded borders, winblend=0 (opaque)
  - Hover window: auto position, prefer below, offset_y=1 to avoid covering current line
  - Auto-focuses hover window after 50ms delay
- **noice.nvim**: Enabled for cmdline/messages/popupmenu beautification

### Debugging Configuration

- **nvim-dap**: Core debugging with Nord-themed breakpoint signs
  - Breakpoint signs: ● (red), ◆ (orange condition), ○ (gray rejected), ➜ (green stopped), ◉ (yellow logpoint)
  - Signs don't highlight line numbers to avoid interfering with relative numbers
- **nvim-dap-ui**: Auto-opens on debug start, auto-closes on terminate/exit
  - Left panel: scopes, breakpoints, stacks, watches
  - Bottom panel: repl, console
  - Force redraw after DAP events to fix rendering issues
- **nvim-dap-python**: Uses Mason-installed debugpy at `~/.local/share/nvim/mason/packages/debugpy/venv/bin/python`
- **mason-nvim-dap**: Auto-installs debugpy

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
```

### Format Code

Format current buffer:
```vim
<leader>F  " Uses conform.nvim formatters
```

### Debug Commands

```vim
:DapInstall         " Install debug adapters via Mason
<leader>dc          " Start/continue debugging
<leader>db          " Toggle breakpoint
<leader>du          " Toggle debug UI
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
- File operations/utilities → `lua/plugins/snacks.lua` or `lua/plugins/tools.lua`
- Debugging → `lua/plugins/debug.lua`

### Keybinding Strategy

Core keybindings are in `lua/config/keymaps.lua`, but many plugins define their own in their config:
- Trouble: `<leader>x*` prefix (diagnostics)
- Snacks: `<leader>e` (explorer), `<leader><space>` (find files), `<leader>gg` (lazygit)
- LSP/lspsaga: `gh` (hover), `gd` (definition), `gp` (peek), `gr` (references), `<leader>rn` (rename), `<leader>ca` (code action)
- Debug: `<leader>d*` prefix (all debug operations)
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

## Snacks.nvim Integration

This config heavily uses **snacks.nvim** for:
- File explorer (replaces netrw completely, left sidebar, devicons enabled)
- File picker (replaces Telescope, smart find with git-aware behavior)
- Terminal management (`<C-/>` toggle)
- Notification system (3s timeout, history accessible)
- Dashboard (currently disabled)
- Git integration (Lazygit wrapper at `<leader>gg`)
- Image display (ghostty backend)
- Indent guides and scope detection
- Statuscolumn beautification (mark, sign on left; fold, git on right)
- Word highlighting with jump navigation (`]]` / `[[`)
- Zen mode and zoom
- Scratch buffers

Most file/buffer operations should use Snacks keybindings (`<leader>e`, `<leader><space>`, `<leader>/`, etc.)

Explorer keybindings:
- `<CR>`: enter dir/open file, `<BS>`: up one level, `h`/`l`: close/open
- `a`/`d`/`r`/`c`/`y`/`p`: add/delete/rename/copy/yank path/paste
- `I`/`H`: toggle ignored/hidden, `Z`: close all subdirs
- `]g`/`[g`: jump to git changes, `]d`/`[d`: jump to diagnostics

### Special Snacks Features

- **scroll disabled**: Smooth scrolling is disabled to avoid search display issues
- **bigfile mode**: Enabled for large file performance
- **quickfile**: Instant file rendering
- **explorer follow_file**: Tracks file location (only works when cwd matches)
- **picker focus**: Explorer starts with list focused, not preview

## Debugging Tips

If LSP not working:
1. Check `:LspInfo` - is server attached?
2. Check `:Mason` - is server installed?
3. Check `~/.local/share/nvim/mason/packages/` for actual installation
4. Verify using new API: `vim.lsp.config.*` not `require("lspconfig").*.setup()`

If completion not working:
1. Check if blink.cmp loaded: `:lua require('blink.cmp')`
2. For Copilot: Did you run `:Copilot` to authenticate?
3. Check auto_brackets blocked_filetypes is empty for your filetype

If formatting not working:
1. Check conform setup: `:lua vim.print(require('conform').list_formatters())`
2. Check if formatter installed in Mason or system PATH
3. For SQL files, auto-format on save is disabled to prevent syntax errors

If autopairs not working with blink.cmp:
1. Verify blink.cmp auto_brackets is enabled with empty blocked_filetypes
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
  - Ensure `kind_resolution.blocked_filetypes = {}` (empty)
  - Ensure `semantic_token_resolution.blocked_filetypes = {}` (empty)
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

### Lspsaga Hover Window Covering Code

**Problem**: Hover documentation covers the line being edited.

**Solution**: Lspsaga is configured with `offset_y = 1` and `prefer_above = false` to prefer showing hover below and offset by 1 line. If still covering, increase `offset_y` value in `lua/plugins/lsp.lua`.
