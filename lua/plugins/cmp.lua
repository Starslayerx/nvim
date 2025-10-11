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
      completion = { documentation = { auto_show = false } },
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
    config = true,
    opts = {
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
      check_ts = false,
      map_cr = true,
      map_bs = true,
      map_c_h = false,
      map_c_w = false,
    },
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
