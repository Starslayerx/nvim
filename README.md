# Neovim 配置

一个基于 lazy.nvim 包管理器构建的现代化、功能丰富的 Neovim 配置。

## 🎯 配置概览

- **包管理器**: lazy.nvim
- **主题**: nord.nvim (Nord 主题)
- **Leader 键**: 空格键
- **透明度**: 已启用

## 🔌 插件列表

### UI & 外观
- **nord.nvim** - Nord 主题
- **lualine.nvim** - 状态栏
- **nvim-colorizer.lua** - 颜色高亮
- **nvim-web-devicons** - 文件图标
- **mini.nvim** - 图标支持
- **window-picker.nvim** - 窗口选择器
- **which-key.nvim** - 快捷键提示

### 代码补全 & LSP
- **blink.cmp** - 代码补全引擎
- **nvim-autopairs** - 自动括号补全
- **nvim-lspconfig** - LSP 配置
- **mason.nvim** - LSP 服务器管理
- **mason-lspconfig.nvim** - 自动安装 LSP
- **trouble.nvim** - 诊断界面
- **tiny-inline-diagnostic.nvim** - 行内诊断
- **lspsaga.nvim** - LSP UI 美化
- **noice.nvim** - 消息和命令行美化

### 语法高亮 & 编辑
- **nvim-treesitter** - 高级语法高亮
- **rainbow-delimiters.nvim** - 彩虹括号
- **wildfire.nvim** - 快速内容选择

### 文件管理 & 搜索
- **snacks.nvim** - 一体化工具集（文件浏览器、选择器、通知系统等）

### 格式化 & 工具
- **conform.nvim** - 代码格式化
- **friendly-snippets** - 代码片段

## ⌨️ 快捷键映射

### 基础操作
- `S` - 保存文件
- `Q` - 退出
- `Y` - 全选并复制到系统剪贴板
- `<leader><CR>` - 清除搜索高亮
- `K/J` - 快速上下移动 5 行

### 标签页管理
- `tn` - 新建标签页
- `tN` - 在当前标签页中分割
- `th/tl` - 前后切换标签页
- `tmh/tml` - 左右移动标签页

### 窗口管理
- `<C-h/j/k/l>` - 切换窗口
- `<leader>t` - 水平分割打开终端
- `<leader>T` - 垂直分割打开终端

### 翻页功能
normal 模式:  
- `<C-f>` - forward   向下翻一整屏
- `<C-b>` - backward  向上翻一整屏
- `<C-d>` - down half 向下翻半屏
- `<C-u>` - up half   向上翻半屏

insert 模式:  
- `<C-j>` - forward   向下翻一整屏
- `<C-k>` - backward  向上翻一整屏

### Snacks 快捷键
- `<leader><space>` - 智能文件查找
- `<leader>,` - 缓冲区列表
- `<leader>/` - 全局搜索
- `<leader>:` - 命令历史
- `<leader>n` - 通知历史
- `<leader>e` - 文件浏览器
- `<leader>ff` - 查找文件
- `<leader>fg` - 查找 git 文件
- `<leader>fb` - 查找缓冲区
- `<leader>fc` - 查找配置文件
- `<leader>fp` - 项目列表
- `<leader>fr` - 最近文件
- `<leader>z` - 禅模式
- `<leader>Z` - 缩放模式
- `<leader>gg` - Lazygit
- `<leader>gB` - Git 浏览
- `<leader>F` - 格式化代码
- `<leader>bd` - 删除缓冲区
- `<leader>cR` - 重命名文件
- `<leader>un` - 关闭所有通知
- `<c-/>` - 切换终端
- `<leader>N` - Neovim 新闻

### LSP 快捷键
- `<leader>xx` - 切换诊断面板
- `<leader>xX` - 缓冲区诊断
- `<leader>cs` - 符号列表
- `<leader>cl` - LSP 信息
- `<leader>xL` - 位置列表
- `<leader>xQ` - 快速修复列表

