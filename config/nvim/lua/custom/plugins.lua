local plugins = {
    -- Mason presets (auto-install language features)
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "debugpy",
                "python-lsp-server",
                "pylint",
                "clangd",
                "marksman",
            }
        }
    },

    -- in order to modify ./custom/lspconfig.lua 
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.configs.lspconfig")
            require("custom.configs.lspconfig")
        end,
    },

    -- Treesitter configs for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "cpp",
                "make",
                "python",
                "markdown",
                "json"
            }
        }
    },

    -- debugger
    {
        "mfussenegger/nvim-dap",
        ft = "py", -- activate for python files
        dependencies = {
            "mfussenegger/nvim-dap-python",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
        },
        config = function()
            require("custom.configs.dap").setup()
        end,
    },

    -- easy hopping around based on key-letters
    {
        "phaazon/hop.nvim",
        lazy = false,
        config = function()
            require'hop'.setup()
        end,
    },

    -- keybinds for surrounding text with brackets/quotes/etc
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },

    -- Zen mode 
    {
        "folke/zen-mode.nvim",
        lazy = false,
        config = function()
            require("zen-mode").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },

    -- vim-tmux-navigator (being able to hop to tmux splits from vim via Ctrl keys)
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    -- Better format of markdown text (e.g. tables)
    {
        "junegunn/vim-easy-align",
        ft = "markdown",
    }
}

return plugins
