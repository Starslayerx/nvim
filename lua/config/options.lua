local opt = vim.opt
local g = vim.g

-- 全局设置
g.mapleader = " "

-- 编码和系统
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = "utf-8,ucs-bom"
opt.autochdir = false

-- 显示设置
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = true
opt.scrolloff = 8
opt.colorcolumn = "100"

-- 搜索设置
opt.ignorecase = false -- 搜索区分大小写 (对应 noignorecase)
opt.smartcase = false -- 不用智能大小写 (对应 nosmartcase)
opt.inccommand = "split"
opt.hlsearch = true

-- 缩进设置
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = false -- 禁用智能缩进 (对应 nosmartindent)
opt.cindent = false -- 禁用 c 语言缩进 (对应 nocindent)
opt.indentexpr = ""

-- 折叠设置
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldenable = true

-- 分割窗口
opt.splitright = true
opt.splitbelow = true

-- 显示相关
opt.showmode = false
opt.showcmd = true
opt.wildmenu = true
opt.list = true
opt.listchars = { tab = "  ", trail = "▫" }

-- 性能优化
opt.ttyfast = true
opt.updatetime = 300
opt.ttimeoutlen = 50
opt.timeoutlen = 300  -- 减少映射序列等待时间到300ms
opt.timeout = true

-- 避免导致 UI 插件渲染异常
opt.lazyredraw = false

-- 文件备份和历史
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.hidden = true

-- 设置备份和撤销目录
local config_dir = vim.fn.expand("$HOME/.config/nvim")
vim.fn.system("mkdir -p " .. config_dir .. "/tmp/backup")
vim.fn.system("mkdir -p " .. config_dir .. "/tmp/undo")

opt.backupdir = config_dir .. "/tmp/backup,."
opt.directory = config_dir .. "/tmp/backup,."
if vim.fn.has("persistent_undo") == 1 then
  opt.undofile = true
  opt.undodir = config_dir .. "/tmp/undo,."
end

-- 补全设置
opt.completeopt = { "longest", "noinsert", "menuone", "noselect", "preview" }

-- 其他设置
opt.virtualedit = "block"
-- 确保搜索计数显示，移除可能抑制显示的选项
opt.shortmess = "filnxxtToO"  -- 移除了 "c"，保留搜索计数显示
opt.viewoptions = "cursor,folds,slash,unix"

-- 终端相关
opt.termguicolors = true
g.terminal_emulator = "nvim"

-- 禁用自动注释，并重置缩进表达式
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("r")
    vim.opt_local.formatoptions:remove("o")

    -- Python 文件保留 indentexpr 让 pep8-indent 插件工作，其他文件清空避免过度缩进
    if vim.bo.filetype ~= "python" then
      vim.opt_local.indentexpr = ""
    end
  end,
})

-- 记住光标位置
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

-- 终端设置
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  command = "startinsert",
})

-- 设置语法高亮
vim.cmd("syntax on")

-- 正则表达式引擎
vim.opt.re = 0

-- 诊断显示配置（全局默认）
vim.diagnostic.config({
  virtual_text = true, -- 启用默认的 virtual text（当 tiny-inline-diagnostic 禁用时）
  signs = true,
  underline = true,
  update_in_insert = false, -- 不在插入模式更新诊断
  severity_sort = true,
})
