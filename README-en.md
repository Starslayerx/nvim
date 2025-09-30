# Neovim Configuration

A modern and feature-rich Neovim configuration built with lazy.nvim package manager.

## 🎯 Overview

- **Package Manager**: lazy.nvim
- **Theme**: nord.nvim (Nord theme)
- **Leader Key**: Space
- **Transparency**: Enabled

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
- **nvim-treesitter** - Advanced syntax highlighting
- **rainbow-delimiters.nvim** - Rainbow parentheses
- **wildfire.nvim** - Quick content selection

### File Management & Search
- **snacks.nvim** - All-in-one toolkit (file explorer, picker, notification system, etc.)

### Formatting & Tools
- **conform.nvim** - Code formatter
- **friendly-snippets** - Code snippets

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
- Smart indent: Disabled
- Fold method: Indent
- Auto save: Disabled

### Search Settings
- Case sensitive
- Live search preview

### Performance Optimization
- Backup files disabled
- Hidden buffers enabled
- Fast updates

### Transparency Effects
- Main window background transparent
- Floating windows transparent
- Status area transparent

## 🎨 Features

1. **Integrated Toolkit**: Uses snacks.nvim for file explorer, picker, notification system, terminal, debugging tools, etc.
2. **Modern LSP**: Complete language server support with auto-installation and UI enhancement
3. **Code Formatting**: Auto-formatting for multiple languages
4. **Transparent Interface**: Window transparency effects
5. **Smart Completion**: Modern completion system based on blink.cmp
6. **Auto Bracket Completion**: Smart bracket pairing and completion
7. **Rainbow Parentheses**: Colorful parentheses highlighting for better code readability
8. **Quick Content Selection**: Use space key to quickly select code blocks
9. **Inline Diagnostics**: Show diagnostic information within code lines
10. **Window Selector**: Quickly switch and manage windows
11. **Keybinding Hints**: Real-time display of available keybindings

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
└── README.md             # Chinese docs
└── README-en.md          # This file
```

## 🚀 Getting Started

1. Ensure you have Neovim installed
2. Clone this configuration to `~/.config/nvim/`
3. Open Neovim and let lazy.nvim install all plugins
4. Use `<leader>?` to see available key mappings

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
