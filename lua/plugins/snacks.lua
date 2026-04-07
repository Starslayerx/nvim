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
