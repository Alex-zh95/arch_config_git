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

-- Font
config.font_size = 8
config.font = wezterm.font_with_fallback {
    'JetBrains Mono',
    'DengXian'
}

-- Tab bar
config.use_fancy_tab_bar = false
config.enable_tab_bar = true

-- Window decorations
config.window_decorations = "NONE"
config.window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 1,
}

config.pane_focus_follows_mouse = true

local function is_vim(pane)
    -- this is set by the plugin, and unset on ExitPre in Neovim
    -- return pane:get_user_vars().IS_NVIM == 'true'
    -- return pane:get_foreground_process_name():find("vim") ~= nil
    return pane:get_title():find("*vim*") ~= nil
end

local direction_keys = {
    Left = 'h',
    Down = 'j',
    Up = 'k',
    Right = 'l',
    -- reverse lookup
    h = 'Left',
    j = 'Down',
    k = 'Up',
    l = 'Right',
}

local function split_nav(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == 'resize' and 'ALT' or 'CTRL',
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                -- pass the keys through to vim/nvim
                if resize_or_move == 'resize' then
                    win:perform_action(
                        wezterm.action.SendKey({
                            key = key,
                            mods = 'ALT'
                        }), pane
                    )
                else
                    win:perform_action(
                        wezterm.action.SendKey({
                            key = key,
                            mods = 'CTRL'
                        }), pane
                    )
                end
            else
                if resize_or_move == 'resize' then
                    win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                else
                    win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                end
            end
        end),
    }
end

-- Keybinds for multiplexing
config.leader = {
    key = 'b',
    mods = 'ALT',
    timeout_milliseconds = 2000
}

config.keys = {
    -- Splits
    {
        mods = "LEADER",
        key = "h",
        action = wezterm.action.SplitHorizontal {domain = 'CurrentPaneDomain'}
    },
    {
        mods = "LEADER",
        key = "v",
        action = wezterm.action.SplitVertical {domain = 'CurrentPaneDomain'}
    },

    -- Maximize/restore pane
    {
        mods = "LEADER",
        key = "f",
        action = wezterm.action.TogglePaneZoomState
    },

    -- Tabs
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.SpawnTab 'CurrentPaneDomain'
    },

    -- Close
    {
        mods = "CTRL",
        key = 'w',
        action = wezterm.action.CloseCurrentPane { confirm = false },
    },

    -- Pane rotation
    {
        mods = "LEADER",
        key = "Space",
        action = wezterm.action.RotatePanes "Clockwise"
    },

    -- Pane swap
    {
        mods = "LEADER",
        key = "Enter",
        action = wezterm.action.PaneSelect {
            mode = 'SwapWithActive',
        },
    },

    -- Copy vim code
    {
        mods = "LEADER",
        key = "[",
        action = wezterm.action.ActivateCopyMode
    },

    -- Pane control:
    -- move between split panes
    split_nav('move', 'h'),
    split_nav('move', 'j'),
    split_nav('move', 'k'),
    split_nav('move', 'l'),
    -- resize panes
    split_nav('resize', 'h'),
    split_nav('resize', 'j'),
    split_nav('resize', 'k'),
    split_nav('resize', 'l'),

    -- Clearing scrollback view and redraw prompt
    {
        mods = "LEADER",
        key = 'l',
        action = wezterm.action.Multiple {
            wezterm.action.ClearScrollback 'ScrollbackAndViewport',
            wezterm.action.SendKey {key = 'L', mods = 'CTRL'},
        }
    }
}

-- and finally, return the configuration to wezterm 
return config
