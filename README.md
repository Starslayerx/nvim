# Neovim 配置

[English documentation](README-en.md)

一套以 `lazy.nvim` 为包管理器的模块化 Neovim 配置，重点覆盖 LSP、补全、调试、测试、Git、模板开发和快速检索。

> 当前配置在 Neovim `0.12.4` 上使用，并依赖新版 `vim.lsp.config()` / `vim.lsp.enable()` API。建议使用 Neovim `0.11+`。

## 配置概览

| 功能         | 实现                                                |
| ------------ | --------------------------------------------------- |
| 包管理       | lazy.nvim，自动检查插件更新，禁用插件 Git submodule |
| 主题与状态栏 | nord.nvim、lualine.nvim、透明背景                   |
| 补全         | blink.cmp、friendly-snippets、nvim-autopairs        |
| LSP          | Neovim 新版 LSP API、Mason、mason-lspconfig         |
| 诊断界面     | tiny-inline-diagnostic、Trouble、lspsaga            |
| 语法解析     | nvim-treesitter `main` 分支、rainbow-delimiters     |
| 搜索与文件   | fzf-lua、neo-tree                                   |
| Git          | gitsigns.nvim                                       |
| 格式化       | conform.nvim                                        |
| 调试         | nvim-dap、nvim-dap-view、nvim-dap-python            |
| 测试         | neotest、pytest、Go、Vitest 适配器                  |
| 任务管理     | 内置 Taskwarrior 面板与命令                         |
| 项目环境     | direnv.vim，打开或新建 buffer 时同步 `.envrc`       |

