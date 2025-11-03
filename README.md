# Fix tips

当你的 neovim 出现报错的解决方案：

1. 首先法确定报错原因
2. 根据错误信息定义到具体插件，可以通过暂时禁用插件的方式来实现
3. 确定错误插件后，看看最近是否有更新，再去 github 上面的 issues 里面看看，以此确定是自己的配置问题，还是更新引入的 bug
4. 如果是新 commit 的 bug，fork 代码仓库，使用自己仓库尝试修复然后测试，最后提交 pr
5. 如果配置问题，应该详细阅读文档

## 常见问题

### Pyright 类型检查错误

**问题**: 在 Python 文件中看到类似 `Cannot access attribute "aclose"` 的类型错误，但代码实际运行正常。

**原因**: Pyright 的静态类型分析无法推断动态属性（如 Redis 的 `aclose()` 方法）。

**解决方案**: 本配置已经通过以下方式禁用 Pyright 的类型检查：

```lua
-- lua/plugins/lsp.lua 中的配置
vim.lsp.config.pyright = {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        diagnosticSeverityOverrides = {
          reportAttributeAccessIssue = "none",  -- 关键配置
          reportGeneralTypeIssues = "none",
          -- ... 其他禁用规则
        },
      },
    },
  },
}
```

**重要**: 本配置使用 **新版 LSP API** (`vim.lsp.config` + `vim.lsp.enable`)，而不是旧版的 `lspconfig.*.setup()` 方式。如果遇到配置不生效的问题：

1. 确认使用的是 `vim.lsp.config.*` 而不是 `require("lspconfig").*.setup()`
2. 清理 Mason 的符号链接残留：
   ```bash
   rm -f ~/.local/share/nvim/mason/bin/pyright*
   rm -f ~/.local/share/nvim/mason/share/mason-schemas/lsp/pyright.json
   ```
3. 重新安装：`:MasonInstall pyright`

### blink.cmp 与 nvim-autopairs 集成

**问题**: 使用 blink.cmp 补全引擎后，Python 代码补全时不自动添加括号。

**原因**: blink.cmp 是较新的补全引擎，不像 nvim-cmp 那样有官方的 nvim-autopairs 集成支持。blink.cmp 没有 `event:on('confirm_done')` 事件系统，而 `nvim-autopairs.completion.cmp` 模块依赖 nvim-cmp 插件。

**解决方案**: 本配置采用 **组合方案**，让两个插件分工合作：

```lua
-- lua/plugins/cmp.lua 中的配置
{
  "saghen/blink.cmp",
  opts = {
    completion = {
      accept = { auto_brackets = { enabled = true } }, -- blink.cmp 内置括号补全
    },
    -- ... 其他配置
  },
}
```

**工作方式**:
- **blink.cmp 内置 auto_brackets**: 当你从补全菜单选择函数或方法时，自动添加 `()`
- **nvim-autopairs**: 处理其他所有括号配对场景
  - 手动输入 `(` 时自动补全 `)`
  - 在 `{|}` 位置按 `<CR>` 时格式化成多行
  - 删除左括号时自动删除右括号

**测试场景**:
```python
# 1. 补全函数后添加括号
# 输入 pri，选择 print 补全 → print(|)

# 2. 手动输入括号配对
# 输入 ( → (|)

# 3. 括号间回车格式化
# 在 {|} 中按 <CR> →
# {
#     |
# }
```

