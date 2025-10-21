return {
  -- neovim LSP client
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function(_, opts)
      for server, server_opts in pairs(opts.servers or {}) do
        vim.lsp.config(server, server_opts or {})
        vim.lsp.enable(server)
      end
    end,
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off", -- 关闭类型检查，只保留 LSP 功能
                diagnosticMode = "openFilesOnly", -- 只检查打开的文件
                useLibraryCodeForTypes = true, -- 从库代码推断类型
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        },
      },
    },
  },

  -- Mason: LSP server 管理
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "◌",
        },
      },
    },
  },

  -- Mason LSPConfig: 自动安装/启用 LSP
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "pyright",
        "gopls",
        "eslint",
        "lua_ls",
        "rust_analyzer",
        "marksman",
      },
      handlers = {
        function(server_name)
          local capabilities = require("blink.cmp").get_lsp_capabilities()
          require("lspconfig")[server_name].setup({ capabilities = capabilities })
        end,
        ["pyright"] = function()
          local capabilities = require("blink.cmp").get_lsp_capabilities()
          require("lspconfig").pyright.setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "off",  -- 关闭类型检查
                  diagnosticMode = "openFilesOnly",
                  useLibraryCodeForTypes = true,
                },
              },
            },
          })
        end,
        ["lua_ls"] = function()
          local capabilities = require("blink.cmp").get_lsp_capabilities()
          require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
              },
            },
          })
        end,
      },
    },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
  },

  -- Trouble: LSP/diagnostic 界面
  {
    "folke/trouble.nvim",
    opts = {
      height = 10,
      icons = true,
      auto_open = false,
      auto_close = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Info (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    },
  },

  -- Inline diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "ghost",
        options = {
          show_source = { enabled = true, if_many = true },
          throttle = 20,
          softwrap = 30,
          multilines = { enabled = true, always_show = true },
          show_all_diags_on_cursorline = false,
          enable_on_insert = false,
          overflow = { mode = "wrap" },
          virt_texts = { priority = 2048 },
        },
      })
    end,
  },

  -- LSP UI 美化
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lspsaga").setup({
        ui = { border = "rounded" },
        lightbulb = { enable = false },
        hover = {
          open_link = "gx",
          open_cmd = "!open", -- macOS 用 open，Linux 用 xdg-open
          max_width = 0.6,
          max_height = 0.8,
        },
      })
    end,
    keys = {
      -- 查看文档（替代原来的 K）- 自动聚焦到浮动窗口
      {
        "gh",
        function()
          vim.cmd("Lspsaga hover_doc ++keep")
          -- 延迟后查找并聚焦到 hover 窗口
          vim.defer_fn(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.bo[buf].filetype
              -- lspsaga hover 窗口的 filetype
              if ft == "hover" or ft == "markdown" then
                local win_config = vim.api.nvim_win_get_config(win)
                -- 确保是浮动窗口
                if win_config.relative ~= "" then
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end
          end, 50)
        end,
        desc = "Hover Documentation",
      },

      -- 跳转到定义（垂直分屏打开）
      {
        "gd",
        function()
          vim.cmd("vsplit")
          vim.cmd("Lspsaga goto_definition")
        end,
        desc = "Goto Definition (vsplit)",
      },

      -- 预览定义（不跳转，浮动窗口显示）
      { "gp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },

      -- 查找引用和实现
      { "gr", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder (References/Implementation)" },

      -- 重命名变量
      { "<leader>rn", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },

      -- 代码操作（Code Action）
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code Action", mode = { "n", "v" } },

      -- 诊断跳转
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Previous Diagnostic" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next Diagnostic" },

      -- 大纲（文件结构）
      { "<leader>o", "<cmd>Lspsaga outline<cr>", desc = "Toggle Outline" },
    },
  },

  -- Noice: cmdline, messages, popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
