-- Jinja2/Flask 模板文件类型配置

-- 纯 Jinja2 文件（.jinja, .jinja2, .j2）使用 jinja 文件类型
vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})

-- 检测 Jinja2 模板的辅助函数
local function is_jinja_template(path, bufnr)
  -- 1. 如果在 templates/ 目录下，很可能是 Jinja2 模板
  if path:match("/templates/") then
    return true
  end

  -- 2. 检查文件内容（前 50 行）
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 50, false)
  local content = table.concat(lines, "\n")

  -- 检测 Jinja2 语法特征
  if content:match("{%%") or content:match("{{") or content:match("{#") then
    return true
  end

  return false
end

-- HTML 文件的 Jinja2 处理
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.html",
  callback = function(args)
    local bufnr = args.buf
    local path = vim.api.nvim_buf_get_name(bufnr)

    -- 检测是否是 Jinja2 模板
    if is_jinja_template(path, bufnr) then
      -- 保持 filetype 为 html（保留 HTML LSP 和格式化功能）
      vim.bo[bufnr].filetype = "html"

      -- 使用 htmldjango treesitter parser 进行语法高亮
      vim.treesitter.language.register("htmldjango", "html")

      -- 标记这是一个 Jinja2 模板（供其他插件使用）
      vim.b[bufnr].is_jinja_template = true
    end
  end,
})

-- 纯 jinja 文件类型配置
vim.api.nvim_create_autocmd("FileType", {
  pattern = "jinja",
  callback = function()
    -- 使用 htmldjango treesitter parser
    vim.treesitter.language.register("htmldjango", "jinja")
    -- 设置注释格式（用于 gcc 等注释命令）
    vim.bo.commentstring = "{# %s #}"
  end,
})

-- Jinja2 模板键映射：在 {|} 中输入 % 或 # 时自动补全
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "jinja", "htmldjango" },
  callback = function()
    -- 处理 % 键：{|} -> {% | %}
    vim.keymap.set("i", "%", function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      local prev_char = line:sub(col, col)
      local next_char = line:sub(col + 1, col + 1)

      if prev_char == "{" and next_char == "}" then
        -- 插入 "% " 删除 "}" 插入 " %}" 然后光标左移3次到中间
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("% <Del> %}<Left><Left><Left>", true, false, true),
          "n",
          false
        )
        return ""
      end
      return "%"
    end, { buffer = true, expr = true })

    -- 处理 # 键：{|} -> {# | #}
    vim.keymap.set("i", "#", function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      local prev_char = line:sub(col, col)
      local next_char = line:sub(col + 1, col + 1)

      if prev_char == "{" and next_char == "}" then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("# <Del> #}<Left><Left><Left>", true, false, true),
          "n",
          false
        )
        return ""
      end
      return "#"
    end, { buffer = true, expr = true })
  end,
})
