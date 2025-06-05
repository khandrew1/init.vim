vim.g.mapleader = " "

vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

-- paste
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
