# 1 Spotify

Install `spotify` from the Arco repo or AUR and `spicetify` from the AUR.

Permissions for spicetify are needed to modify Spotify's UI. To do so:

```bash
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
```

Ensure a valid user is logged in to Spotify before proceeding.

The backup-restore should have recovered the Catppuccin themes. Otherwise may want to load themes in by copying to `~/.config/spicetify/Themes/`.

To set the color schemes, apply (e.g. Catppuccin-Macchiato):

```bash
spicetify config current_theme catppuccin
spicetify config color_scheme macchiato
spicetify config inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1
spicetify apply 
```

Accent colors can be set by using Spotify's settings page and then selecting an accent color.
