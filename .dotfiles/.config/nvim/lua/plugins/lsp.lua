return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    --                    "gopls",
                    --                    "clangd",
                    --                    "ts_ls",
                    --                    "cssls",
                    --                    "html",
                    "bashls",
                    --                    "intelephense",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            lspconfig.lua_ls.setup({ capabilities = capabilities })
            lspconfig.pyright.setup({ capabilities = capabilities })
            --            lspconfig.gopls.setup({ capabilities = capabilities })
            --            lspconfig.clangd.setup({ capabilities = capabilities })
            --            lspconfig.ts_ls.setup({ capabilities = capabilities })
            --            lspconfig.cssls.setup({ capabilities = capabilities })
            lspconfig.bashls.setup({ capabilities = capabilities })
            --            lspconfig.intelephense.setup({})
            vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>l", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>j", vim.lsp.buf.code_action, {})
        end,
    },
}
