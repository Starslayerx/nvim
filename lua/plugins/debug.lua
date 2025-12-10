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
                red = "#BF616A",        -- Nord11 - 红色
                orange = "#D08770",     -- Nord12 - 橙色
                yellow = "#EBCB8B",     -- Nord13 - 黄色
                green = "#A3BE8C",      -- Nord14 - 绿色
                purple = "#B48EAD",     -- Nord15 - 紫色
                frost_green = "#8FBCBB", -- Nord7 - 青色
                gray = "#4C566A",       -- Nord3 - 灰色
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
                    numhl = "",  -- 不高亮行号
                })
                vim.fn.sign_define("DapBreakpointCondition", {
                    text = "◆",
                    texthl = "DapBreakpointConditionSign",
                    linehl = "",
                    numhl = "",  -- 不高亮行号
                })
                vim.fn.sign_define("DapBreakpointRejected", {
                    text = "○",
                    texthl = "DapBreakpointRejectedSign",
                    linehl = "",
                    numhl = "",  -- 不高亮行号
                })
                vim.fn.sign_define("DapStopped", {
                    text = "➜",
                    texthl = "DapStoppedSign",
                    linehl = "",
                    numhl = "",  -- 不高亮行号
                })
                vim.fn.sign_define("DapLogPoint", {
                    text = "◉",
                    texthl = "DapLogPointSign",
                    linehl = "",
                    numhl = "",  -- 不高亮行号
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
        end,
    },

    -- nvim-dap-ui: 调试界面
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Setup dap-ui
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
                floating = {
                    border = "single",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
            })

            -- Automatically open/close dap-ui
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
        keys = {
            -- Basic debugging
            { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
            { "<leader>dv", function() require("dap").step_over() end, desc = "Debug: Step Over" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into" },
            { "<leader>do", function() require("dap").step_out() end, desc = "Debug: Step Out" },

            -- Breakpoints
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Debug: Set Conditional Breakpoint",
            },
            {
                "<leader>dl",
                function()
                    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
                end,
                desc = "Debug: Set Log Point",
            },

            -- UI controls
            { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
            {
                "<leader>de",
                function() require("dapui").eval() end,
                mode = { "n", "v" },
                desc = "Debug: Evaluate Expression",
            },

            -- Session management
            { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
            { "<leader>dR", function() require("dap").run_last() end, desc = "Debug: Run Last" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate" },

            -- Python specific
            {
                "<leader>dtm",
                function() require("dap-python").test_method() end,
                desc = "Debug: Test Method (Python)",
            },
            {
                "<leader>dtc",
                function() require("dap-python").test_class() end,
                desc = "Debug: Test Class (Python)",
            },
        },
    },
}