**注意**: 目前 nvim-autopairs 还没有添加对 blink.cmp 的原生支持（[GitHub Issue #477](https://github.com/windwp/nvim-autopairs/issues/477) 仍开放中）。本配置使用的组合方案是目前最稳定的解决办法。

# Neovim 配置

一个基于 lazy.nvim 包管理器构建的现代化、功能丰富的 Neovim 配置。

## 🎯 配置概览

- **包管理器**: lazy.nvim (自动检查更新)
- **主题**: nord.nvim (Nord 主题)
- **Leader 键**: 空格键 (LocalLeader: `\`)
- **透明度**: 已启用
- **补全引擎**: blink.cmp (现代补全系统，集成 GitHub Copilot)
- **工具集**: snacks.nvim (一体化工具集合)
- **AI 辅助**: GitHub Copilot (代码补全和建议)

## 🔌 插件列表

### UI & 外观

- **nord.nvim** - Nord 主题，支持斜体注释和粗体 lualine
- **lualine.nvim** - 状态栏，使用 nord 主题，集成 Copilot 状态显示
- **nvim-colorizer.lua** - 颜色高亮，使用自定义版本 (Starslayerx/nvim-colorizer.lua)
- **nvim-web-devicons** - 文件图标
- **mini.nvim** - 图标支持
- **window-picker.nvim** - 窗口选择器 (版本 2.\*)
- **which-key.nvim** - 快捷键提示，使用 `<leader>?` 查看本地映射

### 代码补全 & LSP

- **blink.cmp** - 现代代码补全引擎 (版本 1.\*)，使用 default 预设快捷键，集成 Copilot，内置 auto_brackets 功能处理函数/方法补全后的括号
- **blink-copilot** - Blink.cmp 的 Copilot 集成
- **copilot.lua** - GitHub Copilot 支持 (懒加载，使用 `:Copilot` 命令启动)
- **copilot-lualine** - Lualine 中的 Copilot 状态显示
- **nvim-autopairs** - 自动括号补全，与 blink.cmp 组合使用，处理手动输入括号、回车格式化等场景，禁用在宏和替换模式中运行
- **nvim-lspconfig** - LSP 配置，使用新版 API (vim.lsp.config/enable)，支持 pyright (关闭类型检查) 和 lua_ls
- **mason.nvim** - LSP 服务器管理，带有自定义图标
- **mason-lspconfig.nvim** - 自动安装 LSP (clangd, pyright, gopls, eslint, lua_ls, rust_analyzer, marksman)
- **trouble.nvim** - 诊断界面，支持多种视图模式
- **tiny-inline-diagnostic.nvim** - 行内诊断，使用 ghost 预设，支持多行显示
- **lspsaga.nvim** - LSP UI 美化，圆角边框，禁用灯泡提示
- **noice.nvim** - 消息和命令行美化，多种预设启用
- **friendly-snippets** - 代码片段支持

### 语法高亮 & 编辑

- **nvim-treesitter** - 高级语法高亮 (main 分支)，内置渐进式代码选择，支持折叠
- **rainbow-delimiters.nvim** - 彩虹括号，使用 nord 和 Catppuccin Frappé 配色
- **内置 treesitter 选择** - 使用 `<CR>`/`<BS>`/`<TAB>` 进行渐进式代码选择
- **wildfire.nvim** - 快速选择括号内容 (自定义版本)
- **nvim-surround** - 快速操作：选择后用符号包围内容

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
  - 禅模式和窗口缩放
  - Git 浏览和 Lazygit 集成

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

#### 基础窗口操作

- `<leader>t` - 水平分割打开终端
- `<leader>T` - 垂直分割打开终端
- `<Esc>` - 终端模式下退出到普通模式

#### 窗口切换 (原生 Vim 方式)

- `<C-w>h` - 切换到左侧窗口
- `<C-w>j` - 切换到下方窗口
- `<C-w>k` - 切换到上方窗口
- `<C-w>l` - 切换到右侧窗口
- `<C-w>w` - 循环切换到下一个窗口
- `<C-w>p` - 切换到上一个访问的窗口

#### 窗口布局调整

- `<C-w>=` - 平均分配所有窗口大小
- `<C-w>_` - 最大化当前窗口高度
- `<C-w>|` - 最大化当前窗口宽度
- `<C-w>+` - 增加当前窗口高度
- `<C-w>-` - 减少当前窗口高度
- `<C-w>>` - 增加当前窗口宽度
- `<C-w><` - 减少当前窗口宽度

#### 窗口移动和关闭

- `<C-w>H/J/K/L` - 将当前窗口移动到最左/下/上/右
- `<C-w>r` - 顺时针旋转窗口
- `<C-w>R` - 逆时针旋转窗口
- `<C-w>x` - 与下一个窗口交换位置
- `<C-w>o` - 关闭其他所有窗口 (only)
- `<C-w>q` - 退出当前窗口
- `<C-w>c` - 关闭当前窗口

### 翻页功能

normal 模式:

- `<C-f>` - forward 向下翻一整屏
- `<C-b>` - backward 向上翻一整屏
- `<C-d>` - down half 向下翻半屏
- `<C-u>` - up half 向上翻半屏

insert 模式:

- `<C-j>` - forward 向下翻一整屏
- `<C-k>` - backward 向上翻一整屏

### 光标移动 (Insert 模式)

- `<C-f>` - 移动到行尾
- `<C-l>` - 向右移动一个字符
- `<C-b>` - 移动到行首

### Treesitter 代码选择 & 编辑

- `<CR>` - 初始化选择/扩展选择 (普通模式和可视模式)
- `<BS>` - 缩小选择 (可视模式)
- `<TAB>` - 作用域增量选择 (可视模式)

### nvim-surround 快捷键

#### 添加包围符号

- `ys{motion}{char}` - 在指定范围添加包围符号
  - `ysiw"` - 给当前单词加双引号
  - `ysa")` - 给引号内容加圆括号 (around quotes with parentheses)
  - `yst;}` - 给当前位置到分号的内容加花括号
- `yss{char}` - 给整行添加包围符号 (忽略首尾空格)
- `yS{motion}{char}` - 添加包围符号，分隔到新行
- `ySS{char}` - 给整行添加包围符号，分隔到新行
- `<C-g>s{char}` - 插入模式：在光标位置添加包围符号
- `<C-g>S{char}` - 插入模式：在光标位置添加包围符号，分隔到新行
- `S{char}` - 可视模式：给选中内容添加包围符号
- `gS{char}` - 可视模式：给选中内容添加包围符号，分隔到新行

#### 删除包围符号

- `ds{char}` - 删除指定的包围符号
  - `ds"` - 删除双引号
  - `ds)` - 删除圆括号
  - `dst` - 删除 HTML 标签

#### 修改包围符号

- `cs{old}{new}` - 修改包围符号
  - `cs"'` - 将双引号改为单引号
  - `cs)}` - 将圆括号改为花括号
  - `cst<div>` - 将 HTML 标签改为 div 标签
- `cS{old}{new}` - 修改包围符号，分隔到新行

#### 特殊符号说明

- **括号/方括号/花括号/尖括号**：
  - 使用闭合符号 (`)`, `]`, `}`, `>`) - 紧贴内容：`{text}`
  - 使用开启符号 (`(`, `[`, `{`, `<`) - 添加空格：`{ text }`
- **HTML 标签** (`t`/`T`)：
  - `ysiwt` - 添加标签 (会提示输入标签名和属性)
  - `dst` - 删除标签
  - `cst` - 只修改标签类型 (保留属性)
  - `csT` - 修改整个标签 (包括属性)
- **函数调用** (`f`)：
  - `ysiwf` - 添加函数调用 (会提示输入函数名)
  - `dsf` - 删除函数调用，保留参数
  - `csf` - 修改函数名
- **自定义包围** (`i`)：
  - `yssi` - 自定义左右包围内容 (会分别提示输入左右内容)

#### 别名快捷键

- `b` → `)` (圆括号)
- `B` → `}` (花括号)
- `r` → `]` (方括号)
- `a` → `>` (尖括号)
- `q` → `"`, `'`, `` ` `` (任意引号)
- `s` → `}`, `]`, `)`, `>`, `"`, `'`, `` ` `` (任意包围符号)

