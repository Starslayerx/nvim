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
      })
    end,
    keys = {}, -- 不定义快捷键避免冲突
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
