# Custom packages

Some extra packages require manual install but because they have makefiles we can pass

```shell
sudo make install
```

to install these packages.

## Rofi wifi menu

This menu serves as a replacement to the nm-applet from NetworkManager. This is needed for window manager environments without a system tray (systray) as nm-applet seems to be callable only from a designated systray.

The script is installable by calling the above make install command within the folder. 

### Dependencies

- Rofi
- Suitable wifi menu theme, located in the rofi configs.  Configuration data in the main Rofi configuration.

```shell
~/.config/rofi/wifi-menu-theme.rasi
```

# fcitx5

Used for seting up character input languages like Chinese. Add to the `etc/environments`:

```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIRS=@im=fcitx
```
Then install `fcitx5`, `fcitx5-configtool`, `fcitx5-gtk`, `fcitx5-rime` for the complete toolset (backend, GUI configuration tool, GUI library and RIME engine).

## Catppuccin for fcitx5

Run script in `.setup/Package_list/themes/fcitx_theme.sh` to install Catppuccin theme into the fcitx5 theme folder.

Then modify the `Theme` variable in `~/.config/fcitx5/conf/classicui.conf` to:

```shell
Theme=catppuccin-macchiato  # or whichever is desired
```

Restart fcitx5 to apply theme via command

```shell
fcitx5 -r
```
