-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Macchiato'
-- config.color_scheme = 'Catppuccin Mocha'

-- Font
config.font_size = 9
config.font = wezterm.font_with_fallback {
    'JetBrains Mono',
    'Source Hans Sans CN'
}

-- Tab bar
config.use_fancy_tab_bar = false
config.enable_tab_bar = false

-- Window decorations
config.window_decorations = "NONE"
config.window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 1,
}

config.pane_focus_follows_mouse = true
config.scrollback_lines = 1000

config.default_cursor_style = 'SteadyBar'

-- and finally, return the configuration to wezterm 
return config
