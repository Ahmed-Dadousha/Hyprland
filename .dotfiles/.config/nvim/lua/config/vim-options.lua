vim.cmd("set expandtab")
vim.cmd("set shiftwidth=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set clipboard+=unnamedplus")
vim.keymap.set("n", "G", "G$", { desc = "Go To Last Letter Of The Buffer", silent = true })
vim.keymap.set("n", "gg", "gg0", { desc = "Go To First Letter Of The Buffer", silent = true })
vim.keymap.set("n", "vG", "vG$", { desc = "Select All Of The Buffer From Bottom To Top", silent = true })
vim.keymap.set("n", "vgg", "vgg0", { desc = "Select All Of The Buffer From Top To Bottom", silent = true })
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Go To Next Tab", silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Go To Previous Tab", silent = true })
vim.keymap.set("i", "<S-Tab>", "<C-d>", { noremap = true, desc = "Unindent", silent = true })


vim.cmd [[ highlight Normal guibg=NONE ctermbg=NONE ]]
vim.cmd [[ highlight NormalNC guibg=NONE ctermbg=NONE ]]