Leader 是空格，LocalLeader 是 `\`。

## 环境要求

必需或强烈建议安装：

- Neovim `0.11+`，当前测试版本为 `0.12.4`
- Git
- Nerd Font
- `fzf` 和 `ripgrep`
- 支持系统剪贴板的环境

可选工具：

- `ctags`：LSP/Tree-sitter 无法提供符号时作为 fzf-lua 回退
- `task`：启用 Taskwarrior 集成
- `direnv`：自动把项目 `.envrc` 环境同步进 Neovim
- GitHub Copilot 账号：使用可选 Copilot 命令和状态显示
- 各语言运行时，例如 Python、Node.js、Go、Rust、Java

Mason 会自动安装配置中的 LSP 服务器。Conform 使用的格式化器不会由本配置统一自动安装，需要通过 Mason、系统包管理器或语言包管理器确保它们位于 `PATH`。

## 安装

将仓库放到 Neovim 配置目录：

```bash
git clone <repository-url> ~/.config/nvim
nvim
```

首次启动时 lazy.nvim 会安装插件，Mason 和 Tree-sitter 会安装已配置的服务器与 parser。

常用维护命令：

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

## 目录结构

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

插件按职责拆分：UI、补全、LSP、搜索/文件、工具和调试分别维护，文件类型行为集中在 `lua/config/filetype.lua`。

## 核心选项

- 行号与相对行号、光标行、固定 sign column
- 全局软换行，`scrolloff=8`，100 列参考线
- 4 空格缩进，启用 `expandtab` 和 `autoindent`
- 禁用 `smartindent`、`cindent`；Python 保留 PEP8 插件的 `indentexpr`
- 默认 `foldmethod=indent`、`foldlevel=99`、不启用折叠
- 非 Markdown/Text 缓冲区由 Tree-sitter 接管折叠表达式
- 搜索区分大小写，启用搜索高亮和 `inccommand=split`
- 垂直分屏向右，水平分屏向下
- 禁用 backup、writebackup 和 swapfile
- 持久撤销保存在 `~/.config/nvim/tmp/undo/`
- 自动恢复上次打开文件时的光标位置
- 禁用自动续写注释
- `timeoutlen=500`、`ttimeoutlen=50`、`updatetime=300`
- `lazyredraw=false`，避免 Noice 等 UI 插件出现重绘问题
- Perl、Ruby provider 在启动时禁用

## 自定义快捷键

### 基础编辑

| 按键           | 功能                                             |
| -------------- | ------------------------------------------------ |
| `S`            | 保存当前文件                                     |
| `Q`            | 退出当前窗口                                     |
| `Y`            | 全选并复制到系统剪贴板                           |
| `<leader><CR>` | 清除搜索高亮                                     |
| `J` / `K`      | 向下/向上移动 5 行                               |
| `<` / `>`      | 普通模式缩进；可视模式缩进后保持选择             |
| `<leader>z`    | 将当前分屏放入独立 tab，切换全屏显示             |
| `G`            | 仅 Markdown：跳到目标行/文件末尾并执行 `zz` 居中 |

Markdown 的 `G` 是 buffer-local 映射。其他文件仍保留原生 `G` 行为；带计数的命令如 `20G` 也会跳转后居中。

### 插入模式与终端

| 按键              | 功能                                                 |
| ----------------- | ---------------------------------------------------- |
| `<C-a>`           | 跳到行首并保持插入模式                               |
| `<C-e>`           | 跳到行尾并保持插入模式；blink.cmp 的同名默认键已禁用 |
| `<C-h>` / `<C-l>` | 左移/右移一个字符                                    |
| `<C-j>` / `<C-k>` | 向下/向上翻一整屏                                    |
| `<C-w>t`          | 水平分屏打开终端                                     |
| `<C-w>T`          | 垂直分屏打开终端                                     |
| `<Esc>`           | 终端模式返回普通模式                                 |

### Tab、窗口与 Buffer

| 按键                        | 功能                         |
| --------------------------- | ---------------------------- |
| `tn`                        | 新建 tab                     |
| `tN`                        | 将当前 buffer 放入新 tab     |
| `th` / `tl`                 | 上一个/下一个 tab            |
| `tmh` / `tml`               | 向左/向右移动 tab            |
| `<leader>bn` / `<leader>bp` | 下一个/上一个 buffer         |
| `<leader>bd`                | 删除当前 buffer              |
| `<C-w>h/j/k/l`              | 使用 Neovim 原生方式切换窗口 |

### fzf-lua 与 Neo-tree

| 按键                        | 功能                                    |
| --------------------------- | --------------------------------------- |
| `<leader><space>`           | fzf-lua 全局检索                        |
| `<leader>bb` / `<leader>fb` | Buffer 列表                             |
| `<leader>/`                 | Live grep                               |
| `<leader>:`                 | 命令历史                                |
| `<leader>ff`                | 查找文件                                |
| `<leader>fg`                | 查找 Git 文件                           |
| `<leader>fc`                | 查找 Neovim 配置文件                    |
| `<leader>fr`                | 最近文件                                |
| `<leader>fs`                | 当前文档符号：LSP → Tree-sitter → ctags |
| `<leader>fS`                | 工作区符号：LSP → ctags                 |
| `<leader>ft`                | Tree-sitter 符号                        |
| `<leader>fT`                | 项目 tags                               |
| `<leader>fR`                | 恢复上一次 fzf-lua picker               |
| `<leader>e`                 | 在左侧切换 Neo-tree，并 reveal 当前文件 |

Neo-tree 内部：

| 按键         | 功能                           |
| ------------ | ------------------------------ |
| `<CR>` / `l` | 打开文件或展开目录             |
| `h`          | 收起目录                       |
| `o`          | 在新 tab 打开                  |
| `s` / `S`    | 垂直/水平分屏打开              |
| `P`          | 切换浮动预览                   |
| `H`          | 切换隐藏文件和 gitignored 文件 |

`t` 在 Neo-tree 中明确取消映射，避免影响其他 tab 导航习惯。

### LSP 与诊断

| 按键                        | 功能                                |
| --------------------------- | ----------------------------------- |
| `<leader>lh`                | Lspsaga hover，并自动聚焦浮窗       |
| `<leader>ld`                | 在当前窗口跳转到定义                |
| `<leader>lv`                | 垂直分屏后跳转到定义                |
| `<leader>ls`                | 水平分屏后跳转到定义                |
| `<leader>lf`                | 浮窗预览定义                        |
| `<leader>lr`                | 查找引用和实现                      |
| `<leader>rn`                | 重命名                              |
| `<leader>ca`                | Code Action，支持普通/可视模式      |
| `[d` / `]d`                 | 上一个/下一个诊断                   |
| `<leader>o`                 | 切换 Lspsaga Outline                |
| `<leader>xl`                | 显示当前行诊断浮窗                  |
| `<leader>xd`                | 显示当前 buffer 的 LSP 诊断调试信息 |
| `<leader>xx`                | Trouble 工作区诊断                  |
| `<leader>xX`                | Trouble 当前 buffer 诊断            |
| `<leader>cs`                | Trouble 符号列表                    |
| `<leader>cl`                | Trouble LSP 信息                    |
| `<leader>xL` / `<leader>xQ` | Location list / Quickfix list       |

`K` 被用于向上移动 5 行，因此 hover 使用 `<leader>lh`。

### Git

| 按键                        | 功能                                |
| --------------------------- | ----------------------------------- |
| `<leader>gj` / `<leader>gk` | 下一个/上一个 hunk                  |
| `<leader>gs` / `<leader>gr` | Stage/Reset 当前 hunk，支持可视范围 |
| `<leader>gS` / `<leader>gR` | Stage/Reset 当前 buffer             |
| `<leader>gp` / `<leader>gi` | 浮窗/行内预览 hunk                  |
| `<leader>gb`                | 完整 blame 当前行                   |
| `<leader>gd` / `<leader>gD` | 与 index / `~` 比较                 |
| `<leader>gq`                | 将 hunks 写入 quickfix              |
| `<leader>gl`                | 切换当前行 blame                    |
| `<leader>gw`                | 切换 word diff                      |
| `ih`                        | Hunk 文本对象                       |

### 测试

| 按键                        | 功能                    |
| --------------------------- | ----------------------- |
| `<leader>tn`                | 运行最近测试            |
| `<leader>tf`                | 运行当前文件            |
| `<leader>ta`                | 运行当前项目            |
| `<leader>td`                | 使用 DAP 调试最近测试   |
| `<leader>tm` / `<leader>tc` | 调试 Python 测试方法/类 |
| `<leader>ts`                | 切换测试摘要            |
| `<leader>to`                | 打开最近输出            |
| `<leader>tO`                | 切换输出面板            |
| `<leader>tw`                | Watch 当前文件          |
| `<leader>tS`                | 停止测试                |

### 调试

| 按键                                       | 功能                                 |
| ------------------------------------------ | ------------------------------------ |
| `<leader>ds`                               | 启动调试                             |
| `<leader>dc`                               | 继续；会话正在运行时显示会话操作菜单 |
| `<leader>dn` / `<leader>di` / `<leader>do` | Step over / into / out               |
| `<leader>db`                               | 切换持久断点                         |
| `<leader>dB`                               | 条件断点                             |
| `<leader>dl`                               | Log point                            |
| `<leader>du`                               | 切换 DAP View                        |
| `<leader>de`                               | 求值光标处或可视选择表达式           |
| `<leader>dp`                               | 打开 REPL                            |
| `<leader>dR`                               | 重跑上一次配置                       |
| `<leader>dq`                               | 终止调试                             |

断点会跨 Neovim 重启保存。DAP View 位于右侧，占窗口宽度的 50%，并在调试生命周期中自动切换。行内调试变量插件当前明确禁用。

### Taskwarrior

| 按键/命令                      | 功能           |
| ------------------------------ | -------------- |
| `<leader>an` / `:TaskNext`     | 显示 next 任务 |
| `<leader>aa` / `:TaskAll`      | 显示全部任务   |
| `<leader>ap` / `:TaskProjects` | 显示项目       |
| `<leader>aA` / `:TaskAdd`      | 输入并添加任务 |

Taskwarrior 面板中：`r` 刷新、`<CR>` 查看详情、`x` 完成任务、`q` 关闭。

### 其他编辑工具

| 按键            | 功能                                          |
| --------------- | --------------------------------------------- |
| `<leader>F`     | 普通模式格式化 buffer；可视模式格式化选择范围 |
| `<leader>j`     | TreeSJ 拆分/合并当前语法节点                  |
| `<CR>` / `<BS>` | Wildfire 扩展/缩小括号或 Tree-sitter 节点选择 |
| `]r` / `[r`     | 下一个/上一个引用高亮位置                     |
| `<leader>ch`    | 切换当前 buffer 的引用高亮                    |
| `<leader>?`     | 显示当前 buffer 的本地快捷键                  |

nvim-surround 使用默认映射，例如 `ysiw"`、`ds"`、`cs"'`、可视模式 `S{char}`。

其他已启用集成：direnv.vim 自动同步项目环境，nvim-colorizer 显示颜色值色块，nvim-window-picker 提供窗口选择能力但没有单独配置全局快捷键。

## LSP 与模板支持

Mason 自动安装并启用：

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

特殊配置：

- Pyright 使用 `diagnosticMode=workspace`，关闭类型检查，但保留缺失 import/module source 警告。
- Pyright 会从项目根目录向上最多查找 3 层的 `.venv`、`venv` 或 `env`，并使用其中的 `bin/python`。
- Clangd 在项目没有真实编译数据库/flags 时使用 `-std=c23` fallback，并只记录错误级别日志。
- Lua LS 识别 Neovim runtime 与 `vim` 全局。
- Django 模板使用 HTML LS + Emmet；禁用会把 Django 动态上下文误报为未定义变量的 `jinja_lsp`。
- HTML、Jinja 与 Emmet 支持 `htmldjango`；HTML LSP 加载本地 HTMX custom data。
- CSS LS 只服务 CSS/SCSS/Less，避免在 Jinja 模板里提供错误的 CSS 属性补全。
- `.jinja`、`.jinja2`、`.j2` 自动识别为 `htmldjango`；包含 Jinja 标记或位于 `templates/` 下的 HTML 也会自动切换。
- Jinja 行中输入 `%` 或 `#` 可将已有的 `{}` 扩展为 `{%  %}` / `{#  #}`。
- nvim-ts-context-commentstring 在 HTML 与 Jinja 区域之间动态选择正确注释格式。

## 补全与自动配对

blink.cmp 默认源：

- LSP
- 路径
- friendly-snippets
- 当前 buffer

主要按键：

- `<C-y>` 接受补全
- `<C-Space>` 打开菜单或切换文档
- `<C-n>` / `<C-p>` 选择下一项/上一项
- `<C-e>` 已从 blink.cmp 中取消，保留给自定义行尾跳转

blink.cmp 的 `auto_brackets` 会为函数/方法补全添加 `()`；nvim-autopairs 负责手动括号、回车和退格行为。Markdown 中的括号和引号只会在已识别的代码块语言内自动配对。

Copilot provider、`:Copilot` 命令和 lualine 状态组件仍然保留，但 Copilot 不在 blink.cmp 的默认 source 列表中，suggestion 与 panel 也处于关闭状态。

## 格式化

格式化通过 `<leader>F` 手动触发；当前配置没有启用保存时自动格式化。外部 formatter 不可用时允许回退到 LSP formatting。

| 文件类型                            | Formatter                                 |
| ----------------------------------- | ----------------------------------------- |
| C / C++                             | clang-format，4 空格，不使用 Tab          |
| Python                              | ruff_fix → ruff_format，fix 阶段忽略 F401 |
| JavaScript / TypeScript / JSX / TSX | prettier                                  |
| HTML / Jinja / htmldjango           | djlint，Jinja profile，2 空格             |
| CSS / SCSS                          | prettier                                  |
| JSON / Markdown                     | prettier                                  |
| YAML                                | yamlfmt                                   |
| Lua                                 | stylua，2 空格                            |
| Shell                               | shfmt，2 空格                             |
| Dockerfile                          | dprint                                    |
| SQL                                 | sql-formatter                             |
| TOML                                | taplo                                     |

## Tree-sitter 与界面

自动安装 parser：Lua、Vim、Vimdoc、Python、JavaScript、TypeScript、HTML、htmldjango、CSS、JSON、Markdown、Bash、C、C++、Rust、Go、Java。

Tree-sitter 在所有可识别文件类型启动；Markdown、Text 明确排除 Tree-sitter folding。Python 会额外恢复 Vim syntax，供 PEP8 indent 的 `synID()` 使用。

界面组件：

- Nord 主题，斜体注释、加粗 lualine section
- 透明 Normal、SignColumn、NormalNC、MsgArea
- mini.indentscope 静态缩进范围线
- rainbow-delimiters 的 Nord/Catppuccin Frappé 配色
- tiny-inline-diagnostic ghost preset，80ms throttle，支持多行和软换行
- Noice 美化命令行和消息，隐藏常见文件写入消息
- Which-key 使用 modern preset、140ms 延迟，并显示动态开关状态图标
- Lspsaga hover 偏向光标下方；Outline 禁用自动 preview，并包含多 tab/空内容稳定性补丁
- nvim-colorizer 为颜色文本显示实时色块；nvim-window-picker 作为窗口选择组件初始化

## Python 调试

Mason DAP 自动准备 debugpy，nvim-dap-python 使用：

```text
~/.local/share/nvim/mason/packages/debugpy/venv/bin/python
```

Python 配置包括：

- 当前文件
- 当前文件并输入参数
- 运行 Python module
- Attach 到 host/port，默认 `127.0.0.1:5678`
- 使用 `doctest` 检查当前文件

执行程序使用 integrated terminal。DAP 在跳转到停止位置前会避开 `winfixbuf` 窗口，并在关键调试事件后主动重绘。

## 常见问题

### Markdown 中按 `G` 后光标贴底

Markdown buffer 已把 `G` 映射为 `Gzz`。它会先执行原生跳转，再将目标行居中。使用下面命令确认映射来源：

```vim
:verbose nmap G
```

### LSP 没有启动

```vim
:LspInfo
:Mason
:checkhealth lsp
```

本配置使用新版 API，不要改回 `require("lspconfig").SERVER.setup()`。

### Pyright 找不到虚拟环境

确认项目根目录或向上 3 层内存在 `.venv/bin/python`、`venv/bin/python` 或 `env/bin/python`。可用 `<leader>xd` 查看当前 Pyright root 和诊断状态。

### 格式化无反应

```vim
:ConformInfo
:lua vim.print(require("conform").list_formatters())
```

确认对应 formatter 已安装并位于 `PATH`。SQL 只会在手动执行 `<leader>F` 时格式化。

### 补全后没有括号

确认 blink.cmp 的 `auto_brackets` 仍启用，并且 `kind_resolution.blocked_filetypes` 与 `semantic_token_resolution.blocked_filetypes` 都为空表。手动输入括号由 nvim-autopairs 处理。

### DAP 无法启动 Python

```vim
:DapInstall
```

并确认 Mason 的 debugpy Python 路径存在。调试面板可用 `<leader>du` 手动切换。

### Noice 命令行异常

Noice 位于 `lua/plugins/lsp.lua`。临时禁用其 plugin spec 可用于确认是否为消息 UI 冲突；保持 `lazyredraw=false`。

## 自定义入口

- 通用选项：`lua/config/options.lua`
- 全局按键：`lua/config/keymaps.lua`
- 文件类型行为：`lua/config/filetype.lua`
- Taskwarrior：`lua/config/taskwarrior.lua`
- UI：`lua/plugins/ui.lua`
- 补全：`lua/plugins/cmp.lua`
- LSP 与诊断：`lua/plugins/lsp.lua`
- 搜索与文件树：`lua/plugins/snacks.lua`
- Git、测试、格式化和编辑工具：`lua/plugins/tools.lua`
- 调试：`lua/plugins/debug.lua`
