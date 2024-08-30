local M = {}
M.ui = {
    theme = 'melange',
    statusline = {
        theme='default',
        separator_style='block',
    },

    -- Theme overrides
    -- Brighter UI colors instead of gray
    changed_themes = {
        melange = {
            base_30 = {
                grey_fg = "#f0c6c6",
                one_bg2 = "#75706b",
                line = "#75706b",
            },
        }
    },

    transparency = true,
}

M.mappings = require("custom.mappings")

-- Recommended to reference single file for lazy.nvim
M.plugins = "custom.plugins"
return M