### 切换快捷键
- `<leader>us` - 拼写检查
- `<leader>uw` - 自动换行
- `<leader>uL` - 相对行号
- `<leader>ud` - 诊断信息
- `<leader>ul` - 行号显示
- `<leader>uc` - 隐藏级别
- `<leader>uT` - Treesitter
- `<leader>ub` - 深色背景
- `<leader>uh` - 内联提示
- `<leader>ug` - 缩进线
- `<leader>uD` - 暗淡模式

## ⚙️ 配置选项

### 显示设置
- 行号 + 相对行号
- 光标行高亮
- 100 列标记线
- 自动换行

### 编辑设置
- Tab 宽度: 4 空格
- 智能缩进: 禁用
- 折叠方法: 缩进
- 自动保存: 禁用

### 搜索设置
- 区分大小写
- 实时搜索预览

### 性能优化
- 禁用备份文件
- 启用隐藏缓冲区
- 快速更新

### 透明度效果
- 主窗口背景透明
- 浮动窗口透明
- 状态栏区域透明

## 🎨 特色功能

1. **一体化工具集**: 使用 snacks.nvim 整合了文件浏览器、选择器、通知系统、终端、调试工具等
2. **现代化 LSP**: 完整的语言服务器支持，包含自动安装和 UI 美化
3. **代码格式化**: 支持多种语言的自动格式化
4. **透明界面**: 支持窗口透明效果
5. **智能补全**: 基于 blink.cmp 的现代补全系统
6. **自动括号补全**: 智能括号配对和补全
7. **彩虹括号**: 彩色括号高亮，提高代码可读性
8. **快速内容选择**: 使用空格键快速选择代码块
9. **行内诊断**: 在代码行内显示诊断信息
10. **窗口选择器**: 快速切换和管理窗口
11. **快捷键提示**: 实时显示可用快捷键

## 📁 项目结构

```
~/.config/nvim/
├── init.lua              # 主配置文件
├── lua/
│   ├── config/
│   │   ├── lazy.lua      # 包管理器设置
│   │   ├── keymaps.lua   # 快捷键映射
│   │   ├── options.lua   # 通用设置
│   │   └── transparency.lua # 透明度设置
│   └── plugins/
│       ├── cmp.lua       # 补全插件
│       ├── lsp.lua       # LSP 插件
│       ├── snacks.lua    # Snacks 工具集
│       ├── tools.lua     # 工具插件
│       └── ui.lua        # UI 插件
└── README.md          # 本文档
└── README-en.md       # 英文文档
```

## 🚀 开始使用

1. 确保已安装 Neovim
2. 将此配置克隆到 `~/.config/nvim/`
3. 打开 Neovim，让 lazy.nvim 自动安装所有插件
4. 使用 `<leader>?` 查看可用快捷键

## 🔧 自定义配置

- 编辑 `lua/config/options.lua` 修改通用设置
- 修改 `lua/config/keymaps.lua` 添加自定义快捷键
- 更新 `lua/plugins/` 目录中的插件配置

此配置提供了一个完整、现代化的开发环境，具有出色的性能和可用性。

## 📝 语言支持

配置支持以下语言的语法高亮和 LSP：
- Python (pyright)
- JavaScript/TypeScript (eslint, prettier)
- Lua (lua_ls)
- Go (gopls)
- Rust (rust_analyzer)
- C/C++ (clangd)
- Markdown (marksman)
- 以及其他常见语言

语法高亮支持：Python, JavaScript, TypeScript, Lua, Go, HTML, CSS, JSON, YAML, TOML, LaTeX, Markdown, Dockerfile, Norg, SCSS, Svelte, TSX, Typst, Vue, Regex

## 🛠️ 代码格式化

配置了以下格式化工具：
- Python: ruff
- JavaScript/TypeScript: prettier
- Lua: stylua
- Shell: shfmt

所有格式化都支持保存时自动格式化。
