local htmx_custom_data_path = vim.fn.stdpath("config") .. "/data/htmx.html-data.json"

local function html_custom_data_content(_, uri)
  local requested_path = htmx_custom_data_path
  if type(uri) == "string" then
    requested_path = vim.uri_to_fname(uri)
  end
  if requested_path ~= htmx_custom_data_path then
    return nil
  end

  local lines = vim.fn.readfile(requested_path)
  return table.concat(lines, "\n")
end

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
        "ts_ls",
        "lua_ls",
        "rust_analyzer",
        "marksman",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "bashls",
        "dockerls",
        "taplo",
        "emmet_language_server",
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
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "off",
              useLibraryCodeForTypes = true,
              diagnosticSeverityOverrides = {
                reportAttributeAccessIssue = "none",
                reportGeneralTypeIssues = "none",
                reportIncompatibleVariableOverride = "none",
                reportMissingImports = "warning",
                reportMissingModuleSource = "warning",
                reportOptionalIterable = "none",
                reportUnknownMemberType = "none",
              },
            },
          },
        },
        before_init = function(_, config)
          -- 向上查找虚拟环境（最多 3 层）
          local function find_venv(start_path)
            local path = start_path
            for _ = 1, 3 do
              for _, venv_name in ipairs({ ".venv", "venv", "env" }) do
                local venv_path = path .. "/" .. venv_name
                if vim.fn.isdirectory(venv_path) == 1 and vim.fn.filereadable(venv_path .. "/bin/python") == 1 then
                  return venv_path
                end
              end
              path = vim.fn.fnamemodify(path, ":h")
              if path == "/" then
                break
              end
            end
            return nil
          end

          -- 只在 root_dir 存在时才查找虚拟环境
          if config.root_dir then
            local venv = find_venv(config.root_dir)
            if venv then
              -- Client.create() 已经让 client.settings 指向这张表；必须原地
              -- 修改，替换 config.settings 会导致 pythonPath 没有发给 Pyright。
              config.settings.python.pythonPath = venv .. "/bin/python"
            end
          end
        end,
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

      -- 没有编译数据库时撤销 clangd 为孤立头文件选择的 Objective-C++ 模式，
      -- 再按扩展名使用 C/C++；真实项目参数仍以编译数据库为准。
      vim.lsp.config.clangd = {
        capabilities = capabilities,
        cmd = { "clangd", "--log=error" },
        init_options = {
          fallbackFlags = { "-x", "none" },
        },
      }

      -- HTML LSP 特殊配置：同时服务于 htmldjango
      vim.lsp.config.html = {
        capabilities = capabilities,
        filetypes = { "html", "htmldjango" },
        init_options = {
          provideFormatter = true,
          embeddedLanguages = { css = true, javascript = true },
          configurationSection = { "html", "css", "javascript" },
          dataPaths = {
            vim.uri_from_fname(htmx_custom_data_path),
          },
        },
        settings = {
          html = {
            customData = {
              htmx_custom_data_path,
            },
          },
        },
        handlers = {
          ["html/customDataContent"] = html_custom_data_content,
        },
      }

      -- CSS LSP 特殊配置：不服务于 htmldjango（避免在 HTML 模板中出现 CSS 属性补全）
      vim.lsp.config.cssls = {
        capabilities = capabilities,
        filetypes = { "css", "scss", "less" },
      }

      -- Emmet LSP 特殊配置：同时服务于 htmldjango
      vim.lsp.config.emmet_language_server = {
        capabilities = capabilities,
        filetypes = { "html", "css", "scss", "less", "htmldjango" },
      }

      -- 其他服务器使用默认配置
      local special_servers = {
        "clangd",
        "pyright",
        "lua_ls",
        "html",
        "cssls",
        "emmet_language_server",
      }
      for _, server in ipairs(opts.ensure_installed) do
        if not vim.tbl_contains(special_servers, server) then
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
      auto_open = false,
      auto_close = true,
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xl",
        function()
          vim.diagnostic.open_float(nil, {
            scope = "line",
            focusable = true,
            border = "rounded",
            source = "always",
          })
        end,
        desc = "Line Diagnostics",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics",
      },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Info (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    },
  },

  -- Inline diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "BufReadPre", "BufNewFile" },
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "ghost",
        options = {
          show_source = { enabled = true, if_many = true },
          throttle = 80,
          softwrap = 30,
          multilines = { enabled = true, always_show = false },
          show_all_diags_on_cursorline = false,
          enable_on_insert = false,
          overflow = { mode = "oneline" },
          virt_texts = { priority = 2048 },
        },
      })
    end,
  },

  -- LSP UI 美化
  {
    "nvimdev/lspsaga.nvim",
    -- 需要在 LspAttach 前注册 symbol 监听；按 LspAttach 懒加载会错过
    -- 当前 buffer 的首次事件，导致刚启动时 Outline 取不到 symbols。
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lspsaga").setup({
        ui = {
          border = "rounded",
          kind = {
            Class = { "󰌗 ", "Include" },
          },
        },
        outline = {
          auto_preview = false, -- 切换 tab 时 outline 的自动预览偶发把浮窗高度算成 0
        },
        lightbulb = { enable = false },
        hover = {
          open_link = "gx",
          open_cmd = "!open", -- macOS 用 open，Linux 用 xdg-open
          max_width = 0.4,
          max_height = 0.6,
        },
      })

      vim.api.nvim_set_hl(0, "SagaClass", { link = "FrappeLavender" })
    end,
    keys = {
      { "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Documentation" },

      -- 跳转到定义（当前窗口）
      {
        "<leader>ld",
        "<cmd>Lspsaga goto_definition<cr>",
        desc = "Goto Definition",
      },

      -- 跳转到定义（垂直分屏）
      {
        "<leader>lv",
        function()
          vim.cmd("vsplit")
          vim.cmd("Lspsaga goto_definition")
        end,
        desc = "Goto Definition (Vertical Split)",
      },

      -- 跳转到定义（水平分屏）
      {
        "<leader>ls",
        function()
          vim.cmd("split")
          vim.cmd("Lspsaga goto_definition")
        end,
        desc = "Goto Definition (Horizontal Split)",
      },

      -- 预览定义（不跳转，浮动窗口显示）
      { "<leader>lf", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },

      -- 查找引用和实现
      { "<leader>lr", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder (References/Implementation)" },

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

  -- Noice: cmdline, notifications, popupmenu; messages stay native.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written$",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = '^".*"%s+%d+L,',
          },
          opts = { skip = true },
        },
      },
      views = {
        notify = {
          replace = true, -- 关键配置：合并/替换重复通知，避免堆叠
        },
      },
      messages = {
        -- 不接管 ext_messages，让 /、?、n、N 的 [当前/总数] 使用
        -- Neovim 原生底部命令行显示，而不是行末虚拟文本。
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false, -- 关闭右上角 LSP 进度提示，避免 pyright 持续占用空间
          view = "notify",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = false,
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
