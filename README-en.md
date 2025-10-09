# Neovim Configuration

A modern and feature-rich Neovim configuration built with lazy.nvim package manager.

## 🎯 Overview

- **Package Manager**: lazy.nvim
- **Theme**: nord.nvim (Nord theme)
- **Leader Key**: Space
- **Transparency**: Enabled
- **Completion Engine**: blink.cmp (Modern completion system)
- **Toolkit**: snacks.nvim (All-in-one toolkit)

## 🔌 Plugins

### UI & Appearance
- **nord.nvim** - Nord color theme
- **lualine.nvim** - Status line
- **nvim-colorizer.lua** - Color highlighter
- **nvim-web-devicons** - File icons
- **mini.nvim** - Icon support
- **window-picker.nvim** - Window selector
- **which-key.nvim** - Keybinding hints

### Code Completion & LSP
- **blink.cmp** - Code completion engine
- **nvim-autopairs** - Auto bracket completion
- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP server management
- **mason-lspconfig.nvim** - Automatic LSP installation
- **trouble.nvim** - Diagnostic interface
- **tiny-inline-diagnostic.nvim** - Inline diagnostics
- **lspsaga.nvim** - LSP UI enhancement
- **noice.nvim** - Enhanced messages and cmdline

### Syntax Highlighting & Editing
- **nvim-treesitter** - Advanced syntax highlighting (main branch, built-in progressive selection)
- **rainbow-delimiters.nvim** - Rainbow parentheses
- **Built-in treesitter selection** - Progressive code selection using `<CR>`/`<BS>`/`<TAB>`

### All-in-one Toolkit
- **snacks.nvim** - All-in-one toolkit, including:
  - File explorer (replaces netrw, supports file operations)
  - Smart file picker (like fzf/Telescope)
  - Notification system (with history)
  - Terminal integration
  - Big file friendly mode
  - Welcome dashboard
  - Image display support
  - Indent visualization
  - Scope detection
  - Smooth scrolling
  - Status bar enhancement
  - Word highlight (with jump functionality)
  - Scratch buffer

### Formatting & Tools
- **conform.nvim** - Code formatter
- **friendly-snippets** - Code snippets
- **vim-python-pep8-indent** - Python PEP8 indentation

## ⌨️ Key Mappings

### Basic Operations
- `S` - Save file
- `Q` - Quit
- `Y` - Select all and copy to system clipboard
- `<leader><CR>` - Clear search highlight
- `K/J` - Move 5 lines up/down quickly

### Tab Management
- `tn` - New tab
- `tN` - Split current buffer in new tab
- `th/tl` - Previous/Next tab
- `tmh/tml` - Move tab left/right

### Window Management
- `<C-h/j/k/l>` - Switch windows
- `<leader>t` - Open terminal (horizontal split)
- `<leader>T` - Open terminal (vertical split)

### Page Navigation
normal mode:
- `<C-f>` - forward   Page down one full screen
- `<C-b>` - backward  Page up one full screen
- `<C-d>` - down half Page down half screen
- `<C-u>` - up half   Page up half screen

insert mode:
- `<C-j>` - forward   Page down one full screen
- `<C-k>` - backward  Page up one full screen

### Cursor Movement (Insert Mode)
- `<C-f>` - Move to end of line
- `<C-l>` - Move one character to the right
- `<C-b>` - Move to beginning of line

### Snacks Keymaps
- `<leader><space>` - Smart file find
- `<leader>,` - Buffer list
- `<leader>/` - Global search
- `<leader>:` - Command history
- `<leader>n` - Notification history
- `<leader>e` - File explorer
- `<leader>ff` - Find files
- `<leader>fg` - Find git files
- `<leader>fb` - Find buffers
- `<leader>fc` - Find configuration files
- `<leader>fp` - Project list
- `<leader>fr` - Recent files
- `<leader>z` - Zen mode
- `<leader>Z` - Zoom mode
- `<leader>gg` - Lazygit
- `<leader>gB` - Git browser
- `<leader>F` - Format code
- `<leader>bd` - Delete buffer
- `<leader>cR` - Rename file
- `<leader>un` - Close all notifications
- `<c-/>` - Toggle terminal
- `<leader>N` - Neovim news
- `<leader>.` - Toggle scratch buffer
- `<leader>S` - Select scratch buffer
- `]]` / `[[` - Jump to next/previous word reference

### LSP Keymaps
- `<leader>xx` - Toggle diagnostics panel
- `<leader>xX` - Buffer diagnostics
- `<leader>cs` - Symbols list
- `<leader>cl` - LSP information
- `<leader>xL` - Location list
- `<leader>xQ` - Quickfix list

