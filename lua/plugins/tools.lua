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
        python = { "ruff" },
        javascript = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        lua = { "stylua" },
        sh = { "shfmt" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = { timeout_ms = 500 },
      formatters = {
        ruff = {
          append_args = { "--ignore", "F401" }, -- unused import
        },
        shfmt = {
          append_args = { "-i", "2" },
        },
        stylua = {
          append_args = { "--indent-width", "2", "--indent-type", "Spaces" },
        },
      },
    },
  },

  -- python pep8 风格缩进
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },
}
