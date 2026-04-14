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
        "jinja_lsp",
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
              config.settings.python.pythonPath = venv .. "/bin/python"
            end
          end
        end,
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

      -- Jinja LSP 特殊配置：同时服务于 html 和 htmldjango 文件类型
      vim.lsp.config.jinja_lsp = {
        capabilities = capabilities,
        filetypes = { "html", "htmldjango" },
        root_dir = function(fname)
          -- 在包含 templates/ 目录的项目中启用
          return vim.fs.root(fname, { "templates", ".git", "manage.py", "app.py" })
        end,
      }

      -- HTML LSP 特殊配置：同时服务于 htmldjango
      vim.lsp.config.html = {
        capabilities = capabilities,
        filetypes = { "html", "htmldjango" },
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
      local special_servers = { "pyright", "lua_ls", "jinja_lsp", "html", "cssls", "emmet_language_server" }
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
      height = 10,
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
          -- 窗口位置：优先下方，增加偏移避免覆盖当前行
          position = "auto",
          prefer_above = false, -- 优先下方
          offset_y = 1, -- 向下偏移 1 行，确保不覆盖当前行
          offset_x = 0, -- 水平不偏移
        },
      })

      vim.api.nvim_set_hl(0, "SagaClass", { link = "FrappeLavender" })

      local saga_util = require("lspsaga.util")
      local get_max_content_length = saga_util.get_max_content_length

      -- lspsaga outline 的预览内容偶尔会是空表；原实现会返回 nil 并在 math.min() 处报错。
      saga_util.get_max_content_length = function(contents)
        if type(contents) ~= "table" or vim.tbl_isempty(contents) then
          return 1
        end

        return get_max_content_length(contents) or 1
      end

      local outline = require("lspsaga.symbol.outline")
      local outline_mt = getmetatable(outline)
      local outline_text_ns = vim.api.nvim_create_namespace("SagaOutlineText")
      local saga_kinds = require("lspsaga.lspkind").kind
      local saga_slist = require("lspsaga.slist")

      local function highlight_outline_names(self)
        if not self.bufnr or not vim.api.nvim_buf_is_valid(self.bufnr) or not self.list then
          return
        end

        vim.api.nvim_buf_clear_namespace(self.bufnr, outline_text_ns, 0, -1)

        local node = self.list
        while node do
          local value = node.value
          if value and value.winline and value.winline > 0 and value.kind and saga_kinds[value.kind] then
            local hl = "Saga" .. saga_kinds[value.kind][1]
            vim.api.nvim_buf_add_highlight(self.bufnr, outline_text_ns, hl, value.winline - 1, value.inlevel or 0, -1)
          end
          node = node.next
        end
      end

      if outline_mt and not outline_mt._tab_refresh_guard_patched then
        outline_mt._tab_refresh_guard_patched = true
        local original_parse = outline_mt.parse
        local original_toggle_or_jump = outline_mt.toggle_or_jump

        local outline_group = vim.api.nvim_create_augroup("outline", { clear = false })

        local function outline_window_is_valid(self)
          return self.winid
            and vim.api.nvim_win_is_valid(self.winid)
            and self.bufnr
            and vim.api.nvim_buf_is_valid(self.bufnr)
        end

        local function save_outline_view(self)
          if not outline_window_is_valid(self) then
            return nil
          end

          local ok, view = pcall(vim.api.nvim_win_call, self.winid, vim.fn.winsaveview)
          return ok and view or nil
        end

        local function restore_outline_view(self, view)
          if not view or not outline_window_is_valid(self) then
            return
          end

          local line_count = vim.api.nvim_buf_line_count(self.bufnr)
          view.lnum = math.min(math.max(view.lnum or 1, 1), line_count)
          view.topline = math.min(math.max(view.topline or 1, 1), line_count)
          pcall(vim.api.nvim_win_call, self.winid, function()
            vim.fn.winrestview(view)
          end)
        end

        local function node_contains_line(value, line)
          local range = value.range or value.selectionRange or value.targetRange
          if value.location then
            range = value.location.range
          end

          return range and line >= range.start.line and line <= range["end"].line
        end

        local function focus_outline_at_line(self, curline)
          if not curline or not outline_window_is_valid(self) or not self.list then
            return
          end

          local line = curline - 1
          local target
          local node = self.list
          while node do
            local value = node.value
            if value and value.winline and value.winline > 0 and node_contains_line(value, line) then
              target = value
            end
            node = node.next
          end

          if not target then
            return
          end

          local row = math.min(target.winline, vim.api.nvim_buf_line_count(self.bufnr))
          local col = math.max((target.inlevel or 1) - 1, 0)
          pcall(vim.api.nvim_win_set_cursor, self.winid, { row, col })
          pcall(vim.api.nvim_win_call, self.winid, function()
            vim.cmd("normal! zz")
          end)
        end

        outline_mt.parse = function(self, symbols, curline)
          local view = curline and nil or save_outline_view(self)
          self.list = saga_slist.new()
          original_parse(self, symbols, curline)
          highlight_outline_names(self)
          focus_outline_at_line(self, curline)
          restore_outline_view(self, view)
          vim.schedule(function()
            focus_outline_at_line(self, curline)
          end)
        end

        outline_mt.toggle_or_jump = function(self)
          original_toggle_or_jump(self)
          highlight_outline_names(self)
        end

        local function outline_tab_is_current(self)
          return self.winid
            and vim.api.nvim_win_is_valid(self.winid)
            and vim.api.nvim_win_get_tabpage(self.winid) == vim.api.nvim_get_current_tabpage()
        end

        -- lspsaga outline 把状态存在单例里，原始 BufEnter/User 回调没有按 tab 隔离。
        -- 切到别的 tab 时，其他 buffer 会把当前 outline 的 main_buf 覆盖掉，回来后看到旧结构。
        outline_mt.refresh = function(self)
          local api = vim.api
          local symbol = require("lspsaga.symbol")

          api.nvim_create_autocmd("User", {
            group = outline_group,
            pattern = "SagaSymbolUpdate",
            callback = function(args)
              if
                not outline_tab_is_current(self)
                or not self.bufnr
                or not api.nvim_buf_is_valid(self.bufnr)
                or api.nvim_get_current_buf() ~= args.data.bufnr
              then
                return
              end

              api.nvim_set_option_value("modifiable", true, { buf = self.bufnr })
              vim.schedule(function()
                self:parse(args.data.symbols)
                self.main_buf = args.data.bufnr
              end)
            end,
          })

          api.nvim_create_autocmd("BufEnter", {
            group = outline_group,
            callback = function(args)
              if not outline_tab_is_current(self) or args.buf == self.main_buf then
                return
              end

              local res = not saga_util.nvim_ten() and symbol:get_buf_symbols(args.buf)
                or require("lspsaga.symbol.head"):get_buf_symbols(args.buf)

              if not res or not res.symbols or #res.symbols == 0 then
                return
              end

              local curline = api.nvim_win_get_cursor(0)[1]
              self.main_buf = args.buf
              self:parse(res.symbols, curline)
            end,
          })
        end
      end
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
    enabled = true, -- 启用 noice.nvim 的命令行美化
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
      },
      views = {
        notify = {
          replace = true, -- 关键配置：合并/替换重复通知，避免堆叠
        },
      },
      lsp = {
        progress = {
          enabled = true, -- 启用 LSP 进度通知
          view = "notify",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
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
