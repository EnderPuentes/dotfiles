vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<leader>w", ":w<CR>", { desc = "Write buffer" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })
