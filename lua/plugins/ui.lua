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
    event = "VeryLazy",
    opts = {},
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
