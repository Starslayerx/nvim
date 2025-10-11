# Neovim Configuration

A modern and feature-rich Neovim configuration built with lazy.nvim package manager.

## 🎯 Overview

- **Package Manager**: lazy.nvim (Auto-check for updates)
- **Theme**: nord.nvim (Nord theme)
- **Leader Key**: Space (LocalLeader: `\`)
- **Transparency**: Enabled
- **Completion Engine**: blink.cmp (Modern completion system with GitHub Copilot integration)
- **Toolkit**: snacks.nvim (All-in-one toolkit)
- **AI Assistant**: GitHub Copilot (Code completion and suggestions)

## 🔌 Plugins

### UI & Appearance
- **nord.nvim** - Nord theme with italic comments and bold lualine support
- **lualine.nvim** - Status line using nord theme with Copilot status integration
- **nvim-colorizer.lua** - Color highlighter, custom version (Starslayerx/nvim-colorizer.lua)
- **nvim-web-devicons** - File icons
- **mini.nvim** - Icon support
- **window-picker.nvim** - Window selector (version 2.*)
- **which-key.nvim** - Keybinding hints, use `<leader>?` for local mappings

### Code Completion & LSP
- **blink.cmp** - Modern completion engine (version 1.*) with default preset keybindings and Copilot integration
- **blink-copilot** - Copilot integration for Blink.cmp
- **copilot.lua** - GitHub Copilot support
- **copilot-lualine** - Copilot status display in Lualine
- **nvim-autopairs** - Auto bracket completion, disabled in macros and replace mode
- **nvim-lspconfig** - LSP configuration supporting pyright and lua_ls
- **mason.nvim** - LSP server management with custom icons
- **mason-lspconfig.nvim** - Auto-install LSP (clangd, pyright, gopls, eslint, lua_ls, rust_analyzer, marksman)
- **trouble.nvim** - Diagnostic interface with multiple view modes
- **tiny-inline-diagnostic.nvim** - Inline diagnostics with ghost preset and multiline support
- **lspsaga.nvim** - LSP UI enhancement with rounded borders, lightbulb disabled
- **noice.nvim** - Enhanced messages and cmdline with multiple presets
- **friendly-snippets** - Code snippets support

### Syntax Highlighting & Editing
- **nvim-treesitter** - Advanced syntax highlighting (main branch) with built-in progressive selection and folding support
- **rainbow-delimiters.nvim** - Rainbow parentheses using Nord and Catppuccin Frappé colors
- **Built-in treesitter selection** - Progressive code selection using `<CR>`/`<BS>`/`<TAB>`
- **wildfire.nvim** - Quick bracket content selection (custom version)

### All-in-one Toolkit
- **snacks.nvim** - All-in-one toolkit, including:
  - File explorer (replaces netrw with full file operations)
  - Smart file picker (like fzf/Telescope)
  - Notification system (with history, 3s timeout)
  - Terminal integration (Ghostty backend for images)
  - Big file friendly mode
  - Welcome dashboard
  - Image display support
  - Indent visualization
  - Scope detection
  - Status bar enhancement (with folds, Git marks)
  - Word highlight (with jump functionality)
  - Scratch buffer
  - Quick file rendering
  - Zen mode and window zoom
  - Git browse and Lazygit integration

### Formatting & Tools
- **conform.nvim** - Code formatter with auto-format on save
- **vim-python-pep8-indent** - Python PEP8 indentation

## ⌨️ Key Mappings

### Basic Operations
- `S` - Save file
- `Q` - Quit
- `Y` - Select all and copy to system clipboard
- `<leader><CR>` - Clear search highlight
- `K/J` - Move 5 lines up/down quickly
- `</>/` - Indent/Unindent

### Tab Management
- `tn` - New tab
- `tN` - Split current buffer in new tab
- `th/tl` - Previous/Next tab
- `tmh/tml` - Move tab left/right

### Window Management
- `<C-h/j/k/l>` - Switch windows (normal and terminal modes)
- `<leader>t` - Open terminal (horizontal split)
- `<leader>T` - Open terminal (vertical split)
- `<Esc>` - Exit to normal mode in terminal

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

### Treesitter Code Selection & Wildfire
- `<CR>` - Initialize/Expand selection (normal and visual modes)
- `<BS>` - Shrink selection (visual mode)
- `<TAB>` - Scope incremental selection (visual mode)

### Blink.cmp Completion Keys (Default preset)
- `<C-y>` - Accept completion
- `<C-Space>` - Open menu or toggle documentation
- `<C-n>/<C-p>` or `Up/Down` - Select next/previous item
- `<C-e>` - Hide menu
- `<C-k>` - Toggle signature help

### Snacks Keymaps
#### File Finding and Navigation
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

#### File Explorer Operations (in explorer)
- `<CR>` - Enter directory/Open file
- `<BS>` - Open parent directory
- `h` - Close directory
- `l` - Open file
- `t` - Open file in new tab
- `s` - Open in horizontal split
- `v` - Open in vertical split
- `a` - Add file/directory
- `d` - Delete file/directory
- `r` - Rename file/directory
- `c` - Copy file/directory
- `y` - Copy file path
- `p` - Paste file/directory
- `u` - Update file tree
- `P` - Preview file
- `I` - Show .gitignore files
- `H` - Show hidden files
- `Z` - Collapse all subdirectories
- `]g` / `[g` - Jump to next/previous git modified file
- `]d` / `[d` - Jump to next/previous file with diagnostics
- `]w` / `[w` - Jump to next/previous file with warnings
- `]e` / `[e` - Jump to next/previous file with errors

#### Other Features
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
- Sign column always visible
- Scroll offset: 8 lines

### Editing Settings
- Tab width: 4 spaces
- Smart indent: Disabled (nosmartindent)
- C indent: Disabled (nocindent)
- Fold method: Treesitter expr (level 99, not folded by default)
- Auto indent: Enabled
- Show invisible characters: Enabled (tabs as two spaces, trailing spaces as ▫)
- Auto comments: Disabled
- Undo files: Enabled (persistent)
- Cursor position memory: Enabled

### Search Settings
- Case sensitive (ignorecase = false)
- Smart case: Disabled (smartcase = false)
- Live search preview (inccommand = "split")
- Search highlight: Enabled

### Window Splits
- Vertical split: Opens to the right
- Horizontal split: Opens below

### Performance Optimization
- Backup and swap files disabled
- Hidden buffers enabled
- Update time: 300ms
- Timeout: 50ms
- Regex engine: Modern engine (re=0)
- Backup directory: ~/.config/nvim/tmp/backup
- Undo directory: ~/.config/nvim/tmp/undo
- Disable lazyredraw to prevent UI plugin issues

### Completion Settings
- Complete options: longest, noinsert, menuone, noselect, preview
- Virtual edit: Block mode enabled
- GitHub Copilot: Integrated into blink.cmp for smart completion

### Transparency Effects
- Main window background transparent (Normal, NormalFloat)
- Sign column transparent (SignColumn)
- Non-current windows transparent (NormalNC)
- Message area transparent (MsgArea)
- Telescope interface transparent (TelescopeNormal, TelescopeBorder, TelescopePromptBorder)

## 🎨 Features

1. **All-in-one Toolkit**: Uses snacks.nvim to integrate file explorer, picker, notification system, terminal, debugging tools, zen mode, etc.
2. **Modern LSP**: Complete language server support with auto-installation and UI enhancement
3. **Code Formatting**: Auto-formatting for multiple languages (triggers on save)
4. **Transparent Interface**: Window transparency effects automatically applied to color themes
5. **Smart Completion**: Modern completion system based on blink.cmp with LSP, path, snippets, buffer, and GitHub Copilot support
6. **Auto Bracket Completion**: Smart bracket pairing and completion, disabled in specific filetypes, macros, and replace mode
7. **Rainbow Parentheses**: Colorful parentheses highlighting using Nord and Catppuccin Frappé color schemes
8. **Quick Content Selection**: Use `<CR>`/`<BS>`/`<TAB>` for progressive code selection with scope detection
9. **Inline Diagnostics**: Show diagnostic information within code lines using ghost preset style with multiline support
10. **Window Selector**: Quickly switch and manage windows (version 2.*)
11. **Keybinding Hints**: Real-time display of available keybindings, use `<leader>?` for local mappings
12. **In-terminal Image Display**: Support for displaying images directly in terminal (Ghostty backend)
13. **Scratch Buffer**: Temporary note-taking and quick calculations
14. **Enhanced File Explorer**: Complete file operations support (add, delete, rename, copy, move, etc.)
15. **Auto LSP Installation**: Mason automatically installs and configures multiple language servers
16. **Cursor Position Memory**: Restores last cursor position when reopening files
17. **Terminal Integration**: Smart terminal management with split and quick switching support
18. **Treesitter Folding**: Intelligent code folding based on syntax tree
19. **Zen Mode**: Distraction-free focused editing mode
20. **GitHub Copilot**: AI code completion and suggestions

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

1. **Environment Setup**:
   - Ensure you have Neovim 0.10+ installed
   - Perl and Ruby providers are automatically disabled (configured in init.lua)

2. **Installation**:
   - Clone this configuration to `~/.config/nvim/`
   - On first launch, lazy.nvim will automatically install all plugins

3. **Initialization**:
   - Mason will automatically install configured LSP servers
   - Treesitter will automatically install syntax parsers
   - Transparency effects will be automatically applied after color theme loading

4. **Usage Guide**:
   - Use `<leader>?` to see available keybindings
   - Use `<leader>e` to open file explorer
   - Use `<leader><space>` for smart file finding

### Automatic Features
- **Auto Completion**: Code completion triggers automatically, including LSP, snippets, path, buffer, and Copilot suggestions
- **Auto Formatting**: Code auto-formats on file save (supports Python, JS/TS, Lua, Shell)
- **Auto Diagnostics**: LSP diagnostics display in real-time with multiline inline support
- **File Type Detection**: Automatically enables corresponding syntax highlighting and LSP
- **Auto Folding**: Intelligent code folding based on Treesitter
- **Auto Terminal Start**: Automatically enters insert mode on TermOpen

## 🔧 Customization

### Core Configuration Files
- **`lua/config/options.lua`** - General settings (display, editing, search, etc.)
- **`lua/config/keymaps.lua`** - Key mappings
- **`lua/config/transparency.lua`** - Transparency effects settings
- **`lua/config/lazy.lua`** - Package manager initialization (Leader key setup)

### Plugin Configuration Files
- **`lua/plugins/ui.lua`** - UI-related plugins (theme, status bar, icons, Treesitter, rainbow brackets, etc.)
- **`lua/plugins/cmp.lua`** - Completion system configuration (blink.cmp, Copilot, auto-pairs)
- **`lua/plugins/lsp.lua`** - LSP and diagnostics configuration (lspconfig, Mason, Trouble, diagnostics display)
- **`lua/plugins/snacks.lua`** - Snacks toolkit configuration (file explorer, picker, notifications, terminal, etc.)
- **`lua/plugins/tools.lua`** - Formatting and other tools (conform, wildfire, PEP8 indent)

### Quick Modification Guide
1. **Change Theme**: Edit nord.nvim configuration in `lua/plugins/ui.lua`
2. **Add LSP**: Add servers to ensure_installed in `lua/plugins/lsp.lua`
3. **Modify Keybindings**: Edit `lua/config/keymaps.lua` to add custom mappings
4. **Adjust Formatting**: Modify formatters_by_ft in `lua/plugins/tools.lua`
5. **Disable Transparency**: Comment out `require("config.transparency")` loading in `init.lua`
6. **Configure Copilot**: Adjust Copilot settings in `lua/plugins/cmp.lua`
7. **Customize File Explorer**: Modify explorer configuration in `lua/plugins/snacks.lua`

This configuration provides a complete, modern development environment with excellent performance and usability. All components have been carefully tuned to ensure compatibility and stability.

## 📝 Language Support

### Auto-installed LSP Servers
Configuration automatically installs the following LSP servers:
- **clangd** - C/C++ language server
- **pyright** - Python language server
- **gopls** - Go language server
- **eslint** - JavaScript/TypeScript linting
- **lua_ls** - Lua language server (specially configured for Neovim API support)
- **rust_analyzer** - Rust language server
- **marksman** - Markdown language server

### Treesitter Syntax Highlighting
Automatically installs the following language parsers:
- Lua, Vim, Vimdoc (Neovim core)
- Python, JavaScript, TypeScript
- HTML, CSS, JSON, Markdown
- Bash, C, C++, Rust, Go, Java

### Code Formatting Support
- **Python**: ruff (ignores F401 unused import warnings)
- **JavaScript/TypeScript**: prettier (stop after first successful formatter)
- **Lua**: stylua (2-space indentation)
- **Shell**: shfmt (2-space indentation)

All formatting tools support auto-format on save with 500ms timeout, LSP as fallback formatting option.