### Toggle Keymaps
- `<leader>us` - Spell check
- `<leader>uw` - Word wrap
- `<leader>uL` - Relative line numbers
- `<leader>ud` - Diagnostics
- `<leader>ul` - Line numbers
- `<leader>uc` - Conceal level
- `<leader>uT` - Treesitter
- `<leader>ub` - Dark background
- `<leader>uh` - Inline hints
- `<leader>ug` - Indent guides
- `<leader>uD` - Dim mode

## ⚙️ Configuration Options

### Display Settings
- Line numbers + relative numbers
- Cursor line highlight
- 100-column marker
- Auto wrap

### Editing Settings
- Tab width: 4 spaces
- Smart indent: Disabled (nosmartindent)
- Fold method: Indent
- Auto save: Disabled
- Auto indent: Enabled
- Show invisible characters: Enabled
- Auto comments: Disabled
- Undo files: Enabled (persistent)
- Cursor position memory: Enabled

### Search Settings
- Case sensitive
- Live search preview
- Smart case: Disabled

### Performance Optimization
- Backup files disabled
- Hidden buffers enabled
- Fast updates (updatetime=100ms)
- Regex engine: Modern engine (re=0)
- Backup directory: ~/.config/nvim/tmp/backup
- Undo directory: ~/.config/nvim/tmp/undo

### Transparency Effects
- Main window background transparent
- Floating windows transparent
- Status area transparent
- Telescope interface transparent
- Message area transparent

## 🎨 Features

1. **All-in-one Toolkit**: Uses snacks.nvim to integrate file explorer, picker, notification system, terminal, debugging tools, etc.
2. **Modern LSP**: Complete language server support with auto-installation and UI enhancement
3. **Code Formatting**: Auto-formatting for multiple languages
4. **Transparent Interface**: Window transparency effects
5. **Smart Completion**: Modern completion system based on blink.cmp
6. **Auto Bracket Completion**: Smart bracket pairing and completion
7. **Rainbow Parentheses**: Colorful parentheses highlighting for better code readability
8. **Quick Content Selection**: Use `<CR>`/`<BS>`/`<TAB>` for progressive code selection
9. **Inline Diagnostics**: Show diagnostic information within code lines
10. **Window Selector**: Quickly switch and manage windows
11. **Keybinding Hints**: Real-time display of available keybindings
12. **In-terminal Image Display**: Support for displaying images directly in terminal
13. **Scratch Buffer**: Temporary note-taking and quick calculations

## 📁 Project Structure

```
~/.config/nvim/
├── init.lua              # Main configuration file
├── lua/
│   ├── config/
│   │   ├── lazy.lua      # Package manager setup
│   │   ├── keymaps.lua   # Key mappings
│   │   ├── options.lua   # General settings
│   │   └── transparency.lua # Transparency settings
│   └── plugins/
│       ├── cmp.lua       # Completion plugins
│       ├── lsp.lua       # LSP plugins
│       ├── snacks.lua    # Snacks toolkit
│       ├── tools.lua     # Utility plugins
│       └── ui.lua        # UI plugins
└── README.md             # Chinese documentation
└── README-en.md          # This file
```

## 🚀 Getting Started

1. Ensure you have Neovim installed (recommended 0.10+)
2. Disable unnecessary Perl and Ruby providers (configured in init.lua)
3. Clone this configuration to `~/.config/nvim/`
4. Open Neovim and let lazy.nvim install all plugins
5. Use `<leader>?` to see available key mappings

### Notes
- Configuration has disabled Perl and Ruby language servers for faster startup
- Treesitter parsers and LSP servers will be automatically installed on first launch
- Transparency effects will be automatically applied after color theme loading

## 🔧 Customization

- Edit `lua/config/options.lua` for general settings
- Modify `lua/config/keymaps.lua` for custom key mappings
- Update plugin configurations in `lua/plugins/` directory

This configuration provides a complete, modern development environment with excellent performance and usability.

## 📝 Language Support

Configuration supports syntax highlighting and LSP for the following languages:
- Python (pyright)
- JavaScript/TypeScript (eslint, prettier)
- Lua (lua_ls)
- Go (gopls)
- Rust (rust_analyzer)
- C/C++ (clangd)
- Markdown (marksman)
- And other common languages

Syntax highlighting support: Python, JavaScript, TypeScript, Lua, Go, HTML, CSS, JSON, YAML, TOML, LaTeX, Markdown, Dockerfile, Norg, SCSS, Svelte, TSX, Typst, Vue, Regex

## 🛠️ Code Formatting

Configured with the following formatting tools:
- Python: ruff
- JavaScript/TypeScript: prettier
- Lua: stylua
- Shell: shfmt

All formatting supports auto-format on save.