#### 使用示例

```
旧文本                    命令         新文本
-------                   ----         ------
local str = H*ello        ysiw"        local str = "Hello"
require"nvim-surroun*d"   ysa")        require("nvim-surround")
*sample_text              ysiw}        {sample_text}
*sample_text              ysiw{        { sample_text }
local x = ({ *32 })       ds)          local x = { 32 }
'*some string'            cs'"         "some string"
"Nested '*quotes'"        dsq          "Nested quotes"
div cont*ents             ysstdiv      <div>div contents</div>
<div>d*iv contents</div>  dst          div contents
arg*s                     ysiwffunc    func(args)
f*unc_name(a, b, x)       dsf          a, b, x
```

### Blink.cmp 补全快捷键 (Default 预设)

- `<C-y>` - 确认选择
- `<C-Space>` - 打开菜单或切换文档
- `<C-n>/<C-p>` 或 `Up/Down` - 选择下一个/上一个项目
- `<C-e>` - 隐藏菜单
- `<C-k>` - 切换签名帮助

### Snacks 快捷键

#### 文件查找和导航

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

#### 文件浏览器操作 (在 explorer 中)

- `<CR>` - 进入目录/打开文件
- `<BS>` - 打开上级目录
- `h` - 关闭目录
- `l` - 打开文件
- `t` - 新 tab 打开文件
- `s` - 横向分屏打开
- `v` - 纵向分屏打开
- `a` - 添加文件/目录
- `d` - 删除文件/目录
- `r` - 重命名文件/目录
- `c` - 复制文件/目录
- `y` - 复制文件路径
- `p` - 粘贴文件/目录
- `u` - 更新文件树
- `P` - 预览文件
- `I` - 显示 .gitignore 的文件
- `H` - 显示隐藏文件
- `Z` - 收起所有子文件夹
- `]g` / `[g` - 跳转到下一个/上一个 git 修改的文件
- `]d` / `[d` - 跳转到下一个/上一个有诊断信息的文件
- `]w` / `[w` - 跳转到下一个/上一个有警告的文件
- `]e` / `[e` - 跳转到下一个/上一个有错误的文件

