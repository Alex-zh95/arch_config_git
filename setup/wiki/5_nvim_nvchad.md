# NvChad set up

1. Install neovim
2. Copy over the the configs stored in .config/nvim

To check current keybindings, use the cheatsheet via `<leader>ch`. The leader key by default is the space bar.

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

## Tmux Startup

Default configuration only opens terminal of choice. Script within the package folder that allows for opening tmux with the name of the current directory as session.

```shell
# In setup/Package_list
cp tmux_session.sh ~/.local/bin/
```

This is aliased to the letter "t" from within .zshrc.
