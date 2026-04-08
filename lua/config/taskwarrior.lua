local M = {}

local group = vim.api.nvim_create_augroup("TaskwarriorIntegration", { clear = true })

local function task_available()
  return vim.fn.executable("task") == 1
end

local function notify_missing_task()
  vim.notify("Taskwarrior executable not found in PATH", vim.log.levels.WARN)
end

local function split_lines(text)
  if text == nil or text == "" then
    return {}
  end
  return vim.split(vim.trim(text), "\n", { plain = true })
end

local function current_task_id()
  local line = vim.api.nvim_get_current_line()
  local id = line:match("^%s*(%d+)%s+")
  return id and tonumber(id) or nil
end

local function open_float(title, lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "taskwarrior-info"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = math.min(100, math.max(50, math.floor(vim.o.columns * 0.7)))
  local height = math.min(math.max(#lines, 1) + 2, math.max(10, math.floor(vim.o.lines * 0.7)))

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.max(1, math.floor((vim.o.columns - width) / 2)),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  })

  vim.bo[buf].modifiable = false
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true, desc = "Close Task Info" })
end

local function render_panel(buf, title, cmd, lines)
  vim.bo[buf].modifiable = true
  vim.bo[buf].readonly = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].modified = false
  vim.b[buf].taskwarrior_title = title
  vim.b[buf].taskwarrior_cmd = cmd
end

local function run_task(args, callback)
  if not task_available() then
    notify_missing_task()
    return
  end

  local cmd = { "task", "rc.color=off", "rc._forcecolor=off" }
  vim.list_extend(cmd, args)

  vim.system(cmd, { text = true }, vim.schedule_wrap(function(result)
    local output = {}
    vim.list_extend(output, split_lines(result.stdout))

    if result.code ~= 0 then
      local stderr = split_lines(result.stderr)
      if #stderr > 0 then
        if #output > 0 then
          table.insert(output, "")
        end
        vim.list_extend(output, stderr)
      end
    end

    if #output == 0 then
      output = { "No output" }
    end

    callback(result, output)
  end))
end

local function ensure_panel()
  local buf = vim.g.taskwarrior_panel_buf
  local win = vim.g.taskwarrior_panel_win

  if buf and vim.api.nvim_buf_is_valid(buf) and win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    return buf, win
  end

  vim.cmd("botright 14split")
  win = vim.api.nvim_get_current_win()
  buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_win_set_buf(win, buf)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "taskwarrior"
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].wrap = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].cursorline = true

  vim.g.taskwarrior_panel_buf = buf
  vim.g.taskwarrior_panel_win = win

  local opts = { buffer = buf, silent = true }
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, vim.tbl_extend("force", opts, { desc = "Close Task Panel" }))
  vim.keymap.set("n", "r", function()
    M.refresh()
  end, vim.tbl_extend("force", opts, { desc = "Refresh Tasks" }))
  vim.keymap.set("n", "<CR>", function()
    M.info()
  end, vim.tbl_extend("force", opts, { desc = "Task Info" }))
  vim.keymap.set("n", "x", function()
    M.done()
  end, vim.tbl_extend("force", opts, { desc = "Complete Task" }))

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = buf,
    callback = function()
      if vim.g.taskwarrior_panel_buf == buf then
        vim.g.taskwarrior_panel_buf = nil
        vim.g.taskwarrior_panel_win = nil
      end
    end,
  })

  return buf, win
end

function M.show(title, args)
  local buf, win = ensure_panel()
  vim.api.nvim_set_current_win(win)
  render_panel(buf, title, args, { "Loading Taskwarrior output..." })

  run_task(args, function(result, lines)
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    if result.code ~= 0 then
      render_panel(buf, title, args, lines)
      vim.notify("Taskwarrior command failed", vim.log.levels.ERROR)
      return
    end

    render_panel(buf, title, args, lines)
  end)
end

function M.refresh(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local title = vim.b[buf].taskwarrior_title
  local cmd = vim.b[buf].taskwarrior_cmd
  if not title or not cmd then
    return
  end
  M.show(title, cmd)
end

function M.info()
  local id = current_task_id()
  if not id then
    vim.notify("No task ID on current line", vim.log.levels.INFO)
    return
  end

  run_task({ tostring(id), "info" }, function(result, lines)
    if result.code ~= 0 then
      vim.notify(table.concat(lines, "\n"), vim.log.levels.ERROR)
      return
    end
    open_float("Task " .. id, lines)
  end)
end

function M.done()
  local id = current_task_id()
  if not id then
    vim.notify("No task ID on current line", vim.log.levels.INFO)
    return
  end

  run_task({ tostring(id), "done" }, function(result, lines)
    if result.code ~= 0 then
      vim.notify(table.concat(lines, "\n"), vim.log.levels.ERROR)
      return
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    M.refresh()
  end)
end

function M.add(desc)
  local description = desc
  if not description or description == "" then
    description = vim.fn.input("Task description: ")
  end

  if description == nil or vim.trim(description) == "" then
    return
  end

  run_task({ "add", description }, function(result, lines)
    if result.code ~= 0 then
      vim.notify(table.concat(lines, "\n"), vim.log.levels.ERROR)
      return
    end
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    if vim.g.taskwarrior_panel_buf and vim.api.nvim_buf_is_valid(vim.g.taskwarrior_panel_buf) then
      M.refresh(vim.g.taskwarrior_panel_buf)
    end
  end)
end

vim.api.nvim_create_user_command("TaskNext", function()
  M.show("Taskwarrior Next", { "next" })
end, {})

vim.api.nvim_create_user_command("TaskAll", function()
  M.show("Taskwarrior All", {})
end, {})

vim.api.nvim_create_user_command("TaskProjects", function()
  M.show("Taskwarrior Projects", { "projects" })
end, {})

vim.api.nvim_create_user_command("TaskAdd", function(opts)
  M.add(opts.args)
end, {
  nargs = "*",
})

vim.keymap.set("n", "<leader>an", "<cmd>TaskNext<CR>", { silent = true, desc = "Task Next" })
vim.keymap.set("n", "<leader>aa", "<cmd>TaskAll<CR>", { silent = true, desc = "Task All" })
vim.keymap.set("n", "<leader>ap", "<cmd>TaskProjects<CR>", { silent = true, desc = "Task Projects" })
vim.keymap.set("n", "<leader>aA", "<cmd>TaskAdd<CR>", { silent = true, desc = "Task Add" })

return M
