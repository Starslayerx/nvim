local opt = vim.opt

-- 编码和系统
opt.fileencoding = "utf-8"
opt.fileencodings = "ucs-bom,utf-8"
opt.clipboard = "unnamedplus"
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
opt.foldenable = false

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
-- 300ms 对 <leader> 组合偏紧，which-key 默认延迟 200ms 时几乎没有继续按键的余量。
opt.timeoutlen = 500
opt.timeout = true

-- 避免导致 UI 插件渲染异常（noice.nvim 需要 lazyredraw = false）
opt.lazyredraw = false

-- 文件备份和历史
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.hidden = true

-- 设置备份和撤销目录
local config_dir = vim.fn.expand("$HOME/.config/nvim")
vim.fn.mkdir(config_dir .. "/tmp/backup", "p")
vim.fn.mkdir(config_dir .. "/tmp/undo", "p")

opt.backupdir = config_dir .. "/tmp/backup,."
opt.directory = config_dir .. "/tmp/backup,."
if vim.fn.has("persistent_undo") == 1 then
  opt.undofile = true
  opt.undodir = config_dir .. "/tmp/undo,."
end

-- 补全设置
opt.completeopt = { "menuone", "noselect" }

-- 其他设置
opt.virtualedit = "block"
-- 确保搜索计数显示，移除可能抑制显示的选项
-- F: 隐藏文件读写消息 (避免显示 "xxx lines written" 等)
opt.shortmess = "filnxtToOF" -- 移除了 "c"，保留搜索计数显示，添加 "F" 隐藏文件消息
opt.viewoptions = "cursor,folds,slash,unix"

-- Neovim 在 buffer 末尾不会继续应用 scrolloff，会把光标压到窗口底边。
-- 只为普通编辑 buffer 补回底部余量；Neo-tree 等特殊窗口自行管理视图，
-- 避免这里的 CursorMoved 回调与插件的光标/滚动位置恢复互相干扰。
-- 软换行/折叠窗口使用 zz，避免按逻辑行调整 topline 时跨过多行屏幕内容。
local function keep_cursor_above_bottom_edge()
  local winid = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(winid).relative ~= "" then
    return
  end

  local bufnr = vim.api.nvim_win_get_buf(winid)
  if vim.bo[bufnr].buftype ~= "" then
    return
  end

  local height = vim.api.nvim_win_get_height(winid)
  local scrolloff = math.min(vim.wo[winid].scrolloff, math.floor((height - 1) / 2))
  if scrolloff < 1 then
    return
  end

  local overflow = vim.fn.winline() - (height - scrolloff)
  if overflow < 1 then
    return
  end

  if vim.wo[winid].wrap or vim.wo[winid].foldenable then
    vim.cmd("normal! zz")
    return
  end

  local view = vim.fn.winsaveview()
  view.topline = view.topline + overflow
  vim.fn.winrestview(view)
end

vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("KeepCursorAboveBottomEdge", { clear = true }),
  callback = keep_cursor_above_bottom_edge,
  desc = "Keep scrolloff visible at the end of editable buffers",
})

-- 终端相关
opt.termguicolors = true

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

-- DAP 的终端缓冲区打开后不要停在插入模式，避免 `<leader>ds` 后看起来像被“带进”插入。
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-view-term",
  callback = function()
    vim.cmd("stopinsert")
  end,
})

-- 设置语法高亮
vim.cmd("syntax on")

-- 正则表达式引擎
vim.opt.re = 0

-- 诊断显示配置（全局默认）
vim.diagnostic.config({
  virtual_text = false, -- 由 tiny-inline-diagnostic 接管行内诊断显示
  signs = true,
  underline = true,
  update_in_insert = false, -- 不在插入模式更新诊断
  severity_sort = true,
})
