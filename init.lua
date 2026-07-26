-- 禁用 Perl 提供商
vim.g.loaded_perl_provider = 0

-- 禁用 Ruby 提供商
vim.g.loaded_ruby_provider = 0

-- 当前配置没有 Python remote plugin；禁用损坏的自动探测 host。
-- 这不影响 Pyright、DAP、neotest 或 Python 格式化工具。
vim.g.loaded_python3_provider = 0

-- Suppress file read/write messages before plugins start rendering UI.
vim.opt.shortmess = "filnxxtToOF"

-- lazy.nvim
require("config.lazy")

-- 非插件, 自定义配置
require("config.transparency")
require("config.keymaps")
require("config.options")
require("config.filetype")
require("config.taskwarrior")
