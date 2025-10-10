# Neovim 配置

一个基于 lazy.nvim 包管理器构建的现代化、功能丰富的 Neovim 配置。

## 🎯 配置概览

- **包管理器**: lazy.nvim
- **主题**: nord.nvim (Nord 主题)
- **Leader 键**: 空格键 (LocalLeader: `\`)
- **透明度**: 已启用
- **补全引擎**: blink.cmp (现代补全系统)
- **工具集**: snacks.nvim (一体化工具集合)

## 🔌 插件列表

### UI & 外观
- **nord.nvim** - Nord 主题，支持斜体注释和粗体 lualine
- **lualine.nvim** - 状态栏，使用 nord 主题
- **nvim-colorizer.lua** - 颜色高亮，使用自定义版本 (Starslayerx/nvim-colorizer.lua)
- **nvim-web-devicons** - 文件图标
- **mini.nvim** - 图标支持
- **window-picker.nvim** - 窗口选择器 (版本 2.*)
- **which-key.nvim** - 快捷键提示，使用 `<leader>?` 查看本地映射

### 代码补全 & LSP
- **blink.cmp** - 现代代码补全引擎 (版本 1.*)，使用 default 预设快捷键
- **nvim-autopairs** - 自动括号补全，禁用在宏中运行
- **nvim-lspconfig** - LSP 配置，支持 pyright 和 lua_ls
- **mason.nvim** - LSP 服务器管理，带有自定义图标
- **mason-lspconfig.nvim** - 自动安装 LSP (clangd, pyright, gopls, eslint, lua_ls, rust_analyzer, marksman)
- **trouble.nvim** - 诊断界面，支持多种视图模式
- **tiny-inline-diagnostic.nvim** - 行内诊断，使用 ghost 预设
- **lspsaga.nvim** - LSP UI 美化，圆角边框，禁用灯泡提示
- **noice.nvim** - 消息和命令行美化，多种预设启用
- **friendly-snippets** - 代码片段支持

### 语法高亮 & 编辑
- **nvim-treesitter** - 高级语法高亮 (main 分支)，内置渐进式代码选择
- **rainbow-delimiters.nvim** - 彩虹括号，使用 nord 和 Catppuccin Frappé 配色
- **内置 treesitter 选择** - 使用 `<CR>`/`<BS>`/`<TAB>` 进行渐进式代码选择

### 一体化工具集
- **snacks.nvim** - 一体化工具集，包含:
  - 文件浏览器 (替换 netrw，支持完整文件操作)
  - 智能文件选择器 (类似 fzf/Telescope)
  - 通知系统 (带历史记录，3秒超时)
  - 终端集成 (Ghostty 后端图片显示)
  - 大文件友好模式
  - 欢迎界面 (dashboard)
  - 图片显示支持
  - 缩进可视化
  - 作用域检测
  - 状态栏美化 (带折叠、Git 标记)
  - 单词高亮 (带跳转功能)
  - 草稿缓冲区
  - 快速文件渲染

### 格式化 & 工具
- **conform.nvim** - 代码格式化，支持保存时自动格式化
- **vim-python-pep8-indent** - Python PEP8 缩进

## ⌨️ 快捷键映射

### 基础操作
- `S` - 保存文件
- `Q` - 退出
- `Y` - 全选并复制到系统剪贴板
- `<leader><CR>` - 清除搜索高亮
- `K/J` - 快速上下移动 5 行
- `</>/` - 缩进/取消缩进

### 标签页管理
- `tn` - 新建标签页
- `tN` - 在当前标签页中分割
- `th/tl` - 前后切换标签页
- `tmh/tml` - 左右移动标签页

### 窗口管理
- `<C-h/j/k/l>` - 切换窗口 (普通模式和终端模式)
- `<leader>t` - 水平分割打开终端
- `<leader>T` - 垂直分割打开终端
- `<Esc>` - 终端模式下退出到普通模式

### 翻页功能
normal 模式:
- `<C-f>` - forward   向下翻一整屏
- `<C-b>` - backward  向上翻一整屏
- `<C-d>` - down half 向下翻半屏
- `<C-u>` - up half   向上翻半屏

insert 模式:
- `<C-j>` - forward   向下翻一整屏
- `<C-k>` - backward  向上翻一整屏

### 光标移动 (Insert 模式)
- `<C-f>` - 移动到行尾
- `<C-l>` - 向右移动一个字符
- `<C-b>` - 移动到行首

### Treesitter 代码选择
- `<CR>` - 初始化选择/扩展选择 (普通模式和可视模式)
- `<BS>` - 缩小选择 (可视模式)
- `<TAB>` - 作用域增量选择 (可视模式)

### Blink.cmp 补全快捷键 (Default 预设)
- `<C-y>` - 确认选择
- `<C-Space>` - 打开菜单或切换文档
- `<C-n>/<C-p>` 或 `Up/Down` - 选择下一个/上一个项目
- `<C-e>` - 隐藏菜单
- `<C-k>` - 切换签名帮助

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
- `<leader>.` - 切换草稿缓冲区
- `<leader>S` - 选择草稿缓冲区
- `]]` / `[[` - 跳转到下一个/上一个单词引用

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
- 符号列始终显示
- 滚动偏移量: 8 行

### 编辑设置
- Tab 宽度: 4 空格
- 智能缩进: 禁用 (nosmartindent)
- C 语言缩进: 禁用 (nocindent)
- 折叠方法: 缩进 (级别 99，默认展开)
- 自动缩进: 启用
- 显示不可见字符: 启用 (Tab 显示为两个空格，尾随空格显示为 ▫)
- 自动注释: 禁用
- 撤销文件: 启用 (持久化)
- 光标位置记忆: 启用

### 搜索设置
- 区分大小写 (ignorecase = false)
- 智能大小写: 禁用 (smartcase = false)
- 实时搜索预览 (inccommand = "split")
- 搜索高亮: 启用

### 分割窗口
- 垂直分割: 向右打开
- 水平分割: 向下打开

### 性能优化
- 禁用备份文件和交换文件
- 启用隐藏缓冲区
- 更新时间: 300ms
- 超时时间: 50ms
- 正则表达式引擎: 现代引擎 (re=0)
- 备份目录: ~/.config/nvim/tmp/backup
- 撤销目录: ~/.config/nvim/tmp/undo
- 禁用 lazyredraw 避免 UI 插件异常

### 补全设置
- 补全选项: longest, noinsert, menuone, noselect, preview
- 虚拟编辑: block 模式启用

### 透明度效果
- 主窗口背景透明 (Normal, NormalFloat)
- 符号列透明 (SignColumn)
- 非当前窗口透明 (NormalNC)
- 消息区域透明 (MsgArea)
- Telescope 界面透明 (TelescopeNormal, TelescopeBorder, TelescopePromptBorder)

## 🎨 特色功能

1. **一体化工具集**: 使用 snacks.nvim 整合了文件浏览器、选择器、通知系统、终端、调试工具等
2. **现代化 LSP**: 完整的语言服务器支持，包含自动安装和 UI 美化
3. **代码格式化**: 支持多种语言的自动格式化 (保存时触发)
4. **透明界面**: 支持窗口透明效果，自动应用于颜色主题
5. **智能补全**: 基于 blink.cmp 的现代补全系统，支持 LSP、路径、片段和缓冲区
6. **自动括号补全**: 智能括号配对和补全，禁用在特定文件类型和宏中
7. **彩虹括号**: 彩色括号高亮，使用 Nord 和 Catppuccin Frappé 配色方案
8. **快速内容选择**: 使用 `<CR>`/`<BS>`/`<TAB>` 进行渐进式代码选择，支持作用域检测
9. **行内诊断**: 在代码行内显示诊断信息，使用 ghost 预设样式
10. **窗口选择器**: 快速切换和管理窗口 (版本 2.*)
11. **快捷键提示**: 实时显示可用快捷键，使用 `<leader>?` 查看本地映射
12. **终端内图片显示**: 支持在终端中直接显示图片 (Ghostty 后端)
13. **草稿缓冲区**: 临时记事和快速计算功能
14. **文件浏览器增强**: 完整的文件操作支持 (添加、删除、重命名、复制、移动等)
15. **自动 LSP 安装**: Mason 自动安装和配置多种语言服务器
16. **光标位置记忆**: 重新打开文件时恢复上次的光标位置
17. **终端集成**: 智能终端管理，支持分割和快速切换

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

1. **环境准备**:
   - 确保已安装 Neovim 0.10+
   - 确保已禁用 Perl 和 Ruby 提供商 (配置中已自动设置)

2. **安装配置**:
   - 将此配置克隆到 `~/.config/nvim/`
   - 首次打开 Neovim，lazy.nvim 会自动安装所有插件

3. **初始化**:
   - Mason 将自动安装配置的 LSP 服务器
   - Treesitter 将自动安装语法解析器
   - 透明度效果将在颜色主题加载后自动应用

4. **使用指南**:
   - 使用 `<leader>?` 查看可用快捷键
   - 使用 `<leader>e` 打开文件浏览器
   - 使用 `<leader><space>` 智能查找文件

### 自动功能
- **自动完成**: 代码补全会自动触发
- **自动格式化**: 保存文件时自动格式化代码
- **自动诊断**: LSP 诊断信息实时显示
- **文件类型检测**: 自动启用对应的语法高亮和 LSP

## 🔧 自定义配置

### 核心配置文件
- **`lua/config/options.lua`** - 通用设置 (显示、编辑、搜索等)
- **`lua/config/keymaps.lua`** - 快捷键映射
- **`lua/config/transparency.lua`** - 透明度效果设置
- **`lua/config/lazy.lua`** - 包管理器初始化 (Leader 键设置)

### 插件配置文件
- **`lua/plugins/ui.lua`** - UI 相关插件 (主题、状态栏、图标等)
- **`lua/plugins/cmp.lua`** - 补全系统配置
- **`lua/plugins/lsp.lua`** - LSP 和诊断配置
- **`lua/plugins/snacks.lua`** - Snacks 工具集配置
- **`lua/plugins/tools.lua`** - 格式化和其他工具

### 快速修改指南
1. **修改主题**: 编辑 `lua/plugins/ui.lua` 中的 nord.nvim 配置
2. **添加 LSP**: 在 `lua/plugins/lsp.lua` 的 ensure_installed 中添加服务器
3. **修改快捷键**: 编辑 `lua/config/keymaps.lua` 添加自定义映射
4. **调整格式化**: 修改 `lua/plugins/tools.lua` 中的 formatters_by_ft
5. **禁用透明度**: 注释掉 `lua/config/transparency.lua` 的加载

此配置提供了一个完整、现代化的开发环境，具有出色的性能和可用性。所有组件都经过精心调试，确保兼容性和稳定性。

## 📝 语言支持

### LSP 服务器自动安装
配置自动安装以下 LSP 服务器：
- **clangd** - C/C++ 语言服务器
- **pyright** - Python 语言服务器
- **gopls** - Go 语言服务器
- **eslint** - JavaScript/TypeScript 代码检查
- **lua_ls** - Lua 语言服务器 (特别配置支持 Neovim API)
- **rust_analyzer** - Rust 语言服务器
- **marksman** - Markdown 语言服务器

### Treesitter 语法高亮
自动安装以下语言解析器：
- Lua, Vim, Vimdoc (Neovim 核心)
- Python, JavaScript, TypeScript
- HTML, CSS, JSON, Markdown
- Bash, C, C++, Rust, Go, Java

### 代码格式化支持
- **Python**: ruff (忽略 F401 未使用导入警告)
- **JavaScript/TypeScript**: prettier
- **Lua**: stylua (2空格缩进)
- **Shell**: shfmt (2空格缩进)

所有格式化工具支持保存时自动格式化，超时时间 500ms，LSP 作为后备格式化选项。
