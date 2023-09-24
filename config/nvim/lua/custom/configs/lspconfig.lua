-- Custom configuration for LSP

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

-- Python 
require("lspconfig").pylsp.setup{
    on_attach = on_attach,
    capabilities = capabilities,

    -- Custom settings override
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    maxLineLength = 1000,
                },
                flake8 = {
                    maxLineLength = 1000,
                }
            }
        }
    }
}

-- Markdown (marksman)
require("lspconfig").marksman.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}
