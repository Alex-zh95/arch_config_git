-- Custom key mappings to override mappings in ./core/mappings.lua

local M = {}

M.general = {
    n = {
        -- switch between windows
        ["H"] = { "<C-w>h", "Window left" },
        ["L"] = { "<C-w>l", "Window right" },
        ["J"] = { "<C-w>j", "Window down" },
        ["K"] = { "<C-w>k", "Window up" },
    },
    v = {
        ["<C-a>"] = {":EasyAlign*<Bar><Enter>", "Align markdown tables"}
    }
}

M.spell = {
    n = {
        ["<leader>s"] = {":set spell<cr>", "Toggle spell checcker"},
        ["<leader>sen"] = {":set spelllang=en_us<cr>", "Set spell check language to US English"},
        ["<leader>sde"] = {":set spelllang=de<cr>", "Set spell check language to German"},
    }
}

M.debug = {
    n = {
        ["<leader>dc"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        ["<leader>ds"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
        ["<leader>di"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
        ["<leader>do"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
        ["<leader>db"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
        ["<leader>du"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
        ["<leader>dr"] = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
        ["<leader>dq"] = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    }
}

M.disabled = {
    -- Disable some default duplicated nvterm binds
    n = {
        ["<leader>h"] = "",
        ["<leader>v"] = ""
        -- ["K"] = ""
    }
}

M.lspconfig = {
    n = {
        -- Remapped the hover key to something else
        ["<leader>k"] = {
            function()
                vim.lsp.buf.hover()
            end,
            "lsp hover",
        }
    }
}

M.vim_misc = {
    n = {
        ["<leader>h"] = {"<cmd>vsplit<CR>", "Nvim horizontal split"},
        ["<leader>v"] = {"<cmd>split<CR>", "Nvim vertical split"},
        -- ["H"] = { ":wincmd < <CR>", "divider left"},
        -- ["L"] = { ":wincmd > <CR>", "divider right"},
        -- ["K"] = { ":wincmd + <CR>", "divider up"},
        -- ["J"] = { ":wincmd - <CR>", "divider down"},
        ["<leader>z"] = {":ZenMode<CR>", 'Toggle zen mode'},
    }
}

M.hop = {
    n = {
        ["<leader>fs"] = {
            function()
                HOP=require('hop')
                DIRECTIONS=require('hop.hint').HintDirection

                HOP.hint_char1({
                    direction = DIRECTIONS.AFTER_CURSOR,
                    current_line_only = false
                })
            end,
            "Jump to next highlighted character"},
        ["<leader>fb"] = {
            function()
                HOP=require('hop')
                DIRECTIONS=require('hop.hint').HintDirection

                HOP.hint_char1({
                    direction = DIRECTIONS.BEFORE_CURSOR,
                    current_line_only = false
                })
            end,
            "Jump to previous highlighted character"},

    },
    v = {
        ["<leader>fs"] = {
            function()
                HOP=require('hop')
                DIRECTIONS=require('hop.hint').HintDirection

                HOP.hint_char1({
                    direction = DIRECTIONS.AFTER_CURSOR,
                    current_line_only = false
                })
            end,
            "Jump to next highlighted character"},
        ["<leader>fb"] = {
            function()
                HOP=require('hop')
                DIRECTIONS=require('hop.hint').HintDirection

                HOP.hint_char1({
                    direction = DIRECTIONS.BEFORE_CURSOR,
                    current_line_only = false
                })
            end,
            "Jump to previous highlighted character"},

    }
}

M.nvterm = {
    plugin = true,

    t = {
        -- toggle in terminal mode
        ["<leader>tf"] = {
            function()
                require("nvterm.terminal").toggle "float"
            end,
            "toggle floating term",
        },

        ["<leader>th"] = {
            function()
                require("nvterm.terminal").toggle "horizontal"
            end,
            "toggle horizontal term",
        },

        ["<leader>tv"] = {
            function()
                require("nvterm.terminal").toggle "vertical"
            end,
            "toggle vertical term",
        },
    },

    n = {
        -- toggle in normal mode
        ["<leader>tf"] = {
            function()
                require("nvterm.terminal").toggle "float"
            end,
            "toggle floating term",
        },

        ["<leader>th"] = {
            function()
                require("nvterm.terminal").toggle "horizontal"
            end,
            "toggle horizontal term",
        },

        ["<leader>tv"] = {
            function()
                require("nvterm.terminal").toggle "vertical"
            end,
            "toggle vertical term",
        },
    },
}

return M
