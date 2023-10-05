import os
import subprocess
from libqtile import qtile, layout, bar, widget, hook
from libqtile.config import Drag, Group, Key, Match, Screen
from libqtile.command import lazy
from extras.upower import UPowerWidget
from extras.location_service import poll_wttr
from libqtile.backend.wayland import InputConfig

# mod4 or mod = super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')

# Common command txts
power_menu_cmd = f"rofi -show power-menu -modi power-menu:rofi-power-menu -theme {home}/.config/rofi/config/powermenu.rasi"
show_window_cmd = f'rofi -show window -theme {home}/.config/rofi/config/window_lst.rasi'

# Define all the default layouts and groups
groups = []
group_dict = {
        "1": "columns",
        "2": "columns",
        "3": "max",
        "4": "floating",
        "5": "columns",
        "6": "columns",
        "7": "max",
        "8": "floating",
        "9": "max",
        "0": "max"
        }

group_names = list(group_dict.keys())
group_labels = group_names
group_layouts = list(group_dict.values())

for i in range(len(group_names)):
    groups.append(
            Group(
                name=group_names[i],
                layout=group_layouts[i].lower(),
                label=group_labels[i],
                ))


@lazy.function
def session_kill(qtile):
    '''
    On activating will kill active windows just as usual but when there are no more running windows, activates the power menu instead

    Functions outside of direct callback cannot use lazy, rely on the qtile object instead. Source found here:

    https://github.com/qtile/qtile/blob/0de37b01b41610efcf41dbad93b6a78ffc20a751/libqtile/core/manager.py#L73
    '''
    nWindows = 0
    for group in qtile.groups:
        nWindows += len(group.windows)

    if nWindows > 0:
        qtile.current_window.kill()
    else:
        qtile.cmd_spawn(power_menu_cmd)


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


keys = [
        Key([mod], "Return", lazy.spawn("alacritty"), desc="Launch terminal"),
        Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Launch rofi launcher"),
        Key([mod], "i", lazy.spawn("hidraw-tog"), desc="Custom program to toggle touchpad."),
        Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle full screen"),
        Key([mod], "q", lazy.window.kill(), desc='Close window'),
        Key([mod], "p", lazy.spawn("pavucontrol"), desc="Launch pavucontrol"),
        Key([mod], "b", lazy.window.bring_to_front(), desc="Bring hidden floating windows behind to front"),
        Key([mod], "m", lazy.spawn(show_window_cmd), desc="Launch rofi window browser"),

        # Screen movement
        Key([mod], 'w', lazy.next_screen(), desc='Next monitor'),
        Key([mod], "e", lazy.prev_screen(), desc='Prev monitor'),

        # TOGGLE SPLIT FUNCTIONS FOR COLUMN/STACK LAYOUT
        Key([mod], "s", lazy.layout.toggle_split(), desc='Toggle column to stack'),

        Key([mod], "t", lazy.spawn("thunar"), desc="Load file explorer UI"),

        Key([mod, "shift"], "Return", lazy.spawn("alacritty -e tmux new-session ranger"), desc="Load file explorer UI"),
        Key([mod, "shift"], "q", lazy.spawn(power_menu_cmd), desc="Power menu"),
        Key([mod, "shift"], "r", lazy.restart()),
        Key([mod, "shift"], "b", lazy.spawn("bluetooth toggle"), desc="Toggle bluetooth radio"),
        Key([mod, "shift"], "w", lazy.spawn("rofi-wifi-menu"), desc="Wifi scan"),

        # Screenshot
        Key([mod, "shift"], "s", lazy.spawn('xfce4-screenshooter -r -o ristretto')),

        # QTILE LAYOUT KEYS
        Key([mod], "space", lazy.next_layout()),
        Key([mod, "shift"], "space", lazy.prev_layout()),

        # CHANGE FOCUS
        Key([mod], "Up", lazy.layout.up()),
        Key([mod], "Down", lazy.layout.down()),
        Key([mod], "Left", lazy.layout.left()),
        Key([mod], "Right", lazy.layout.right()),
        Key([mod], "k", lazy.layout.up()),
        Key([mod], "j", lazy.layout.down()),
        Key([mod], "h", lazy.layout.left()),
        Key([mod], "l", lazy.layout.right()),

        # RESIZE UP, DOWN, LEFT, RIGHT
        Key([mod, "control"], "l",
            lazy.layout.grow_right(),
            lazy.layout.grow(),
            lazy.layout.increase_ratio(),
            lazy.layout.delete(),
            ),
        Key([mod, "control"], "Right",
            lazy.layout.grow_right(),
            lazy.layout.grow(),
            lazy.layout.increase_ratio(),
            lazy.layout.delete(),
            ),
        Key([mod, "control"], "h",
            lazy.layout.grow_left(),
            lazy.layout.shrink(),
            lazy.layout.decrease_ratio(),
            lazy.layout.add(),
            ),
        Key([mod, "control"], "Left",
            lazy.layout.grow_left(),
            lazy.layout.shrink(),
            lazy.layout.decrease_ratio(),
            lazy.layout.add(),
            ),
        Key([mod, "control"], "k",
            lazy.layout.grow_up(),
            lazy.layout.grow(),
            lazy.layout.decrease_nmaster(),
            ),
        Key([mod, "control"], "Up",
            lazy.layout.grow_up(),
            lazy.layout.grow(),
            lazy.layout.decrease_nmaster(),
            ),
        Key([mod, "control"], "j",
            lazy.layout.grow_down(),
            lazy.layout.shrink(),
            lazy.layout.increase_nmaster(),
            ),
        Key([mod, "control"], "Down",
            lazy.layout.grow_down(),
            lazy.layout.shrink(),
            lazy.layout.increase_nmaster(),
            ),

        # MOVE WINDOWS UP OR DOWN (VIM KEYS)
        Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
        Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
        Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
        Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

        # MOVE WINDOWS UP OR DOWN (ARROW KEYS)
        Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
        Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
        Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
        Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),

        Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc='Toggle floating mode'),
]

for i in groups:
    keys.extend([

        # CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        # Key([mod, "shift"], i.name, lazy.window.togroup(
        #    i.name), lazy.group[i.name].toscreen()),
        ])


# Theme color definitions
def init_colors(invert=False):
    result = {
            'background': ['#1e203000', '#1e203000'],
            'alt-foreground': ['#1e2030', '#1e2030'],
            'foreground': ['#cad3f5', '#cad3f5'],
            'green': ['#a6da95', '#a6da95'],
            'red': ['#ed8796', '#ed8796'],
            'yellow': ['#eed49f', '#eed49f'],
            'orange': ['#f5a97f', '#f5a97f'],
            'blue': ['#8aadf4', '#8aadf4'],
            'gray': ['#363a4f', '#363a4f'],
            'gray2': ['#8087a2', '#8087a2'],
            }

    if invert:
        result['foreground'], result['alt-foreground'] = result['alt-foreground'], result['foreground']

    return result


colors = init_colors(invert=False)


def init_default_theme():
    return {
            "margin": [10, 5, 10, 5],
            "border_width": 4,
            "border_focus": colors['foreground'],
            "border_normal": colors['background'],
            'margin_on_single': 0
            }


default_theme = init_default_theme()

column_theme = init_default_theme()
column_theme['border_focus_stack'] = colors['orange']
column_theme['border_normal_stack'] = colors['background']

# Max theme - no margins needed
max_theme = init_default_theme()
max_theme["margin"] = 0
max_theme["border_width"] = 0

