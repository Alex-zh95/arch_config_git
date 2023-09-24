local M = {}
M.ui = {
    theme = 'catppuccin',
    statusline = {
        theme='default',
        separator_style='block',
    },
}

M.mappings = require("custom.mappings")

-- Recommended to reference single file for lazy.nvim
M.plugins = "custom.plugins"
return M
