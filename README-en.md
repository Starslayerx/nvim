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

### Code Completion & LSP
- **blink.cmp** - Code completion engine
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
- **snacks.nvim** - All-in-one toolkit (file explorer, picker, etc.)
- **window-picker.nvim** - Window selector
- **which-key.nvim** - Keybinding hints

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
- `<leader>e` - File explorer
- `<leader>ff` - Find files
- `<leader>fg` - Find git files
- `<leader>z` - Zen mode
- `<leader>gg` - Lazygit
- `<leader>F` - Format code

### LSP Keymaps
- `<leader>xx` - Toggle diagnostics panel
- `<leader>xX` - Buffer diagnostics
- `<leader>cs` - Symbols list
- `<leader>cl` - LSP information

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

1. **Integrated Toolkit**: Uses snacks.nvim for file explorer, picker, notification system, etc.
2. **Modern LSP**: Complete language server support with auto-installation and UI enhancement
3. **Code Formatting**: Auto-formatting for multiple languages
4. **Transparent Interface**: Window transparency effects
5. **Smart Completion**: Modern completion system based on blink.cmp

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
└── README.md             # This file
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