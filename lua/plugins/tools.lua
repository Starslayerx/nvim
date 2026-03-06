return {
  -- Wildfire: 空格选择内容
  {
    "Starslayerx/wildfire.nvim",
    event = "VeryLazy",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      surrounds = {
        { "(", ")" },
        { "{", "}" },
        { "<", ">" },
        { "[", "]" },
        { '"', '"' },
        { "'", "'" },
        { "`", "`" },
      },
      keymaps = {
        init_selection = "<CR>", -- 回车开始/扩展选择
        node_incremental = "<CR>", -- 持续回车继续扩展
        node_decremental = "<BS>", -- 退格缩小选择
      },
      filetype_exclude = { "qf" }, -- 禁用的文件类型
    },
  },

  -- 快捷操作：选择后用符号包围
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  -- Formatter 代码格式化
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true })
        end,
        mode = "n",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "ruff" },
        javascript = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        javascriptreact = { "prettier", stop_after_first = true },
        typescriptreact = { "prettier", stop_after_first = true },
        html = { "djlint" },
        jinja = { "djlint" },
        htmldjango = { "djlint" },
        css = { "prettier", stop_after_first = true },
        scss = { "prettier", stop_after_first = true },
        json = { "prettier", stop_after_first = true },
        markdown = { "prettier", stop_after_first = true },
        yaml = { "yamlfmt" },
        lua = { "stylua" },
        sh = { "shfmt" },
        dockerfile = { "dprint" },
        sql = { "sql_formatter" },
        toml = { "taplo" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        -- 对 SQL 文件禁用自动格式化,避免语法错误导致保存失败
        if vim.bo[bufnr].filetype == "sql" then
          return nil
        end
        return { timeout_ms = 2000 }
      end,
      formatters = {
        ["clang-format"] = {
          prepend_args = {
            "--style={IndentWidth: 4, TabWidth: 4, UseTab: Never, AllowShortFunctionsOnASingleLine: Inline}",
          },
        },
        djlint = {
          prepend_args = {
            "--profile=jinja",
            "--indent=2",
          },
        },
        ruff = {
          append_args = {
            "--ignore", "F401", -- unused import
          },
        },
        shfmt = {
          append_args = { "-i", "2" },
        },
        stylua = {
          append_args = { "--indent-width", "2", "--indent-type", "Spaces" },
        },
        sql_formatter = {
          command = "sql-formatter",
          args = { "--language", "sql" },  -- 使用通用 SQL,最宽松的语法支持
        },
      },
    },
  },

  -- python pep8 风格缩进
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
    enabled = true,
  },
}
