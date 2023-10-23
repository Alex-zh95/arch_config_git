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
                    ignore = {
                        'W605',  -- Ignore invalid escape sequence warning
                        'E501',  -- Ignore line length warning (we have text wrapping enabled)
                        'E402',  -- Ignore file import not at top of line (some scripts need preamble for relative imports)
                    }
                },
                flake8 = {
                    ignore = {
                        'W605',  -- Ignore invalid escape sequence warning
                        'E501',  -- Ignore line length warning (we have text wrapping enabled)
                        'E402',  -- Ignore file import not at top of line (some scripts need preamble for relative imports)
                    }
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
