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
        {
    "neovim/nvim-lspconfig",
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
        })

        vim.lsp.config("pyright", {
            capabilities = capabilities,
        })

        vim.lsp.config("bashls", {
            capabilities = capabilities,
        })

        vim.lsp.enable("lua_ls")
        vim.lsp.enable("pyright")
        vim.lsp.enable("bashls")

        vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "<leader>l", vim.lsp.buf.definition, {})
        vim.keymap.set("n", "<leader>j", vim.lsp.buf.code_action, {})
    end,
}
    }
    ,
}