floating_layout = layout.Floating(
        float_rules=[
            # Run the utility of `xprop` to see the wm class and name of an X client.
            *layout.Floating.default_float_rules,
            Match(wm_class='confirmreset'),  # gitk
            Match(wm_class='makebranch'),  # gitk
            Match(wm_class='maketag'),  # gitk
            Match(wm_class='ssh-askpass'),  # ssh-askpass
            Match(title='branchdialog'),  # gitk
            Match(title='pinentry'),  # GPG key password entry
            Match(wm_class='Arcolinux-welcome-app.py'),
            Match(wm_class='Archlinux-tweak-tool.py'),
            Match(wm_class='Arcolinux-calamares-tool.py'),
            Match(wm_class='confirm'),
            Match(wm_class='dialog'),
            Match(wm_class='download'),
            Match(wm_class='error'),
            Match(wm_class='file_progress'),
            Match(wm_class='notification'),
            Match(wm_class='splash'),
            Match(wm_class='toolbar'),
            Match(wm_class='Arandr'),
            Match(wm_class='feh'),
            Match(wm_class='Galculator'),
            Match(wm_class='archlinux-logout'),
            Match(wm_class='xfce4-terminal'),
            Match(wm_class='guake'),
            Match(wm_class='pavucontrol'),
            Match(wm_class='tuxedo-control-center'),
            Match(wm_class='io.github.alainm23.planify'),
            ],
        fullscreen_border_width=0,
        border_width=4,
        border_focus=colors['blue'],
        border_normal=colors['background']
        )

layouts = [
        layout.Columns(**column_theme),
        layout.Max(**max_theme),
        floating_layout
        ]


# WIDGETS FOR THE BAR

# # Remark: font size up'd to 24 due to high pixel density
# Initialization of persistent window objects
standard_sep = widget.Sep(
        linewidth=1,
        padding=10,
        foreground=colors['foreground'],
        background=colors['background']
        )

battery_text = UPowerWidget(
        # battery_name=0,
        background=colors['background'],
        foreground=colors['foreground'],
        battery_width=35,
        battery_height=15,
        border_charge_color=colors['green'],
        border_color=colors['foreground'],
        border_critical_color=colors['red'],
        font='JetBrainsMono Nerd Font',
        fontsize=24,
        text_charging='{percentage:.0f}% (󰠠 {ttf})',
        text_discharging='{percentage:.0f}%',
        )

memory_display = widget.Memory(
        font="JetBrainsMono Nerd Font",
        format='  {MemUsed:,.1f}G/{MemTotal:,.1f}G',
        measure_mem='G',
        measure_wap='G',
        update_interval=1,
        fontsize=24,
        foreground=colors['foreground'],
        background=colors['background'],
        mouse_callbacks={'Button1': lazy.spawn(show_window_cmd)},
        padding=4
        )

clock_widget = widget.Clock(
        font="JetBrainsMono Nerd Font",
        foreground=colors['foreground'],
        background=colors['background'],
        fontsize=24,
        padding=1,
        format="  %Y-%m-%d 󰥔 %H:%M "
        )

status_notifier = widget.StatusNotifier(
        background=colors['background'],
        icon_size=32,
        padding=4
        )

volume_control = widget.Volume(
        background=colors['background'],
        foreground=colors['foreground'],
        font='JetBrainsMono Nerd Font',
        fontsize=24,
        fmt='󰓃 {}',
        mouse_callbacks={'Button3': lazy.spawn('pavucontrol')}
        )

wifi_widget = widget.Wlan(
        background=colors['background'],
        foreground=colors['foreground'],
        interface='wlo1',  # Check this string via iwconfig
        font='JetBrainsMono Nerd Font',
        fontsize=24,
        format='   {essid} {percent:2.0%}',
        disconnected_message='󰤮 ',
        mouse_callbacks={'Button1': lazy.spawn('rofi-wifi-menu'), 'Button3': lazy.spawn('nm-connection-editor')}
        )

# Better weather widget than Wttr for querying current location (don't need additiona IP info)
weather_widget = widget.GenPollText(
        background=colors['background'],
        foreground=colors['foreground'],
        font='JetBrainsMono Nerd Font',
        fontsize=24,
        update_interval=1800,
        func=poll_wttr,
        mouse_callbacks={'Button1': lazy.widget["genpolltext"].function(lambda w: w.update(w.poll()))}
        )

