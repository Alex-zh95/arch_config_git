local M = {}
M.ui = {
    theme = 'catppuccin',
    statusline = {
        theme='default',
        separator_style='block',
    },

    -- Theme overrides
    changed_themes = {
        catppuccin = {
            base_16 = {
                grey_fg = "#eed49f", -- Using yellow for comments
            },

            base_30 = {
                grey_fg = "#eed49f", -- Using yellow for comments
            },
        }
    },

    transparency = true,
}

M.mappings = require("custom.mappings")

-- Recommended to reference single file for lazy.nvim
M.plugins = "custom.plugins"
return M