#### 其他功能

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

#### 查看源码和文档 (lspsaga)

- `gh` - 查看文档（自动聚焦到浮动窗口，可翻页查看）
- `gd` - 跳转到定义（垂直分屏打开）
- `gp` - 预览定义（浮动窗口，不跳转，可按 `t`/`s`/`v` 在新 tab/分屏中打开）
- `gr` - 查找所有引用和实现（浮动窗口列表）

#### 代码操作 (lspsaga)

- `<leader>rn` - 重命名变量/函数
- `<leader>ca` - 代码操作（Code Action）
- `<leader>o` - 切换文件大纲（显示所有符号）

#### 诊断导航 (lspsaga)

- `[d` - 跳转到上一个错误/警告
- `]d` - 跳转到下一个错误/警告

#### 诊断面板 (Trouble)

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
- 折叠方法: treesitter expr (级别 99，默认不折叠)
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
- GitHub Copilot: 集成到 blink.cmp，支持智能补全

### 透明度效果

- 主窗口背景透明 (Normal, NormalFloat)
- 符号列透明 (SignColumn)
- 非当前窗口透明 (NormalNC)
- 消息区域透明 (MsgArea)
- Telescope 界面透明 (TelescopeNormal, TelescopeBorder, TelescopePromptBorder)

## 🎨 特色功能

1. **一体化工具集**: 使用 snacks.nvim 整合了文件浏览器、选择器、通知系统、终端、调试工具、禅模式等
2. **现代化 LSP**: 完整的语言服务器支持，包含自动安装和 UI 美化
3. **代码格式化**: 支持多种语言的自动格式化 (保存时触发)
4. **透明界面**: 支持窗口透明效果，自动应用于颜色主题
5. **智能补全**: 基于 blink.cmp 的现代补全系统，支持 LSP、路径、片段、缓冲区和 GitHub Copilot
6. **自动括号补全**: blink.cmp 内置 auto_brackets 处理函数/方法补全后的括号，nvim-autopairs 处理手动输入的括号配对、回车格式化等，禁用在特定文件类型、宏和替换模式中
7. **彩虹括号**: 彩色括号高亮，使用 Nord 和 Catppuccin Frappé 配色方案
8. **快速内容选择**: 使用 `<CR>`/`<BS>`/`<TAB>` 进行渐进式代码选择，支持作用域检测
9. **符号包围编辑**: 使用 nvim-surround 快速操作包围符号
   - 支持添加、删除、修改各种括号、引号、HTML 标签
   - 智能空格处理 (开启/闭合符号行为不同)
   - 内置别名快捷键 (如 `b`→`)`，`q`→任意引号)
   - 支持函数调用和自定义包围符号
   - 可视模式、插入模式、普通模式全面支持
10. **行内诊断**: 在代码行内显示诊断信息，使用 ghost 预设样式，支持多行显示
11. **窗口选择器**: 快速切换和管理窗口 (版本 2.\*)
12. **快捷键提示**: 实时显示可用快捷键，使用 `<leader>?` 查看本地映射
13. **终端内图片显示**: 支持在终端中直接显示图片 (Ghostty 后端)
14. **草稿缓冲区**: 临时记事和快速计算功能
15. **文件浏览器增强**: 完整的文件操作支持 (添加、删除、重命名、复制、移动等)
16. **自动 LSP 安装**: Mason 自动安装和配置多种语言服务器
17. **光标位置记忆**: 重新打开文件时恢复上次的光标位置
18. **终端集成**: 智能终端管理，支持分割和快速切换
19. **Treesitter 折叠**: 基于语法树的智能代码折叠
20. **禅模式**: 无干扰的专注编辑模式
21. **GitHub Copilot**: AI 代码补全和建议 (懒加载)

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

