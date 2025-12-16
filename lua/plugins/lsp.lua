return {
  -- neovim LSP client
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
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
      automatic_enable = false, -- 禁用自动启用，手动配置
    },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- 使用新版 API: vim.lsp.config + vim.lsp.enable
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Pyright 特殊配置
      vim.lsp.config.pyright = {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off",
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = false,
              autoSearchPaths = true,
              diagnosticSeverityOverrides = {
                reportGeneralTypeIssues = "none",
                reportOptionalMemberAccess = "none",
                reportOptionalSubscript = "none",
                reportOptionalCall = "none",
                reportUnboundVariable = "none",
                reportAttributeAccessIssue = "none",
              },
            },
          },
        },
      }

      -- Lua_ls 特殊配置
      vim.lsp.config.lua_ls = {
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
      }

      -- 其他服务器使用默认配置
      for _, server in ipairs(opts.ensure_installed) do
        if server ~= "pyright" and server ~= "lua_ls" then
          vim.lsp.config[server] = { capabilities = capabilities }
        end
      end

      -- 启用所有服务器
      for _, server in ipairs(opts.ensure_installed) do
        vim.lsp.enable(server)
      end
    end,
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
      -- 禁用 vim 默认的 virtual text 诊断（由 tiny-inline-diagnostic 接管）
      vim.diagnostic.config({
        virtual_text = false, -- 禁用默认的 virtual text
        signs = true, -- 保留左侧符号栏的诊断标记
        underline = true, -- 保留下划线
        update_in_insert = false, -- 不在插入模式更新诊断
        severity_sort = true, -- 按严重程度排序
      })

      require("tiny-inline-diagnostic").setup({
        preset = "ghost",
        options = {
          show_source = { enabled = true, if_many = true },
          throttle = 150, -- 增加延迟到 150ms，减少闪现频率
          softwrap = 30,
          multilines = { enabled = true, always_show = true },
          show_all_diags_on_cursorline = false,
          enable_on_insert = false,
          overflow = { mode = "wrap" },
          virt_texts = { priority = 2048 },
        },
      })

      -- 添加智能延迟：在输入时延迟显示诊断，减少闪现
      local last_insert_time = 0
      local insert_timeout = vim.fn.timer_start

      vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
          last_insert_time = vim.loop.hrtime()
        end,
      })

      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          local current_time = vim.loop.hrtime()
          local elapsed = (current_time - last_insert_time) / 1000000 -- 转换为毫秒

          -- 如果插入时间很短（快速输入），延迟更长时间才显示诊断
          if elapsed < 200 then
            vim.defer_fn(function()
              -- 触发诊断刷新
              vim.diagnostic.show()
            end, 300)
          end
        end,
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
        ui = {
          border = "rounded",
          winblend = 0, -- 不透明，避免透过窗口看到下面的代码造成混淆
        },
        lightbulb = { enable = false },
        hover = {
          open_link = "gx",
          open_cmd = "!open", -- macOS 用 open，Linux 用 xdg-open
          max_width = 0.4,
          max_height = 0.6,
          -- 窗口位置：优先下方，增加偏移避免覆盖当前行
          position = "auto",
          prefer_above = false, -- 优先下方
          offset_y = 1, -- 向下偏移 1 行，确保不覆盖当前行
          offset_x = 0, -- 水平不偏移
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
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
