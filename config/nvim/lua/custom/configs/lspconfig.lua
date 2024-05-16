-- Custom configuration for LSP

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

-- Python LSP setup
lspconfig.pylsp.setup{
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

-- Markdown LSP setup
lspconfig.marksman.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

-- C++ LSP setup (clangd)
lspconfig.clangd.setup{
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
}


-- CMake LSP setup
lspconfig.cmake.setup{
    on_attach = on_attach,
    capabilities = capabilities,
}
