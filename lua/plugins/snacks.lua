---@diagnostic disable: undefined-global
---@diagnostic disable: duplicate-set-field
local function fzf()
  return require("fzf-lua")
end

local function has_lsp_method(method, bufnr)
  local ok, clients = pcall(vim.lsp.get_clients, { bufnr = bufnr, method = method })
  return ok and type(clients) == "table" and #clients > 0
end

local function pick_document_symbols()
  if has_lsp_method("textDocument/documentSymbol", vim.api.nvim_get_current_buf()) then
    fzf().lsp_document_symbols()
    return
  end

  local ok = pcall(fzf().treesitter)
  if ok then
    return
  end

  if vim.fn.executable("ctags") == 1 then
    fzf().btags()
    return
  end

  vim.notify("No LSP document symbols, treesitter symbols, or ctags support for this buffer.", vim.log.levels.WARN)
end

local function pick_workspace_symbols()
  if has_lsp_method("workspace/symbol") then
    fzf().lsp_live_workspace_symbols()
    return
  end

  if vim.fn.executable("ctags") == 1 then
    fzf().tags()
    return
  end

  vim.notify("No LSP workspace symbol support or ctags binary available.", vim.log.levels.WARN)
end

return {
  -- Snacks: 常用插件集合, 功能混杂, 因此使用单独文件配置
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@class snacks.Config: table
    opts = { -- 这里配置要启动的插件
      bigfile = { enabled = true }, -- 大文件友好模式
      dashboard = { enabled = false }, -- 暂时禁用欢迎界面，排查问题
      explorer = { enabled = false }, -- 文件浏览器改用 neo-tree
      image = { enabled = false }, -- 禁用：SVG 渲染不支持，会显示空白框
      input = { enabled = true }, -- 改善 vim.ui.input: 更好的弹窗、占位、样式
      notifier = { enabled = false }, -- 禁用，避免与 noice.nvim 冲突导致重复通知
      picker = { -- like fzf or Telescope
        enabled = true,
      },
      indent = { enabled = true }, -- 视觉化缩进线 & 范围
      scope = { enabled = true }, -- 基于 treesitter/indent 的 scope 检测
      quickfile = { enabled = true }, -- 立刻渲染文件
      scroll = { enabled = false }, -- 禁用平滑滚动，避免搜索显示问题
      -- 美化状态栏 gutter: 行号左侧的东西
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = false, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          patterns = { "GitSign", "MiniDiffSign" }, -- patterns to match Git signs
        },
        refresh = 50, -- refresh at most every 50ms
      },
      words = { enabled = true }, -- 高亮光标单词, 显示计数
    },
    keys = {
      -- snacks-specific pickers
      {
        "<leader>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },
      -- find
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      -- Other
      {
        "<leader>z",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },
      {
        "<leader>Z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      -- 移除：notifier 已禁用，使用上面的 picker.notifications 代替
      -- {
      --   "<leader>n",
      --   function()
      --     Snacks.notifier.show_history()
      --   end,
      --   desc = "Notification History",
      -- },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      -- 移除：notifier 已禁用，使用 noice.nvim 的通知系统
      -- {
      --   "<leader>un",
      --   function()
      --     Snacks.notifier.hide()
      --   end,
      --   desc = "Dismiss All Notifications",
      -- },
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<c-_>",
        function()
          Snacks.terminal()
        end,
        desc = "which_key_ignore",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader><space>",
        function()
          fzf().global()
        end,
        desc = "Global Search",
      },
      {
        "<leader>bb",
        function()
          fzf().buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function()
          fzf().live_grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>:",
        function()
          fzf().command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>fb",
        function()
          fzf().buffers()
        end,
        desc = "Find Buffers",
      },
      {
        "<leader>fc",
        function()
          fzf().files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config Files",
      },
      {
        "<leader>ff",
        function()
          fzf().files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          fzf().git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fr",
        function()
          fzf().oldfiles()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fs",
        function()
          pick_document_symbols()
        end,
        desc = "Document Symbols",
      },
      {
        "<leader>fS",
        function()
          pick_workspace_symbols()
        end,
        desc = "Workspace Symbols",
      },
      {
        "<leader>ft",
        function()
          fzf().treesitter()
        end,
        desc = "Treesitter Symbols",
      },
      {
        "<leader>fT",
        function()
          fzf().tags()
        end,
        desc = "Project Tags",
      },
      {
        "<leader>fR",
        function()
          fzf().resume()
        end,
        desc = "Fzf Resume",
      },
    },
    opts = {
      { "fzf-native", "hide" },
      winopts = {
        height = 0.9,
        width = 0.9,
        preview = {
          layout = "vertical",
          vertical = "down:45%",
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    ---@module "neo-tree"
    ---@type neotree.Config
    opts = {
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
        },
      },
      window = {
        position = "left",
        width = 36,
        mappings = {
          ["<cr>"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
          ["H"] = "toggle_hidden",
          ["t"] = false,
          ["o"] = "open_tabnew",
          ["s"] = "open_vsplit",
          ["S"] = "open_split",
          ["P"] = { "toggle_preview", config = { use_float = true } },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        "<cmd>Neotree filesystem reveal left toggle<cr>",
        desc = "File Explorer",
      },
    },
  },
}