- **自动完成**: 代码补全会自动触发，包含 LSP、片段、路径、缓冲区补全。Copilot 需要使用 `:Copilot` 命令手动启动
- **自动格式化**: 保存文件时自动格式化代码 (支持 Python, JS/TS, Lua, Shell)
- **自动诊断**: LSP 诊断信息实时显示，支持行内多行显示
- **文件类型检测**: 自动启用对应的语法高亮和 LSP
- **自动折叠**: 基于 Treesitter 的智能代码折叠
- **自动启动终端**: TermOpen 时自动进入插入模式

## 🔧 自定义配置

### 核心配置文件

- **`lua/config/options.lua`** - 通用设置 (显示、编辑、搜索等)
- **`lua/config/keymaps.lua`** - 快捷键映射
- **`lua/config/transparency.lua`** - 透明度效果设置
- **`lua/config/lazy.lua`** - 包管理器初始化 (Leader 键设置)

### 插件配置文件

- **`lua/plugins/ui.lua`** - UI 相关插件 (主题、状态栏、图标、Treesitter、彩虹括号等)
- **`lua/plugins/cmp.lua`** - 补全系统配置 (blink.cmp、Copilot、自动括号)
- **`lua/plugins/lsp.lua`** - LSP 和诊断配置 (lspconfig、Mason、Trouble、诊断显示)
- **`lua/plugins/snacks.lua`** - Snacks 工具集配置 (文件浏览器、选择器、通知、终端等)
- **`lua/plugins/tools.lua`** - 格式化和其他工具 (conform、wildfire、PEP8 缩进)

### 快速修改指南

1. **修改主题**: 编辑 `lua/plugins/ui.lua` 中的 nord.nvim 配置
2. **添加 LSP**: 在 `lua/plugins/lsp.lua` 的 ensure_installed 中添加服务器
3. **修改快捷键**: 编辑 `lua/config/keymaps.lua` 添加自定义映射
4. **调整格式化**: 修改 `lua/plugins/tools.lua` 中的 formatters_by_ft
5. **禁用透明度**: 注释掉 `init.lua` 中的 `require("config.transparency")` 加载
6. **配置 Copilot**: 在 `lua/plugins/cmp.lua` 中调整 Copilot 设置
7. **自定义文件浏览器**: 在 `lua/plugins/snacks.lua` 中修改 explorer 配置

此配置提供了一个完整、现代化的开发环境，具有出色的性能和可用性。所有组件都经过精心调试，确保兼容性和稳定性。

## 📝 语言支持

### LSP 服务器自动安装

配置自动安装以下 LSP 服务器：

- **clangd** - C/C++ 语言服务器
- **pyright** - Python 语言服务器 (已关闭类型检查，仅提供基础 LSP 功能)
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
- **JavaScript React (JSX)**: prettier
- **TypeScript React (TSX)**: prettier
- **HTML**: prettier
- **CSS/SCSS**: prettier
- **JSON**: prettier
- **Markdown**: prettier
- **YAML**: prettier
- **Lua**: stylua (2 空格缩进)
- **Shell**: shfmt (2 空格缩进)

所有格式化工具支持保存时自动格式化，超时时间 500ms，LSP 作为后备格式化选项。

#### 批量格式化项目文件

```bash
# 使用 prettier 格式化所有支持的文件
npx prettier --write .

# 格式化特定类型的文件
npx prettier --write "**/*.{js,jsx,ts,tsx,html,css,scss,json,md}"

# 检查哪些文件需要格式化（不修改文件）
npx prettier --check .
```

#### ESLint 代码检查

```bash
# 检查所有文件
npx eslint .

# 自动修复可修复的问题
npx eslint . --fix

# 只显示错误，不显示警告
npx eslint . --quiet
```

**提示**: 建议在项目根目录创建 `.eslintignore` 和 `.prettierignore` 文件来排除不需要检查的目录（如 `node_modules/`, `.next/`, `dist/`, `build/` 等）。