spacer = widget.Spacer(
        background=colors['background'],
        length=bar.STRETCH,
        )


def init_widgets_list(screen_id=1) -> list:
    # Initializing widgets that depend on screen and content on screen
    current_layout_icon = widget.CurrentLayoutIcon(
            custom_icon_paths=[home+"/.config/qtile/icons"],
            scale=0.7,
            foreground=colors['foreground'],
            background=colors['background']
            )

    group_box = widget.GroupBox(
            font="JetBrainsMono Nerd Font",
            fontsize=24,
            margin_y=4,
            margin_x=0,
            padding_y=5,
            padding_x=5,
            borderwidth=5,
            disable_drag=True,
            active=colors['foreground'],
            inactive=colors['gray'],
            rounded=False,
            highlight_method="line",
            highlight_color=colors['background'],
            this_current_screen_border=colors['orange'],  # When focused
            this_screen_border=colors['gray'],  # When un-focused
            other_screen_border=colors['gray'],  # When focused
            other_current_screen_border=colors['gray2'],  # When un-focused
            hide_unused=True,
            foreground=colors['foreground'],
            background=colors['background']
            )

    window_name = widget.WindowName(
            foreground=colors['foreground'],
            background=colors['background'],
            font='JetBrainsMono Nerd Font',
            empty_group_string='',
            fontsize=24,
            mouse_callbacks={'Button1': lazy.spawn("rofi -show drun"), 'Button3': lazy.spawn(show_window_cmd)},
            padding=5
            )

    widgets_list = [
            group_box,
            standard_sep,
            current_layout_icon,
            standard_sep,
            weather_widget,
            standard_sep,
            window_name,
            standard_sep,
            battery_text,
            status_notifier,
            volume_control,
            wifi_widget,
            standard_sep,
            memory_display,
            clock_widget,
            ]

    return widgets_list


def init_widgets_screen(screen_id: int = 1):
    widgets_screen = init_widgets_list(screen_id)
    return widgets_screen


def init_screens():
    bar_size = 45
    opacity = 0.75

    return [
            Screen(top=bar.Bar(widgets=init_widgets_screen(1), size=bar_size, opacity=opacity, background='#00000000')),
            Screen(top=bar.Bar(widgets=init_widgets_screen(2), size=bar_size, opacity=opacity, background='#00000000')),
            Screen(top=bar.Bar(widgets=init_widgets_screen(3), size=bar_size, opacity=opacity, background='#00000000'))
            ]


screens = init_screens()


# MOUSE CONFIGURATION - mod-left for move; mod-right or mod-control-left for resize
mouse = [
        Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        Drag([mod, "control"], "Button1", lazy.window.set_size_floating(), start=lazy.window.get_size()),
        Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size())
        ]

dgroups_key_binder = None
dgroups_app_rules = []

main = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')

    # Run the following autostart script only for X11
    if qtile.core.name == "x11":
        subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])


@hook.subscribe.startup
def start_always():
    # In startup also refresh background
    home = os.path.expanduser('~')

    if qtile.core.name == "x11":
        # Set the cursor to something sane in X
        subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])
        subprocess.run(['feh', '--bg-fill', home+'/Bilder/background.png', '&'])


@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for() or window.window.get_wm_type() in floating_types):
        window.floating = True


floating_types = ["notification", "toolbar", "splash", "dialog"]
follow_mouse_focus = False
bring_front_click = True
cursor_warp = False  # From docs: Cursor follows keyboard focus
auto_fullscreen = True
focus_on_window_activation = "smart"  # or focus
wmname = "LG3D"

# Input rules for Wayland sessions
wl_input_rules = {
    "type:keyboard": InputConfig(
        kb_layout='de',
    ),
}
