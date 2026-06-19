vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<leader>w", ":w<CR>", { desc = "Write buffer" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- File explorer and git keymaps are defined in lua/plugins/init.lua
-- (neo-tree, gitsigns, lazygit, diffview, telescope git_status).
-- Leader key: Space — press Space and wait for which-key hints.
