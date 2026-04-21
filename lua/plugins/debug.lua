return {
  -- nvim-dap: Debug Adapter Protocol client
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")

      -- Nord color palette (matching your theme)
      local colors = {
        red = "#BF616A", -- Nord11 - 红色
        orange = "#D08770", -- Nord12 - 橙色
        yellow = "#EBCB8B", -- Nord13 - 黄色
        green = "#A3BE8C", -- Nord14 - 绿色
        purple = "#B48EAD", -- Nord15 - 紫色
        frost_green = "#8FBCBB", -- Nord7 - 青色
        gray = "#4C566A", -- Nord3 - 灰色
      }

      -- Function to setup breakpoint signs and colors
      local function setup_breakpoint_signs()
        -- Define highlight groups for breakpoint signs
        vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = colors.red })
        vim.api.nvim_set_hl(0, "DapBreakpointConditionSign", { fg = colors.orange })
        vim.api.nvim_set_hl(0, "DapBreakpointRejectedSign", { fg = colors.gray })
        vim.api.nvim_set_hl(0, "DapStoppedSign", { fg = colors.green })
        vim.api.nvim_set_hl(0, "DapLogPointSign", { fg = colors.yellow })

        -- Define signs with subtle icons and color highlights
        vim.fn.sign_define("DapBreakpoint", {
          text = "●",
          texthl = "DapBreakpointSign",
          linehl = "",
          numhl = "", -- 不高亮行号
        })
        vim.fn.sign_define("DapBreakpointCondition", {
          text = "◆",
          texthl = "DapBreakpointConditionSign",
          linehl = "",
          numhl = "", -- 不高亮行号
        })
        vim.fn.sign_define("DapBreakpointRejected", {
          text = "○",
          texthl = "DapBreakpointRejectedSign",
          linehl = "",
          numhl = "", -- 不高亮行号
        })
        vim.fn.sign_define("DapStopped", {
          text = "➜",
          texthl = "DapStoppedSign",
          linehl = "",
          numhl = "", -- 不高亮行号
        })
        vim.fn.sign_define("DapLogPoint", {
          text = "◉",
          texthl = "DapLogPointSign",
          linehl = "",
          numhl = "", -- 不高亮行号
        })
      end

      -- Setup immediately
      setup_breakpoint_signs()

      -- Re-apply after colorscheme changes (in case theme overrides our colors)
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = setup_breakpoint_signs,
      })
    end,
  },

  -- Inline variable values while debugging
  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = false,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },

  -- Persist breakpoints across Neovim restarts
  {
    "Weissle/persistent-breakpoints.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" },
      })
    end,
  },

  -- Mason DAP: 自动安装调试器
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      ensure_installed = {
        "python", -- 使用 adapter 名称而不是 debugpy
      },
      automatic_installation = true,
      handlers = {
        function(config)
          -- 默认处理器
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },

  -- nvim-dap-python: Python 调试扩展
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "jay-babu/mason-nvim-dap.nvim",
    },
    ft = "python",
    config = function()
      -- 使用 Mason 安装的 debugpy
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_path)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
          local opts = { buffer = args.buf, desc = "Debug Test Method" }
          vim.keymap.set("n", "<leader>tm", function()
            require("dap-python").test_method()
          end, opts)
          vim.keymap.set("n", "<leader>tc", function()
            require("dap-python").test_class()
          end, { buffer = args.buf, desc = "Debug Test Class" })
        end,
      })
    end,
  },

  -- nvim-dap-view: 更轻量的单面板调试界面
  {
    "igorlfs/nvim-dap-view",
    version = "1.*",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      auto_toggle = true,
      winbar = {
        sections = { "scopes", "breakpoints", "threads", "watches", "repl", "console" },
        default_section = "scopes",
        show_keymap_hints = false,
      },
      windows = {
        size = 0.5,
        position = "right",
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      require("dap-view").setup(opts)

      local function is_jump_target(win, dap_view_win)
        if not win or win == 0 or not vim.api.nvim_win_is_valid(win) then
          return false
        end
        if dap_view_win and win == dap_view_win then
          return false
        end
        if vim.wo[win].winfixbuf then
          return false
        end

        local buf = vim.api.nvim_win_get_buf(win)
        if not vim.api.nvim_buf_is_valid(buf) then
          return false
        end

        return vim.bo[buf].buftype == ""
      end

      local function focus_edit_window_for_dap_jump()
        local cur_win = vim.api.nvim_get_current_win()
        if not vim.api.nvim_win_is_valid(cur_win) then
          return
        end

        local state = require("dap-view.state")
        local dap_view_win = state.winnr
        local cur_is_dap_view = dap_view_win and cur_win == dap_view_win

        if not cur_is_dap_view and not vim.wo[cur_win].winfixbuf then
          return
        end

        local alt_win = vim.fn.win_getid(vim.fn.winnr("#"))
        if is_jump_target(alt_win, dap_view_win) then
          vim.api.nvim_set_current_win(alt_win)
          return
        end

        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if is_jump_target(win, dap_view_win) then
            vim.api.nvim_set_current_win(win)
            return
          end
        end

        vim.cmd("belowright split")
      end

      -- Force redraw on DAP events to fix rendering issues
      local function force_redraw()
        vim.cmd("redraw!")
      end

      local function schedule_redraw()
        vim.schedule(function()
          vim.cmd("redraw")
        end)
      end

      -- nvim-dap jumps to the stopped frame in the current window. If the
      -- current window is dap-view (or any other winfixbuf window), that jump
      -- fails with E1513. Move focus back to a normal edit window first.
      dap.listeners.before.event_stopped["avoid_winfixbuf_jump"] = focus_edit_window_for_dap_jump

      -- Redraw after stopped event (when execution pauses at breakpoint)
      dap.listeners.after.event_stopped["force_redraw"] = schedule_redraw
      dap.listeners.after.setBreakpoints["force_redraw"] = schedule_redraw

      -- Redraw after continue (when execution resumes)
      dap.listeners.after.continue["force_redraw"] = force_redraw

      -- Redraw after stepping
      dap.listeners.after.next["force_redraw"] = force_redraw
      dap.listeners.after.stepIn["force_redraw"] = force_redraw
      dap.listeners.after.stepOut["force_redraw"] = force_redraw
      dap.listeners.after.stepBack["force_redraw"] = force_redraw
    end,
    keys = {
      -- Basic debugging
      {
        "<leader>ds",
        function()
          local dap = require("dap")
          if dap.session() then
            vim.notify("Debug session already active", vim.log.levels.INFO)
            return
          end
          dap.continue()
        end,
        desc = "Start",
      },
      {
        "<leader>dc",
        function()
          local dap = require("dap")
          local session = dap.session()
          if not session or session.stopped_thread_id then
            dap.continue()
            return
          end

          local choices = {
            {
              label = "Do nothing",
              action = function() end,
            },
            {
              label = "Terminate session",
              action = dap.terminate,
            },
            {
              label = "Pause a thread",
              action = dap.pause,
            },
            {
              label = "Restart session",
              action = dap.restart,
            },
            {
              label = "Disconnect (terminate = true)",
              action = function()
                dap.disconnect({ terminateDebuggee = true })
              end,
            },
            {
              label = "Disconnect (terminate = false)",
              action = function()
                dap.disconnect({ terminateDebuggee = false })
              end,
            },
            {
              label = "Start additional session",
              action = function()
                dap.continue({ new = true })
              end,
            },
          }

          vim.ui.select(choices, {
            prompt = "Session active, but not stopped at breakpoint> ",
            format_item = function(item)
              return item.label
            end,
          }, function(choice)
            if choice then
              choice.action()
            end
          end)
        end,
        desc = "Continue",
      },
      {
        "<leader>dn",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },

      -- Breakpoints
      {
        "<leader>db",
        function()
          require("persistent-breakpoints.api").toggle_breakpoint()
          vim.schedule(function()
            vim.cmd("redraw!")
          end)
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("persistent-breakpoints.api").set_conditional_breakpoint()
        end,
        desc = "Set Conditional Breakpoint",
      },
      {
        "<leader>dl",
        function()
          require("persistent-breakpoints.api").set_log_point()
        end,
        desc = "Set Log Point",
      },

      -- UI controls
      {
        "<leader>du",
        function()
          local state = require("dap-view.state")

          if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
            vim.cmd("DapViewClose")
            return
          end

          vim.cmd("DapViewOpen")
        end,
        desc = "Toggle View",
      },
      {
        "<leader>de",
        function()
          require("dap.ui.widgets").hover()
        end,
        mode = { "n", "v" },
        desc = "Evaluate Expression",
      },

      -- Session management
      {
        "<leader>dp",
        function()
          require("dap").repl.open()
        end,
        desc = "Open REPL",
      },
      {
        "<leader>dR",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>dq",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
    },
  },
}
