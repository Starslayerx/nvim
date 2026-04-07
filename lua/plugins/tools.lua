return {
  -- Git hunk workflow
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      current_line_blame = false,
      current_line_blame_opts = {
        delay = 300,
      },
      preview_config = {
        border = "rounded",
      },
      watch_gitdir = {
        follow_files = true,
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        map("n", "<leader>gj", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
            return
          end
          vim.schedule(gitsigns.next_hunk)
        end, "Next Hunk")

        map("n", "<leader>gk", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
            return
          end
          vim.schedule(gitsigns.prev_hunk)
        end, "Prev Hunk")

        map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Hunk")
        map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
        map("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Hunk")
        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk")
        map("n", "<leader>gS", gitsigns.stage_buffer, "Stage Buffer")
        map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
        map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Hunk")
        map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>gd", gitsigns.diffthis, "Diff This")
        map("n", "<leader>gD", function()
          gitsigns.diffthis("~")
        end, "Diff This ~")
        map("n", "<leader>gq", gitsigns.setqflist, "Hunks To Quickfix")
        map("n", "<leader>gl", gitsigns.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>gw", gitsigns.toggle_word_diff, "Toggle Word Diff")
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Hunk")
      end,
    },
  },

  -- Current word/reference highlighting
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local function set_illuminate_highlights()
        vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#53586d" })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#4f565f" })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#5c5150" })
      end

      set_illuminate_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("IlluminateHighlights", { clear = true }),
        callback = set_illuminate_highlights,
      })

      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 120,
        under_cursor = true,
        min_count_to_highlight = 2,
        large_file_cutoff = 5000,
        disable_keymaps = true,
        modes_denylist = { "i" },
        filetypes_denylist = {
          "alpha",
          "checkhealth",
          "dap-repl",
          "dap-view",
          "dap-view-term",
          "fugitive",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "noice",
          "notify",
          "qf",
          "TelescopePrompt",
          "trouble",
        },
      })

      vim.keymap.set("n", "]r", function()
        require("illuminate").goto_next_reference(false)
      end, { silent = true, nowait = true, desc = "Next Reference" })

      vim.keymap.set("n", "[r", function()
        require("illuminate").goto_prev_reference(false)
      end, { silent = true, nowait = true, desc = "Prev Reference" })

      vim.keymap.set("n", "<leader>ch", function()
        require("illuminate").toggle_buf()
      end, { silent = true, desc = "Toggle References" })
    end,
  },

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

  -- Test runner
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "marilari88/neotest-vitest",
      "mfussenegger/nvim-dap",
    },
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run Project",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Watch File",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = {
              justMyCode = false,
            },
            runner = "pytest",
          }),
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
          }),
          require("neotest-vitest")({
            filter_dir = function(name)
              return name ~= "node_modules"
            end,
          }),
        },
        discovery = {
          enabled = true,
        },
        diagnostic = {
          enabled = true,
        },
        floating = {
          border = "rounded",
          max_height = 0.8,
          max_width = 0.8,
        },
        output = {
          enabled = true,
          open_on_run = false,
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 12",
        },
        quickfix = {
          enabled = false,
        },
        summary = {
          animated = false,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
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
            "--ignore",
            "F401", -- unused import
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
          args = { "--language", "sql" }, -- 使用通用 SQL,最宽松的语法支持
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
