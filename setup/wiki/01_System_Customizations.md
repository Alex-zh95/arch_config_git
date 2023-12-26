# Customizations

# Remapping the Caps-Lock key

Following procedure sets up remapping of caps-lock key to escape including Wayland and TTY.

1. Install the caps2esc tool
    ```bash
    pacman -S interception-caps2esc
    ```
2. Set up the intercept rule. Copy the file udevmon.yaml to /etc/.
    ```bash
    sudo cp udevmon.yaml /etc/
    ```

To run it immediately, can use:

```bash
sudo nice -n -20 /usr/bin/udevmon -c /etc/udevmon.yaml
```

## Start-up

Set up a starting unit via systemd. Copy the file caps-to-esc.service to /etc/systemd/system.

```bash
sudo cp caps-to-esc.service /etc/systemd/system
```

Notice that the caps-to-esc.service basically wraps the above run command with systemd syntax.

Now enable and start the service.

```bash
sudo systemctl enable caps-to-esc.service
sudo systemctl start caps-to-esc.service
```

# Font customizations

## GTK

Font customizations are often done within the config files of respective applications. E.g. font settings are in the config.rasi file for Alacritty or font desginations within qtile's `config.py`. For other applications that depend for example on the GTK libraries, we can either use the application "lxappearance" or we can directly modify GTK settings file:

```bash
vim ~/.config/gtk-3.0/settings.ini
```

Themes, fonts, icons can be modified by their respective fields. E.g.

```xml
[Settings]
gtk-theme-name=Arc-Slate-grey-Dark
gtk-icon-theme-name=Nordzy-dark
gtk-font-name=Noto Sans 11
gtk-cursor-theme-name=Dracula-cursors
gtk-cursor-theme-size=0
```

Then log out and log back in to see modifications.

## GTK-4

For GTK-4 it is simpler to set th environment variables in `/etc/environment`. Add the following line (changing the Catppuccin-Macchiato-Standard-Peach-dark element to whatever is desired):

```
GTK_THEME=Catppuccin-Macchiato-Standard-Peach-dark
```

Note this will override the previous GTK setting stored in the user config.

# Hibernation

If hibernating via

```bash
systemctl hibernate
```

results in an immediate reboot, as opposed to a full system shutdown, modify

```bash
vim /etc/systemd/system.conf
```

In this file, find the "[Sleep]" section and write

```conf
[Sleep]
HibernateMode=shutdown
```

# Neovim

We start NeoVim customization via NvChad (credits go to [https://github.com/NvChad/NvChad](NvChad GitHub page) for a good default set-up).

Use following script to get NvChad base (git repo, update via git):

```bash
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
```

Copy the nvim config into the .config directory to get an IDE for Neovim.

## Customizations

Main site reference: [NvChad-Documentation](https://nvchad.com/docs/config/walkthrough)

Customizations of the main NvChad files are in the "custom" subfolder of NvChad (neovim). These files override the defaults set in the core and plugin subfolders. Configs are written in Lua and the main non-custom folders maybe updated to keep with upstream.

## Custom/chadrc.lua 

This file overrides the file "default.lua". Updates here include

- UI themes,
- Status bar color scheme

We also reference other files in the custom configs as needed, such as *Mappings* and *Plugins*.

## Custom/mappings.lua

Override any keybindings for overall application or for a specific plugin. We need to specify the vim mode (normal (n), insert (i) etc) for whch the key-binding is active. The key-bind table includes the actual key bind plus a decription, which is shown in the cheatsheet. An example for toggling the NvimTree:

```lua
-- Start of file
local M = {}
-- ... 

-- Custom toggle for nvimtree
M.nvimtree = {
    plugin = true,
    n = {
        -- toggle
        ["<C-t>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
    }
}

-- ...
return M
-- End of file
```

## Custom/plugins.lua 

The plugin file contains a list of plugins which will be loaded by the Lazy plugin manager. Set-up is stored here, while additional settings are stored in the "./custom/configs" subdirectory.

### LSP Config 

1. Use `:Mason` to install language linters and LSPs. By default, only Lua is enabled. Python is added through this process, `pyslp`. 
2. LSP config within the "./config/custom/lspconfig.lua". Settings and overrides for the LSP is contained within the .setup table for each specific language.

Saved configs here can be auto-installed via the command `:MasonInstallAll`.

[Further documentation](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md)

# fcitx5 (Input methods)

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
