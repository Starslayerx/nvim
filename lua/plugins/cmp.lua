return {
  -- 代码补全
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "fang2hou/blink-copilot",
    },
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = false },
        accept = {
          auto_brackets = {
            enabled = true,
            default_brackets = { "(", ")" },
            override_brackets_for_filetypes = {},
            -- 使用 kind 字段判断是否添加括号
            kind_resolution = {
              enabled = true,
              blocked_filetypes = {}, -- 清空阻止列表，确保 Python 也能使用
            },
            -- 使用语义 token 异步判断（更准确）
            semantic_token_resolution = {
              enabled = true,
              blocked_filetypes = {}, -- 清空阻止列表
              timeout_ms = 400,
            },
          },
        },
      },
      sources = {
        -- 移除 copilot，只在需要时手动添加
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 2,
              max_attempts = 4,
              kind_name = "Copilot",
              kind_icon = " ",
              kind_hl = false,
              debounce = 200,
              auto_refresh = {
                backward = true,
                forward = true,
              },
            },
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  -- 自动括号补全
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        enabled = function(bufnr)
          return true
        end,
        disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },
        disable_in_macro = true,
        disable_in_visualblock = false,
        disable_in_replace_mode = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true,
        enable_check_bracket_line = true,
        enable_bracket_in_quote = true,
        enable_abbr = false,
        break_undo = true,
        check_ts = true, -- 启用 treesitter 检查
        map_cr = true,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
      })

      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      local ts_conds = require("nvim-autopairs.ts-conds")

      -- 辅助函数：检查是否在代码块的编程语言中
      local function is_in_code_lang()
        return ts_conds.is_in_range(function(result)
          if result and result.lang then
            -- 支持的编程语言列表
            local code_langs = { "python", "lua", "javascript", "typescript", "rust", "go", "c", "cpp", "java" }
            return vim.tbl_contains(code_langs, result.lang)
          end
          return false
        end, function()
          local cursor = vim.api.nvim_win_get_cursor(0)
          return { cursor[1] - 1, cursor[2] }
        end)
      end

      -- Markdown 特殊处理：只在代码块内启用括号配对
      npairs.add_rules({
        -- 在 markdown 中，只有在代码块内才配对 {
        Rule("{", "}", "markdown"):with_pair(is_in_code_lang()),
        Rule("(", ")", "markdown"):with_pair(is_in_code_lang()),
        Rule("[", "]", "markdown"):with_pair(is_in_code_lang()),
        -- 引号也只在代码块内配对
        Rule("'", "'", "markdown"):with_pair(is_in_code_lang()),
        Rule('"', '"', "markdown"):with_pair(is_in_code_lang()),
      })

      -- Python f-string 会由默认的引号配对规则处理
      -- 删除了之前有问题的特殊规则，该规则会阻止普通引号输入

      -- Jinja2 模板空格规则：在 {{ }} 和 {% %} 中按空格自动两边加空格
      npairs.add_rules({
        -- 当在 {{|}} 中按空格时，变成 {{ | }}
        Rule(" ", " ")
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 2, opts.col - 1)
            return vim.tbl_contains({ "{{", "{%", "{#" }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({ "{{  }}", "{%  %}", "{#  #}" }, context)
          end),
      })
    end,
  },
  -- github copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot", -- 只保留 cmd，移除 event
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        lua = true,
        python = true,
        javascript = true,
      },
    },
  },
  -- copilot integration with blink.cmp
  {
    "fang2hou/blink-copilot",
  },
}
