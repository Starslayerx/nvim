return {
  -- nord 主题
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = {},
        functions = {},
        variables = {},

        -- To customize lualine/bufferline
        bufferline = {
          current = {},
          modified = { italic = true },
        },

        lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
      },
    },
    config = function()
      require("nord").setup({})
      vim.cmd.colorscheme("nord")
    end,
  },

  -- icons 图标支持
  { "nvim-mini/mini.nvim", version = "*" },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- 展示 key mapping
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 140,
      preset = "modern",
      show_help = false,
      show_keys = false,
      sort = { "manual", "local", "order", "group", "alphanum", "mod" },
      icons = {
        mappings = true,
      },
    },
    config = function(_, opts)
      local wk = require("which-key")

      local function outline_is_open()
        local ok, outline = pcall(require, "lspsaga.symbol.outline")
        return ok and outline.winid and vim.api.nvim_win_is_valid(outline.winid) or false
      end

      local function current_line_breakpoint()
        local ok, breakpoints = pcall(require, "dap.breakpoints")
        if not ok then
          return nil
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local buf_breakpoints = breakpoints.get(bufnr)[bufnr] or {}

        for _, bp in ipairs(buf_breakpoints) do
          if bp.line == line then
            return bp
          end
        end

        return nil
      end

      local function dap_view_is_open()
        local ok, state = pcall(require, "dap-view.state")
        return ok and state.winnr and vim.api.nvim_win_is_valid(state.winnr) or false
      end

      wk.setup(opts)
      wk.add({
        { "<leader>b", group = "Buffer", icon = { icon = "󰈚", color = "azure" } },
        { "<leader>c", group = "Code", icon = { icon = "", color = "blue" } },
        { "<leader>d", group = "Debug", icon = { icon = "", color = "red" } },
        { "<leader>f", group = "Find", icon = { icon = "", color = "green" } },
        { "<leader>g", group = "Git", icon = { icon = "󰊢", color = "orange" } },
        { "<leader>t", group = "Test", icon = { icon = "󰙨", color = "purple" } },
        { "<leader>x", group = "Diagnostics", icon = { icon = "", color = "yellow" } },
        {
          "<leader>db",
          mode = "n",
          icon = function()
            local bp = current_line_breakpoint()
            if not bp then
              return { icon = "󰄱 ", color = "yellow" }
            end
            if bp.logMessage then
              return { icon = "◉ ", color = "yellow" }
            end
            if bp.condition or bp.hitCondition then
              return { icon = "◆ ", color = "orange" }
            end
            return { icon = "● ", color = "red" }
          end,
          desc = function()
            local bp = current_line_breakpoint()
            return bp and "Remove Breakpoint" or "Set Breakpoint"
          end,
        },
        {
          "<leader>du",
          mode = "n",
          icon = function()
            local enabled = dap_view_is_open()
            return {
              icon = enabled and " " or " ",
              color = enabled and "green" or "yellow",
            }
          end,
          desc = function()
            return dap_view_is_open() and "Close Debug View" or "Open Debug View"
          end,
        },
        {
          "<leader>o",
          mode = "n",
          icon = function()
            local enabled = outline_is_open()
            return {
              icon = enabled and " " or " ",
              color = enabled and "green" or "yellow",
            }
          end,
          desc = function()
            return outline_is_open() and "Close Outline" or "Open Outline"
          end,
        },
      })
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- window picker: 快速切换窗口
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },

  -- nvim-treesitter 语法高亮 (新版 main 分支)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- 文档明确说明不支持 lazy-loading
    branch = "main",
    build = ":TSUpdate",
    config = function()
      -- 新版 main 分支的 setup（可选，使用默认值也可以）
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- 安装需要的 parsers
      require("nvim-treesitter").install({
        "lua",
        "vim",
        "vimdoc",
        "python",
        "javascript",
        "typescript",
        "html",
        "htmldjango",
        "css",
        "json",
        "markdown",
        "bash",
        "c",
        "cpp",
        "rust",
        "go",
        "java",
      })

      -- 启用语法高亮（新版需要手动启用）
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          if vim.bo.filetype ~= "" then
            pcall(vim.treesitter.start)
            -- 对 Python 重新启用 vim 语法引擎，让 pep8-indent 的 synID() 正常工作
            -- 用 vim.schedule 延迟到 treesitter.start() 完全处理完之后
            if vim.bo.filetype == "python" then
              vim.schedule(function()
                vim.bo.syntax = "python"
              end)
            end
          end
        end,
      })

      -- 启用 treesitter 折叠
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          -- 排除可能导致索引越界的文件类型
          local excluded = { "markdown", "text", "" }
          if vim.tbl_contains(excluded, vim.bo.filetype) then
            return
          end

          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldenable = false -- 默认不折叠
        end,
      })
    end,
  },

  {
    -- 彩虹括号
    "HiPhish/rainbow-delimiters.nvim",
    submodules = false, -- 禁用子模块（测试依赖，用户不需要）
    config = function()
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = "rainbow-delimiters.strategy.global",
          vim = "rainbow-delimiters.strategy.local",
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = { -- 自定义括号颜色 & 渲染顺序
          "nord8",
          "FrappeBlue",
          "FrappeLavender",
          "FrappePink",
          "FrappeYellow",
          "FrappeMaroon",
          "FrappePeach",
        },
      })
      -- 定义括号颜色
      local hl = vim.api.nvim_set_hl
      -- nord color palettes
      -- Polar Night
      hl(0, "nord0", { fg = "#2E3440" })
      hl(0, "nord1", { fg = "#3B4252" })
      hl(0, "nord2", { fg = "#434C5E" })
      hl(0, "nord3", { fg = "#4C566A" })
      -- Snow-Storm
      hl(0, "nord4", { fg = "#D8DEE9" })
      hl(0, "nord5", { fg = "#E5E9F0" })
      hl(0, "nord6", { fg = "#ECEFF4" })
      -- Frost
      hl(0, "nord7", { fg = "#8FBCBB" })
      hl(0, "nord8", { fg = "#88C0D0" })
      hl(0, "nord9", { fg = "#81A1C1" })
      hl(0, "nord10", { fg = "#5E81AC" })
      -- Aurora
      hl(0, "nord11", { fg = "#BF616A" })
      hl(0, "nord12", { fg = "#D08770" })
      hl(0, "nord13", { fg = "#EBCB8B" })
      hl(0, "nord14", { fg = "#A3BE8C" })
      hl(0, "nord15", { fg = "#B48EAD" })

      -- Catppuccin Frappé
      hl(0, "FrappeRosewater", { fg = "#f2d5cf" })
      hl(0, "FrappeFlamingo", { fg = "#eebebe" })
      hl(0, "FrappePink", { fg = "#f4b8e4" })
      hl(0, "FrappeMauve", { fg = "#ca9ee6" })
      hl(0, "FrappeRed", { fg = "#e78284" })
      hl(0, "FrappeMaroon", { fg = "#ea999c" })
      hl(0, "FrappePeach", { fg = "#ef9f76" })
      hl(0, "FrappeYellow", { fg = "#e5c890" })
      hl(0, "FrappeGreen", { fg = "#a6d189" })
      hl(0, "FrappeTeal", { fg = "#81c8be" })
      hl(0, "FrappeSky", { fg = "#99d1db" })
      hl(0, "FrappeSapphire", { fg = "#85c1dc" })
      hl(0, "FrappeBlue", { fg = "#8caaee" })
      hl(0, "FrappeLavender", { fg = "#babbf1" })
      hl(0, "FrappeText", { fg = "#c6d0f5" })
    end,
    opts = {},
  },

  -- 展示色块
  {
    "Starslayerx/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "gbprod/nord.nvim" },
    opts = {
      options = {
        icons_enabled = true,
        theme = "nord",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            sources = { "nvim_lsp" },
            symbols = { error = " ", warn = " ", info = " ", hint = "󰊠 " },
            -- symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_c = { "filename" },
        lualine_x = { "copilot", "encoding", "fileformat", "filetype" }, -- I added copilot here
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
      spinners = {
        "✶",
        "✸",
        "✹",
        "✺",
        "✹",
        "✷",
      },
    },
  },

  -- copilot with lualine
  {
    "AndreM222/copilot-lualine",
  },
}
